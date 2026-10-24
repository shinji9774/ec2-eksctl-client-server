FROM ghcr.io/astral-sh/uv:0.13.5-python3.12-trixie-slim AS installed

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
WORKDIR /ansible-playbook

COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache \
    uv sync --locked --no-install-project

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && \
    apt-get install openssh-client make unzip -y

RUN --mount=type=bind,source=./requirements.yml,target=/tmp/requirements.yml \
    uv run --locked ansible-galaxy collection install -r /tmp/requirements.yml

COPY . /ansible-playbook

CMD ["uv", "run", "--locked", "ansible-playbook", "--version"]
