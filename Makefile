.PHONY: help, f, p, e, mypy, t, clean, slice

.DEFAULT_GOAL := help

author="Wink Saville"
app=t1.py

define PRINT_HELP_PYSCRIPT
import re, sys

print("<targets>:")
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help: ## This help, default if no target
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

f: ## Format with isort, black and flake8
	isort *.py cq-bolt cq-nut
	black *.py cq-bolt cq-nut
	flake8 *.py cq-bolt cq-nut

p: ## Run xxx with python using "make p app=xxx"
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	python ${app}

e: ## Run xxx with cq-editor using "make e app=xxx"
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	cq-editor ${app}

mypy: ## Check with mypy
	mypy *.py

t: ## Test with pytest
	pytest

slice: ## Execute prusa-slicer so gcode can be generated
	prusa-slicer generated/$$(basename ${app} .py).stl

clean: ## Clean files
	rm -rf __pycache__ .pytest_cache .mypy_cache
