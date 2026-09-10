# ----------------------------
# Makefile Options
# ----------------------------

NAME = SANS
#ICON = icon.png
DESCRIPTION = "Sans Undertale Boss Fight"
COMPRESSED = NO

# Give me my booleans
# God ez80 clang is getting out of date
CFLAGS = -Wall -Wextra -Oz -std=c2x
CXXFLAGS = -Wall -Wextra -Oz

DEPS = $(BINDIR)/SANSFNT.8xv

# ----------------------------

include $(shell cedev-config --makefile)

ASSET_BUILDER := ti-asset-builder$(EXE_SUFFIX)

GENERATED_DIR := $(call NATIVEPATH,src/generated)
SPRITE_OUT_DIR := $(call NATIVEPATH,$(GENERATED_DIR)/sprites)
ASSET_DIR := assets
SPRITE_TABLE := $(call NATIVEPATH,$(ASSET_DIR)/sprites.toml)
# All files that should cause the sprites to regenerate
SPRITE_FILES := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/sprites/*.png)) $(SPRITE_TABLE)

FONTPACK := $(call NATIVEPATH,$(ASSET_DIR)/fontpack.toml)
FONTPACK_NAME := SANSFNT
FONTPACK_BIN_OUT := $(call NATIVEPATH,$(BINDIR)/$(FONTPACK_NAME).bin)
FONTPACK_OUT := $(call NATIVEPATH,$(BINDIR)/$(FONTPACK_NAME).8xv)
# All files that should cause the sprites to regenerate
FONTPACK_FILES := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/font/*/*.png)) $(call NATIVEPATH,$(ASSET_DIR)/fontpack.toml)

# Creates the sprites in the generated directory
$(SPRITE_OUT_DIR): $(SPRITE_FILES)
	$(call RMDIR,$@)
	$(ASSET_BUILDER) sprite -d $(SPRITE_TABLE) -o $@ -t c

$(FONTPACK_BIN_OUT): $(FONTPACK_FILES)
	$(call MKDIR,bin)
	$(ASSET_BUILDER) fontpack -d $(FONTPACK) -o $@ -t binary

$(FONTPACK_OUT): $(FONTPACK_BIN_OUT)
	$(call MKDIR,bin)
	$(CONVBIN) -j bin -k 8xv -i $(FONTPACK_BIN_OUT) -o $@ -n $(FONTPACK_NAME)

.PHONY: generated_files
generated_files: $(SPRITE_OUT_DIR)

.PHONY: clean_generated
clean_generated:
	$(call RMDIR,$(GENERATED_DIR))
