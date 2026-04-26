#!/usr/bin/env bash
set -euo pipefail

python benchmarks/benchmark_api.py \
  --url http://localhost:8000/generate \
  --concurrency "${CONCURRENCY:-8}" \
  --requests "${REQUESTS:-32}" \
  --max-tokens "${MAX_TOKENS:-128}"
