
.PHONY: help
help: ## Display this help message
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@grep --extended-regexp --no-filename '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "	%-20s%s\n", $$1, $$2}'

.poetry.timestamps: pyproject.toml poetry.lock
	poetry --version || pip install --user --ignore-installed --requirement=requirements.txt
	poetry install --extras=tools --extras=generate --extras=extra
	touch $@

.PHONY: prospector
prospector: .poetry.timestamps # Run Prospector check
	poetry run prospector --output=pylint --die-on-tool-error

.PHONY: pyprest
pytest: .poetry.timestamps # Run the unit tests
	poetry run pytest -vv --cov=jsonschema_validate --cov-report=term-missing
