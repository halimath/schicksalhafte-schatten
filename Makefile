VERSION := 0.1.0

OUT := out

RM = rm
RM_OPTS = -rf

MKDIR = mkdir
MKDIR_OPTS = -p

PODMAN = podman

IMAGE_NAME = asciidoctor
IMAGE_TAG = latest

.PHONY: clean container-image all

all: container-image $(OUT)/SchicksalhafteSchatten.pdf $(OUT)/SchicksalhafteSchatten.html $(OUT)/NSC.pdf $(OUT)/NSC.html

$(OUT)/%.pdf: src/%.adoc $(OUT)
	$(PODMAN) run --rm -it -v "$(PWD)/src:/src:Z" -v "$(PWD)/out:/out:Z" $(IMAGE_NAME):$(IMAGE_TAG) pdf -o $@ $<

$(OUT)/%.html: src/%.adoc $(OUT)
	$(PODMAN) run --rm -it -v "$(PWD)/src:/src:Z" -v "$(PWD)/out:/out:Z" $(IMAGE_NAME):$(IMAGE_TAG) html -o $@ $<

container-image:
	$(PODMAN) build -f .container/Containerfile -t $(IMAGE_NAME):$(IMAGE_TAG) .

$(OUT):
	$(MKDIR) $(MKDIR_OPTS) $(OUT)

clean:
	$(RM) $(RM_OPTS) $(OUT)
