#!/usr/bin/env bash
set -euo pipefail

export USE_MOCK_LLM=${USE_MOCK_LLM:-true}
export MODEL_NAME=${MODEL_NAME:-facebook/opt-125m}
export DTYPE=${DTYPE:-float16}
export GPU_MEMORY_UTILIZATION=${GPU_MEMORY_UTILIZATION:-0.85}

uvicorn app.main:app --host 0.0.0.0 --port 8000
