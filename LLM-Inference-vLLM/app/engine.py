import time
from dataclasses import dataclass

from app.config import settings


@dataclass
class GenerationResult:
    text: str
    prompt_tokens_estimate: int
    output_tokens_estimate: int
    latency_seconds: float
    tokens_per_second: float


class MockLLMEngine:
    """Fast local fallback so the repo is runnable without GPU/vLLM."""

    def generate(self, prompt: str, max_tokens: int, temperature: float) -> GenerationResult:
        return self.generate_batch([prompt], max_tokens=max_tokens, temperature=temperature)[0]

    def generate_batch(
        self, prompts: list[str], max_tokens: int, temperature: float
    ) -> list[GenerationResult]:
        start = time.perf_counter()
        batch_size = max(len(prompts), 1)
        # Simulate batching efficiency: a larger batch amortizes fixed decode overhead.
        time.sleep(min(0.03 + max_tokens * 0.0008 + batch_size * 0.002, 0.5))
        latency = time.perf_counter() - start
        results: list[GenerationResult] = []
        for prompt in prompts:
            text = (
                "Mock response: KV cache stores attention keys/values from previous tokens, "
                "so the model avoids recomputing the entire prefix during decoding."
            )
            output_tokens = min(max_tokens, len(text.split()))
            results.append(
                GenerationResult(
                    text=text,
                    prompt_tokens_estimate=len(prompt.split()),
                    output_tokens_estimate=output_tokens,
                    latency_seconds=latency,
                    tokens_per_second=output_tokens / latency if latency > 0 else 0.0,
                )
            )
        return results


class VLLMEngine:
    def __init__(self) -> None:
        from vllm import LLM

        kwargs = {
            "model": settings.model_name,
            "dtype": settings.dtype,
            "gpu_memory_utilization": settings.gpu_memory_utilization,
            "max_model_len": settings.max_model_len,
        }
        if settings.quantization:
            kwargs["quantization"] = settings.quantization

        self.llm = LLM(**kwargs)

    def generate(self, prompt: str, max_tokens: int, temperature: float) -> GenerationResult:
        return self.generate_batch([prompt], max_tokens=max_tokens, temperature=temperature)[0]

    def generate_batch(
        self, prompts: list[str], max_tokens: int, temperature: float
    ) -> list[GenerationResult]:
        from vllm import SamplingParams

        start = time.perf_counter()
        sampling_params = SamplingParams(
            temperature=temperature,
            max_tokens=max_tokens,
        )
        outputs = self.llm.generate(prompts, sampling_params)
        latency = time.perf_counter() - start
        results: list[GenerationResult] = []
        for prompt, output in zip(prompts, outputs):
            text = output.outputs[0].text
            output_tokens = len(output.outputs[0].token_ids or [])
            results.append(
                GenerationResult(
                    text=text,
                    prompt_tokens_estimate=len(prompt.split()),
                    output_tokens_estimate=output_tokens,
                    latency_seconds=latency,
                    tokens_per_second=output_tokens / latency if latency > 0 else 0.0,
                )
            )
        return results


def build_engine():
    if settings.use_mock_llm:
        return MockLLMEngine()
    return VLLMEngine()
