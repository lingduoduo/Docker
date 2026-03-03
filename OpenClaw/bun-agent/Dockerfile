FROM oven/bun:latest

WORKDIR /app

RUN bunx clawhub@latest install self-improving-agent

CMD ["bun", "--version"]