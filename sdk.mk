#!/usr/bin/make -f
#
# SPDX-FileCopyrightText: the secureCodeBox authors
#
# SPDX-License-Identifier: Apache-2.0
#
#
# This Makefile is intended to be used for developement and testing only.
# For using this scanner/hook in production please use the helm chart.
# See: <https://www.securecodebox.io/docs/getting-started/installation>
#
# This Makefile expects some additional software to be installed:
# - git
# - node + npm
# - docker
# - kind
# - kubectl
# - helm
# - yq


name = ${sdk}
module = ${sdk}
include ../../test-base.mk
include ../../env-paths.mk
## Telling the env-paths file where the root project dir is. This is done to allow the generation of the paths of the different project folders relative to where the makefile is being run from.
## So BIN_DIR= $(PROJECT_DIR)/bin will be BIN_DIR=../../bin
PROJECT_DIR=../..

.PHONY: docker-build
docker-build: | docker-build-sdk

.PHONY: docker-export
docker-export: | docker-export-sdk

.PHONY: kind-import
kind-import: | kind-import-sdk

.PHONY: docker-build-sdk
docker-build-sdk:
	@echo ".: ⚙️ Build '$(name)'."
	docker build -t $(IMG_NS)/$(name)-nodejs:$(IMG_TAG) .

.PHONY: docker-export-sdk
docker-export-sdk:
	@echo ".: ⚙️ Build '$(name)'."
	docker save $(IMG_NS)/$(name)-nodejs:$(IMG_TAG) -o $(name).tar

.PHONY: kind-import-sdk
kind-import-sdk:
	@echo ".: 💾 Importing the image archive '$(name).tar' to local kind cluster."
	kind load image-archive ./$(name).tar
