```
docker --version

docker pull sgccr.ccs.tencentyun.com/openclaw/openclaw:latest

docker rm -f openclaw  
docker volume rm openclaw-data
docker volume create openclaw-data

docker run --rm \
  -v openclaw-data:/data \
  -e OPENCLAW_STATE_DIR=/data/state \
  -e OPENCLAW_CONFIG_PATH=/data/config.toml \
  sgccr.ccs.tencentyun.com/openclaw/openclaw:latest \
  openclaw config set gateway.mode local


docker run --rm \
  -v openclaw-data:/data \
  -e OPENCLAW_STATE_DIR=/data/state \
  -e OPENCLAW_CONFIG_PATH=/data/config.toml \
  sgccr.ccs.tencentyun.com/openclaw/openclaw:latest \
  openclaw config get gateway.mode


docker rm -f openclaw 2>/dev/null || true

docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -p 18789:18789 \
  -v openclaw-data:/data \
  -e OPENCLAW_STATE_DIR=/data/state \
  -e OPENCLAW_CONFIG_PATH=/data/config.toml \
  sgccr.ccs.tencentyun.com/openclaw/openclaw:latest \
  openclaw gateway --port 18789

docker ps | grep openclaw

docker logs -n 100 openclaw

```

http://localhost:18789


```
docker stop openclaw

docker start openclaw

docker logs -f openclaw

docker exec -it openclaw openclaw status

docker pull sgccr.ccs.tencentyun.com/openclaw/openclaw:latest
docker rm -f openclaw


docker rm -f openclaw 2>/dev/null || true
docker volume rm openclaw-data
docker volume create openclaw-data

```

