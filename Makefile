define PROJECT_HELP_MSG

Usage:
	make help                   show this message

	make setup                  prepare virtual environment
	make test                   run tests
	make clean                  clean virtual environment
	make pyinstaller            creates an executable package

endef

export PROJECT_HELP_MSG

help:
	@echo -e "$$PROJECT_HELP_MSG"


VENV = venv
export VIRTUAL_ENV := $(abspath ${VENV})
export PATH := ${VIRTUAL_ENV}/bin:${PATH}

define SETUP_DONE

SUCCES - Installed virtual envrionment at ${VIRTUAL_ENV}
Run [source ${VENV}/bin/activate] to activate environment
Run [deactivate] to deactivate environment;

endef

export SETUP_DONE

setup: venv/bin/activate

venv/bin/activate: requirements.txt
	@test -d ${VENV} || python3 -m venv ${VENV} && echo -e "Creating ${VENV}...\n"
	@. ${VENV}/bin/activate; pip install -Ur requirements.txt
	@touch ${VENV}/bin/activate;
	@echo -e "$$SETUP_DONE"

clean:
	rm -rf ${VENV}
	find -iname "*.pyc" -delete

pyinstaller: setup | pyinstaller.spec
	@rm -rf dist build
	. ${VENV}/bin/activate; pyinstaller --clean -y pyinstaller.spec
	@echo -e "\nSUCCESS: Created executable at dist/"
	

test: ${VENV}
	@. ${VENV}/bin/activate; nosetests tests

.PHONY: setup clean test pyinstaller