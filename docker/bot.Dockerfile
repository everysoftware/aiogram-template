ARG APP_NAME=app
ARG APP_PATH=/opt/$APP_NAME
ARG PYTHON_VERSION=3.12-bullseye
ARG POETRY_VERSION=1.8.2

#
# Stage: base
#

FROM python:$PYTHON_VERSION AS base
ARG APP_NAME
ARG APP_PATH
ARG POETRY_VERSION

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONFAULTHANDLER=1

ENV POETRY_VERSION=$POETRY_VERSION
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# Set environment
ENV APP_NAME=$APP_NAME
ENV NO_ENV_FILE=1

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$POETRY_HOME/bin:$PATH"

WORKDIR $APP_PATH
COPY ./poetry.lock ./pyproject.toml ./

RUN poetry install --no-dev
RUN poetry export --without-hashes --without dev -f requirements.txt -o requirements.txt

#
# Stage: dev
#
FROM base as dev
ARG APP_NAME
ARG APP_PATH

# Copy files
WORKDIR $APP_PATH
COPY ./$APP_NAME ./$APP_NAME

COPY ./docker/entrypoint-dev.sh /entrypoint-dev.sh
RUN chmod +x /entrypoint-dev.sh
ENTRYPOINT ["/entrypoint-dev.sh"]
CMD ["python -m app"]

#
# Stage: prod
#
FROM python:$PYTHON_VERSION as prod
ARG APP_NAME
ARG APP_PATH

ENV PIP_NO_CACHE_DIR=on
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

WORKDIR $APP_PATH
COPY --from=base $APP_PATH/requirements.txt ./
RUN python -m pip install -r requirements.txt

# Set environment
ENV APP_NAME=$APP_NAME
ENV ENVIRONMENT_SET=1

# Copy files
COPY ./$APP_NAME ./$APP_NAME

# Entrypoint script
COPY ./docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python -m app"]
