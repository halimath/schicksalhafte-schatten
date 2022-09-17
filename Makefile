OUT ?= out

VERSION := 0.4.0

NPM ?= npm
NPM_FLAGS ?= 

MV ?= mv
MV_FLAGS ?=

MKDIR ?= mkdir
MKDIR_OPTS ?= -p

RM ?= rm
RM_OPTS ?= -rf

FIND ?= find

PODMAN ?= podman
CONTAINER_IMAGE_REGELN := schicksalhafte-schatten-regeln
CONTAINER_IMAGE_CHARAKTERBOGEN := schicksalhafte-schatten-charakterbogen

.PHONY: clean all regeln charakterbogen $(CONTAINER_IMAGE_REGELN) $(CONTAINER_IMAGE_CHARAKTERBOGEN)

all: $(CONTAINER_IMAGE_REGELN) $(CONTAINER_IMAGE_CHARAKTERBOGEN) regeln charakterbogen

regeln: $(OUT)
	$(PODMAN) run --rm -it -v "$(shell pwd)/regeln:/src" -v "$(shell pwd)/out:/out" $(CONTAINER_IMAGE_REGELN)
	$(MV) $(MV_FLAGS) $(OUT)/SchicksalhafteSchatten.pdf $(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).pdf
	$(MV) $(MV_FLAGS) $(OUT)/SchicksalhafteSchatten.html $(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).html

charakterbogen: $(OUT)
	$(PODMAN) run --rm -it -v "$(shell pwd)/charakterbogen/src:/src" -v "$(shell pwd)/out:/out" $(CONTAINER_IMAGE_CHARAKTERBOGEN)
	$(MV) $(MV_FLAGS) $(OUT)/charakterbogen.pdf $(OUT)/charakterbogen-$(VERSION).pdf


# $(OUT)/SchicksalhafteSchatten-Charakterbogen-$(VERSION).pdf: $(OUT)
# 	VERSION=$(VERSION) $(NPM) $(NPM_FLAGS) --prefix charakterbogen i
# 	VERSION=$(VERSION) $(NPM) $(NPM_FLAGS) --prefix charakterbogen run build
# 	cp charakterbogen/out/charakterbogen.pdf $@

$(OUT):
	$(MKDIR) $(MKDIR_OPTS) $(OUT)

$(CONTAINER_IMAGE_REGELN):
	$(PODMAN) build -f regeln/Containerfile -t $(CONTAINER_IMAGE_REGELN) regeln

$(CONTAINER_IMAGE_CHARAKTERBOGEN):
	$(PODMAN) build -f charakterbogen/Containerfile -t $(CONTAINER_IMAGE_CHARAKTERBOGEN) charakterbogen

clean:
	$(RM) $(RM_OPTS) $(OUT)
