#!/bin/sh

if [ "$APP_ENVIRONMENT" = "development" ]; then
    poetry install
    poetry run python manage.py flush --no-input
    poetry run python manage.py migrate
    poetry run python manage.py createsuperuser --noinput --username ${DJANGO_SUPERUSER_NAME} --email ${DJANGO_SUPERUSER_EMAIL}
    poetry run python manage.py loaddata seed/*.json
else
    python manage.py migrate
fi

exec "$@"