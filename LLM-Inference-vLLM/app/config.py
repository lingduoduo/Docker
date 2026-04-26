from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    model_name: str = "facebook/opt-125m"
    use_mock_llm: bool = True
    dtype: str = "float16"
    quantization: str | None = None
    gpu_memory_utilization: float = 0.85
    max_model_len: int = 2048
    default_temperature: float = 0.7
    default_max_tokens: int = 128
    max_batch_size: int = 16
    batch_timeout_ms: int = 20
    max_queue_size: int = 1024

    class Config:
        env_prefix = ""
        case_sensitive = False


settings = Settings()
