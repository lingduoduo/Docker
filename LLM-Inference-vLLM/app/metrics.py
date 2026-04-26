from prometheus_client import Counter, Histogram, Gauge

REQUESTS_TOTAL = Counter(
    "llm_requests_total",
    "Total LLM generation requests",
)

REQUEST_LATENCY = Histogram(
    "llm_request_latency_seconds",
    "LLM request latency in seconds",
    buckets=(0.05, 0.1, 0.25, 0.5, 1, 2, 5, 10, 30, 60),
)

GENERATED_TOKENS_TOTAL = Counter(
    "llm_generated_tokens_total",
    "Total generated token estimate",
)

TOKENS_PER_SECOND = Gauge(
    "llm_tokens_per_second",
    "Generated tokens per second for the most recent request",
)

GPU_MEMORY_BYTES = Gauge(
    "llm_gpu_memory_bytes",
    "Current allocated GPU memory in bytes, if CUDA is available",
)

BATCHES_TOTAL = Counter(
    "llm_batches_total",
    "Total micro-batches processed by the server",
)

BATCH_SIZE = Histogram(
    "llm_batch_size",
    "Number of requests grouped into a single micro-batch",
    buckets=(1, 2, 4, 8, 16, 32, 64),
)

QUEUE_DEPTH = Gauge(
    "llm_queue_depth",
    "Current number of requests waiting in the batching queue",
)
