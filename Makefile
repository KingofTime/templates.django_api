DOCKER_BASE = docker compose --env-file .env
DOCKER_EXEC = $(DOCKER_BASE) exec -it api
DOCKER_ROOT_EXEC = $(DOCKER_BASE) exec -it -u root api
POETRY_RUN = $(DOCKER_EXEC) poetry run


build:
	$(DOCKER_BASE) build --no-cache

prune:
	$(DOCKER_BASE) down --rmi all -v --remove-orphans

up:
	$(DOCKER_BASE) up -d

down:
	$(DOCKER_BASE) down

sh:
	$(DOCKER_EXEC) /bin/bash

root-sh:
	$(DOCKER_ROOT_EXEC) /bin/bash

logs:
	$(DOCKER_BASE) logs -f api

attach:
	$(DOCKER_BASE) attach api

shell:
	$(POETRY_RUN) python manage.py shell

makemigrations:
	$(POETRY_RUN) python manage.py makemigrations

migrate:
	$(POETRY_RUN) python manage.py migrate

seed:
	$(POETRY_RUN) python manage.py loaddata seed/*.json
