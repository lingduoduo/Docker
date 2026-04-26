import asyncio
import time
from dataclasses import dataclass

from fastapi import FastAPI, HTTPException
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response

from app.config import settings
from app.engine import build_engine
from app.metrics import (
    BATCHES_TOTAL,
    BATCH_SIZE,
    REQUESTS_TOTAL,
    REQUEST_LATENCY,
    GENERATED_TOKENS_TOTAL,
    TOKENS_PER_SECOND,
    GPU_MEMORY_BYTES,
    QUEUE_DEPTH,
)
from app.schemas import GenerateRequest, GenerateResponse

app = FastAPI(title="LLM Inference vLLM Platform")
engine = build_engine()

try:
    import torch
except ImportError:  # pragma: no cover - depends on local runtime packaging
    torch = None


@dataclass
class PendingRequest:
    payload: GenerateRequest
    enqueued_at: float
    future: asyncio.Future


request_queue: asyncio.Queue[PendingRequest] = asyncio.Queue(maxsize=settings.max_queue_size)
batch_worker_task: asyncio.Task | None = None


async def process_batch(batch: list[PendingRequest]) -> None:
    if not batch:
        return

    batch_size = len(batch)
    BATCHES_TOTAL.inc()
    BATCH_SIZE.observe(batch_size)
    QUEUE_DEPTH.set(request_queue.qsize())

    try:
        results = await asyncio.to_thread(
            engine.generate_batch,
            [item.payload.prompt for item in batch],
            batch[0].payload.max_tokens,
            batch[0].payload.temperature,
        )
    except Exception as exc:
        for item in batch:
            if not item.future.done():
                item.future.set_exception(exc)
        return

    for item, result in zip(batch, results):
        total_latency = time.perf_counter() - item.enqueued_at
        REQUESTS_TOTAL.inc()
        REQUEST_LATENCY.observe(total_latency)
        GENERATED_TOKENS_TOTAL.inc(result.output_tokens_estimate)
        TOKENS_PER_SECOND.set(result.tokens_per_second)
        if torch is not None and torch.cuda.is_available():
            GPU_MEMORY_BYTES.set(torch.cuda.memory_allocated())

        response = GenerateResponse(
            text=result.text,
            model=settings.model_name,
            prompt_tokens_estimate=result.prompt_tokens_estimate,
            output_tokens_estimate=result.output_tokens_estimate,
            latency_seconds=total_latency,
            tokens_per_second=result.tokens_per_second,
        )
        if not item.future.done():
            item.future.set_result(response)


async def batch_worker() -> None:
    timeout_seconds = settings.batch_timeout_ms / 1000
    carry_over_item: PendingRequest | None = None
    while True:
        fetched_from_queue = 0
        if carry_over_item is not None:
            first_item = carry_over_item
            carry_over_item = None
        else:
            first_item = await request_queue.get()
            fetched_from_queue += 1
        batch = [first_item]
        batch_deadline = time.perf_counter() + timeout_seconds

        while len(batch) < settings.max_batch_size:
            remaining = batch_deadline - time.perf_counter()
            if remaining <= 0:
                break
            try:
                item = await asyncio.wait_for(request_queue.get(), timeout=remaining)
            except asyncio.TimeoutError:
                break
            fetched_from_queue += 1
            if (
                item.payload.max_tokens == first_item.payload.max_tokens
                and item.payload.temperature == first_item.payload.temperature
            ):
                batch.append(item)
            else:
                carry_over_item = item
                break

        QUEUE_DEPTH.set(request_queue.qsize())
        await process_batch(batch)
        for _ in range(fetched_from_queue):
            request_queue.task_done()


@app.on_event("startup")
async def startup_event() -> None:
    global batch_worker_task
    if batch_worker_task is None or batch_worker_task.done():
        batch_worker_task = asyncio.create_task(batch_worker())


@app.on_event("shutdown")
async def shutdown_event() -> None:
    global batch_worker_task
    if batch_worker_task is not None:
        batch_worker_task.cancel()
        try:
            await batch_worker_task
        except asyncio.CancelledError:
            pass
        batch_worker_task = None


@app.get("/health")
def health():
    return {
        "status": "ok",
        "model": settings.model_name,
        "mock_mode": settings.use_mock_llm,
        "quantization": settings.quantization,
        "max_batch_size": settings.max_batch_size,
        "batch_timeout_ms": settings.batch_timeout_ms,
        "queue_depth": request_queue.qsize(),
    }


@app.post("/generate", response_model=GenerateResponse)
async def generate(request: GenerateRequest):
    try:
        loop = asyncio.get_running_loop()
        future: asyncio.Future = loop.create_future()
        request_queue.put_nowait(
            PendingRequest(
                payload=request,
                enqueued_at=time.perf_counter(),
                future=future,
            )
        )
        QUEUE_DEPTH.set(request_queue.qsize())
        return await future
    except asyncio.QueueFull as exc:
        raise HTTPException(status_code=429, detail="Inference queue is full") from exc


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)
