VERSION = 0.4.0

NPM = npm
NPM_FLAGS = 

CP = cp
CP_FLAGS =

MKDIR = mkdir
MKDIR_OPTS = -p

RM = rm
RM_OPTS = -rf

FIND = find

OUT := out

.PHONY: clean all mrproper

all: $(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).pdf $(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).html $(OUT)/SchicksalhafteSchatten-Charakterbogen-$(VERSION).pdf

$(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).pdf: $(OUT)
	$(MAKE) -C regeln VERSION=$(VERSION) OUT=out out/SchicksalhafteSchatten.pdf
	$(CP) $(CP_FLAGS) regeln/out/SchicksalhafteSchatten.pdf $@

$(OUT)/SchicksalhafteSchatten-Regeln-$(VERSION).html: $(OUT)
	$(MAKE) -C regeln VERSION=$(VERSION) OUT=out out/SchicksalhafteSchatten.html
	$(CP) $(CP_FLAGS) regeln/out/SchicksalhafteSchatten.html $@

$(OUT)/SchicksalhafteSchatten-Charakterbogen-$(VERSION).pdf: $(OUT)
	VERSION=$(VERSION) $(NPM) $(NPM_FLAGS) --prefix charakterbogen i
	VERSION=$(VERSION) $(NPM) $(NPM_FLAGS) --prefix charakterbogen run build
	cp charakterbogen/out/charakterbogen.pdf $@

$(OUT):
	$(MKDIR) $(MKDIR_OPTS) $(OUT)

clean:
	$(RM) $(RM_OPTS) $(OUT)

mrproper:
	$(FIND) . -name "$(OUT)" -type d | xargs rm -rf