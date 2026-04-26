import argparse
import asyncio
import statistics
import time
from typing import Any

import aiohttp


PROMPTS = [
    "Explain KV cache in LLM inference.",
    "What is PagedAttention and why does it matter?",
    "Summarize the tradeoff between latency and throughput.",
    "Explain 4-bit quantization for large language models.",
]


async def send_one(session: aiohttp.ClientSession, url: str, prompt: str, max_tokens: int) -> dict[str, Any]:
    start = time.perf_counter()
    async with session.post(
        url,
        json={"prompt": prompt, "max_tokens": max_tokens, "temperature": 0.7},
        timeout=aiohttp.ClientTimeout(total=120),
    ) as resp:
        data = await resp.json()
        end = time.perf_counter()
        return {
            "status": resp.status,
            "latency": end - start,
            "output_tokens": data.get("output_tokens_estimate", 0),
            "tokens_per_second": data.get("tokens_per_second", 0.0),
        }


async def run_benchmark(url: str, concurrency: int, requests: int, max_tokens: int):
    connector = aiohttp.TCPConnector(limit=concurrency)
    async with aiohttp.ClientSession(connector=connector) as session:
        sem = asyncio.Semaphore(concurrency)

        async def bounded(i: int):
            async with sem:
                return await send_one(session, url, PROMPTS[i % len(PROMPTS)], max_tokens)

        start = time.perf_counter()
        results = await asyncio.gather(*[bounded(i) for i in range(requests)])
        wall_time = time.perf_counter() - start

    latencies = [r["latency"] for r in results]
    output_tokens = sum(r["output_tokens"] for r in results)
    success = sum(1 for r in results if r["status"] == 200)

    def pct(values, p):
        if not values:
            return 0.0
        values = sorted(values)
        idx = min(len(values) - 1, int(len(values) * p / 100))
        return values[idx]

    print("\n=== Benchmark Results ===")
    print(f"URL: {url}")
    print(f"Requests: {requests}")
    print(f"Concurrency: {concurrency}")
    print(f"Success: {success}/{requests}")
    print(f"Wall time: {wall_time:.3f}s")
    print(f"Requests/sec: {requests / wall_time:.2f}")
    print(f"Output tokens/sec: {output_tokens / wall_time:.2f}")
    print(f"Latency avg: {statistics.mean(latencies):.3f}s")
    print(f"Latency p50: {pct(latencies, 50):.3f}s")
    print(f"Latency p95: {pct(latencies, 95):.3f}s")
    print(f"Latency p99: {pct(latencies, 99):.3f}s")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default="http://localhost:8000/generate")
    parser.add_argument("--concurrency", type=int, default=8)
    parser.add_argument("--requests", type=int, default=32)
    parser.add_argument("--max-tokens", type=int, default=128)
    args = parser.parse_args()

    asyncio.run(run_benchmark(args.url, args.concurrency, args.requests, args.max_tokens))


if __name__ == "__main__":
    main()
