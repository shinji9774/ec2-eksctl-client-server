FROM python:3.12-slim-trixie AS base

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

FROM base AS installed

RUN --mount=type=cache,target=/root/.cache \
    pip install --no-cache-dir ansible-core boto3 botocore

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && \
    apt-get install openssh-client make unzip -y

RUN --mount=type=bind,source=./requirements.yml,target=/tmp/requirements.yml \
    ansible-galaxy collection install -r /tmp/requirements.yml

WORKDIR /ansible-playbook
COPY . /ansible-playbook

CMD ["ansible-playbook", "--version"]
