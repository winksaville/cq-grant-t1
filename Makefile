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

.PHONY: help
help: ## This help, default if no target
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

.PHONY: f, format
f: format ## Format with isort, black and flake8
format: ## Format with isort, black and flake8
	isort *.py cq-bolt cq-nut
	black *.py cq-bolt cq-nut
	flake8 *.py cq-bolt cq-nut

.PHONY: p
p: ## Run xxx with python using "make p app=xxx"
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	python ${app}

.PHONY: e
e: ## Run xxx with cq-editor using "make e app=xxx"
	@if [ "${app}" == "" ]; then echo "Expecting 'app=xxx'"; exit 1; fi
	cq-editor ${app}

.PHONY: mypy
mypy: ## Check with mypy
	mypy *.py

.PHONY: t, test
t: test ## Test with pytest
test: ## Test with pytest
	pytest

.PHONY: slice
slice: ## Execute prusa-slicer so gcode can be generated
	prusa-slicer generated/$$(basename ${app} .py).stl

.PHONY: clean
clean: ## Clean files
	rm -rf __pycache__ .pytest_cache .mypy_cache
