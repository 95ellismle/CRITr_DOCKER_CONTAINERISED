.PHONY: docs clean

COMMAND = docker-compose run --rm djangoapp /bin/bash -c

all: init build test

build:
	docker-compose build

run:
	./change_to_deploy.sh; docker-compose up

migrate:
	$(COMMAND) 'cd critr; python3 manage.py makemigrations; python3 manage.py migrate'

collectstatic:
	$(COMMAND) 'cd critr; python3 manage.py collectstatic --no-input'

createsuperuser:
	$(COMMAND) "cd critr; python3 manage.py createsuperuser"

help:
	$(COMMAND) "cd critr; python3 manage.py help"

init:
	dd if=/dev/urandom bs=60 count=1 | base64 > critr/secret.key

check: checksafety checkstyle

test:
	$(COMMAND) "pip install tox && tox -e test"

checksafety:
	$(COMMAND) "pip install tox && tox -e checksafety"

checkstyle:
	$(COMMAND) "pip install tox && tox -e checkstyle"

coverage:
	$(COMMAND) "pip install tox && tox -e coverage"

clean:
	rm -rf build
	rm -rf critr.egg-info
	rm -rf dist
	rm -rf htmlcov
	rm -rf .tox
	rm -rf .cache
	rm -rf .pytest_cache
	find . -type f -name "*.pyc" -delete
	rm -rf $(find . -type d -name __pycache__)
	rm .coverage
	rm .coverage.*

dockerclean:
	docker system prune -f
	docker system prune -f --volumes
