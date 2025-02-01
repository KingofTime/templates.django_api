FROM python:3.12.8-slim AS base

LABEL name="Template Django API" \
    maintaner="Kingoftime"

ARG UID
ARG GID

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=2.0.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=false \
    POETRY_NO_INTERACTION=1

# Create app user
RUN addgroup --gid $GID template_user
RUN adduser --uid $UID --gid $GID --disabled-password template_user

WORKDIR /home/template_user/app

FROM base AS development

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential curl bash libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && chsh -s /usr/local/bin/bash template_user \
    && curl -sSL https://install.python-poetry.org | POETRY_VERSION=$POETRY_VERSION python3 -
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN poetry config virtualenvs.create false

COPY poetry.lock pyproject.toml README.md ./
RUN poetry lock && poetry install --no-root

USER template_user

EXPOSE 8000
ENTRYPOINT [".docker/entrypoint.sh"]
