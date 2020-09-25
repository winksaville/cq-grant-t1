.PHONY: help, format, f, p, e, mypy, t, clean, slice

.DEFAULT_GOAL := help

author="Wink Saville"
app=t1.py

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


format: f ## Format
f:
	isort *.py cq-bolt cq-nut
	black *.py cq-bolt cq-nut
	flake8 *.py cq-bolt cq-nut

p: ## Run with python
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	python ${app}

e: ## Run with cq-editor
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	cq-editor ${app}

mypy: ## check with mypy
	mypy *.py

t: ## test
	pytest

slice:
	prusa-slicer generated/$$(basename ${app} .py).stl

clean: ## clean files
