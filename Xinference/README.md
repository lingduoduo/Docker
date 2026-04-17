# Model Serving with Xinference

This repository demonstrates how to serve large language models using [Xinference](https://github.com/xorbitsai/inference), a powerful and flexible inference framework.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Starting the Server](#starting-the-server)
- [Launching Models](#launching-models)
- [API Usage](#api-usage)
- [Docker](#docker)
- [Examples](#examples)

## Prerequisites

- Python 3.8+
- PyTorch
- Transformers library

## Installation

### vLLM Backend

```bash
pip install torch torchvision torchaudio
pip install "transformers==4.40.2"
pip install "xinference[llamacpp]"
xinference --help
```

## Starting the Server

To start the Xinference server locally:

```bash
xinference-local -H 0.0.0.0 --port 9997
```

## Launching Models

### Launch a model (vLLM)

```bash
xinference launch \
  --model-name qwen2:1.5b \
  --model-format gguf
```

Check available models:

```bash
curl http://127.0.0.1:9997/v1/models
```

## API Usage

Once the model is launched, you can interact with it via the OpenAI-compatible API. See the [Xinference.ipynb](Xinference.ipynb) notebook for a Python example of making chat completion requests.

## Docker

### Pull and Run Xinference with Docker

```bash
docker pull xprobe/xinference

docker save xprobe/xinference > xinfer.tar

docker run -e XINFERENCE_MODEL_SRC=local -p 9002:9997 --gpus all -e API_HOST=0.0.0.0 -v /data/aihub/:/models xprobe/xinference:latest xinference-local -H 0.0.0.0 --log-level debug --port 9997

docker logs -f xinfer
```

