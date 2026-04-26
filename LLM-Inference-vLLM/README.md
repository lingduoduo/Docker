# LLM Inference Optimization Platform

A clean, runnable starter repo for experimenting with LLM serving optimization using **vLLM**, **FastAPI**, micro-batching, quantization-ready config, and benchmark scripts.

This repo is designed as a resume/interview project for LLM infrastructure roles. It helps you measure:

- Throughput: tokens/sec and requests/sec
- Latency: p50/p95/p99
- TTFT-style API latency approximation
- GPU memory usage
- Impact of batching, max tokens, concurrency, and quantization

> Default model is intentionally small so you can run locally or on a modest GPU. You can switch to Llama/Qwen/Mistral models later.

---

## Project Structure

```text
llm-inference-vLLM/
├── app/
│   ├── main.py              # FastAPI serving API
│   ├── config.py            # Environment-based settings
│   ├── engine.py            # vLLM wrapper with mock fallback
│   ├── metrics.py           # Prometheus metrics
│   └── schemas.py           # Request/response models
├── benchmarks/
│   └── benchmark_api.py     # Async load test client
├── scripts/
│   ├── run_server.sh
│   └── run_benchmark.sh
├── docker/
│   └── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── requirements-cpu.txt
└── README.md
```

---

## Quick Start: CPU / No GPU Mock Mode

Use this mode to verify the API and benchmark flow without installing vLLM.

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements-cpu.txt

export USE_MOCK_LLM=true
export MAX_BATCH_SIZE=16
export BATCH_TIMEOUT_MS=20
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Test:

```bash
curl -X POST http://localhost:8000/generate \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Explain KV cache in one paragraph", "max_tokens":80}'
```

Run benchmark:

```bash
python benchmarks/benchmark_api.py --url http://localhost:8000/generate --concurrency 8 --requests 32
```

---

## GPU Mode with vLLM

Install dependencies in a CUDA-enabled environment:

```bash
pip install -r requirements.txt
```

Run with a small model:

```bash
export USE_MOCK_LLM=false
export MODEL_NAME=facebook/opt-125m
export DTYPE=float16
export GPU_MEMORY_UTILIZATION=0.85
export MAX_BATCH_SIZE=16
export BATCH_TIMEOUT_MS=10
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

For stronger resume experiments, switch to models such as:

```bash
export MODEL_NAME=Qwen/Qwen2.5-1.5B-Instruct
# or
export MODEL_NAME=mistralai/Mistral-7B-Instruct-v0.3
```

---

## Quantization Experiments

vLLM supports multiple quantization backends depending on model format and hardware.

Example:

```bash
export QUANTIZATION=awq
export MODEL_NAME=TheBloke/Mistral-7B-Instruct-v0.2-AWQ
```

Then start the server as usual.

Suggested comparison table:

| Experiment | Model | Quantization | Concurrency | Throughput | p95 Latency | GPU Memory |
|---|---|---|---:|---:|---:|---:|
| Baseline | Qwen2.5-1.5B | none | 8 | TBD | TBD | TBD |
| Dynamic batching | Qwen2.5-1.5B | none | 32 | TBD | TBD | TBD |
| Quantized | AWQ model | awq | 32 | TBD | TBD | TBD |

---

## Metrics Endpoint

Prometheus-compatible metrics are exposed at:

```text
GET /metrics
```

Tracked metrics include:

- `llm_requests_total`
- `llm_request_latency_seconds`
- `llm_generated_tokens_total`
- `llm_tokens_per_second`
- `llm_gpu_memory_bytes`
- `llm_batches_total`
- `llm_batch_size`
- `llm_queue_depth`

## Micro-Batching Tuning

The API now queues requests briefly so multiple concurrent calls can be merged into a single backend `generate` call.

- `MAX_BATCH_SIZE`: upper bound on requests grouped together
- `BATCH_TIMEOUT_MS`: how long to wait for more requests before dispatching a batch
- `MAX_QUEUE_SIZE`: backpressure limit before returning `429`

General tuning guidance:

- Lower `BATCH_TIMEOUT_MS` when single-request latency matters more than throughput
- Raise `MAX_BATCH_SIZE` when your GPU has KV-cache headroom and you want higher tokens/sec
- Use the benchmark script at multiple concurrency levels to find the p95/throughput knee

---

## Resume Bullet Template

After running real benchmarks, replace numbers with your measured results:

> Built a FastAPI + vLLM LLM serving platform with dynamic batching, KV-cache-aware inference, quantization experiments, and Prometheus observability; improved throughput by X×, reduced p95 latency by Y%, and lowered GPU memory usage by Z% under controlled benchmark workloads.

