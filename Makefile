include ./_make/print.lib.mk

#------------------------------
# vars
#------------------------------

SHELL := /bin/bash
COMMA := ,

REQUIREMENTS_FILE := requirements
NOTEBOOKS_DIR := notebooks
NOTEBOOKS_REQUIREMENTS_FILE := $(NOTEBOOKS_DIR)/$(REQUIREMENTS_FILE)

# a list of all .in files
REQUIREMENTS_FILES = $(REQUIREMENTS_FILE).in $(NOTEBOOKS_REQUIREMENTS_FILE).in

# a list of .txt files for each .in (will be used to create .txt files)
REQUIREMENTS_FILE_OUTPUTS := $(REQUIREMENTS_FILES:.in=.txt)

#------------------------------
# help
#------------------------------

.PHONY: help
help:
	@$(call print_h1,"AVAILABLE","OPTIONS")
	@$(call print_space)
	@$(call print_h2,"initialization")
	@$(call print_options,"init","initialize project: create local env and install requirements etc.")
	@$(call print_space)
	@$(call print_h2,"dependency")
	@$(call print_options,"pipcompile","Compile requirements")
	@$(call print_options,"pipinstall","Install requirements")
	@$(call print_space)
	@$(call print_h2,"notebooks")
	@$(call print_options,"serve","Serve notebooks in browser")

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

# recipes for how to build .txt files
%.txt: %.in
	@pip-compile -v --output-file $@ $<

# dependencies
$(NOTEBOOKS_REQUIREMENTS_FILE).txt: $(REQUIREMENTS_FILE).txt

# builds all .txt files from requirement .in files
.PHONY: pipcompile
pipcompile: $(REQUIREMENTS_FILE_OUTPUTS)

.PHONY: pipinstall
pipinstall:
# root requirements txt does not exists, so prompt user to run compile
ifeq (,$(wildcard $(REQUIREMENTS_FILE).txt))
	@$(call print_warning,"Requirements are not compiled run make pipcompile first")
# no requirements found in notebooks directory so just install root requirements
else ifeq (,$(wildcard $(NOTEBOOKS_REQUIREMENTS_FILE).in)$(wildcard $(NOTEBOOKS_REQUIREMENTS_FILE).txt))
	@$(call print_h1,"INSTALLING","ROOT","REQUIREMENTS")
	@pip3 install -r $(REQUIREMENTS_FILE).txt
# requirements in found in notebooks directory, but no txt, so prompt user to run compile
else ifeq (,$(wildcard $(NOTEBOOKS_REQUIREMENTS_FILE).txt))
	@$(call print_warning,"Your notebook specific requirements are not compiled run make pipcompile first")
else
	@$(call print_h1,"INSTALLING","ROOT AND NOTEBOOK","REQUIREMENTS")
	@pip3 install -r $(NOTEBOOKS_REQUIREMENTS_FILE).txt
endif

#------------------------------
# notebooks
#------------------------------

.PHONY: serve
serve:
	@$(call print_h2,"serving notebooks")
	@stack exec jupyter -- notebook --notebook-dir=$(NOTEBOOKS_DIR)
