include ./_make/print.lib.mk

#------------------------------
# vars
#------------------------------

SHELL := /bin/bash
COMMA := ,

REQUIREMENTS_FILE := requirements
NOTEBOOKS_DIR := notebooks
NOTEBOOKS_LOCAL_DIR := notebooks_local
NOTEBOOKS_REFERENCE_DIR := notebooks_reference

#------------------------------
# help
#------------------------------

.PHONY: help
help:
	@$(call print_h1,"AVAILABLE","OPTIONS")
	@$(call print_space)
	@$(call print_h2,"initialization")
	@$(call print_options,"init","initialize project: create local env, install requirements, ihaskell etc.")
	@$(call print_space)
	@$(call print_h2,"dependency")
	@$(call print_options,"pipcompile","Compile requirements")
	@$(call print_options,"pipinstall","Install requirements")
	@$(call print_space)
	@$(call print_h2,"notebooks")
	@$(call print_options,"serve","Serve notebooks in browser")
	@$(call print_options,"servesb","Serve local (git ignored) notebooks in browser")
	@$(call print_options,"serverf","Serve reference notebooks notebooks in browser")

#------------------------------
# initialization
#------------------------------

.PHONY: init
init: initenv initpip pipcompile pipinstall initihaskell
	@$(call print_h1,"initialization successful")

.PHONY: initenv
initenv:
	@$(call print_h2,"creating local .env file")
	@cp .env.local .env

.PHONY: initpip
initpip:
	@$(call print_h2,"installing pip")
	@pip install --upgrade pip
	@$(call print_h2,"installing pip-tools")
	@pip install pip-tools

.PHONY: initihaskell
initihaskell:
	@$(call print_h2,"installing ihaskell")
	@stack install gtk2hs-buildtools
	@stack install --fast
	@ihaskell install --stack

#------------------------------
# dependency
#------------------------------

.PHONY: pipcompile
pipcompile:
	@$(call print_h2,"compiling requirements")
	@pip-compile $(REQUIREMENTS_FILE).in

.PHONY: pipinstall
pipinstall:
	@$(call print_h2,"installing requirements")
	@if test -e $(REQUIREMENTS_FILE).txt ; \
	then pip install -r $(REQUIREMENTS_FILE).txt ; \
	else echo "missing requirements file, run compile first" ; \
	fi

#------------------------------
# notebooks
#------------------------------

.PHONY: serve
serve:
	@$(call print_h2,"serving notebooks")
	@stack exec jupyter -- notebook --notebook-dir=$(NOTEBOOKS_DIR)

.PHONY: servelc
servelc:
	@$(call print_h2,"serving local (git ignored) notebooks")
	@stack exec jupyter -- notebook --notebook-dir=$(NOTEBOOKS_LOCAL_DIR)

.PHONY: serverf
serverf:
	@$(call print_h2,"serving reference notebooks")
	@stack exec jupyter -- notebook --notebook-dir=$(NOTEBOOKS_REFERENCE_DIR)
