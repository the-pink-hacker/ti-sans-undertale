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

# TODO: Generated aren't showing to the complier on first run
#DEPS = generated_files

# ----------------------------

include $(shell cedev-config --makefile)

GENERATED_DIR := src/generated
SPRITE_OUT_DIR := $(GENERATED_DIR)/sprites
ASSET_DIR := assets
SPRITE_TABLE := $(ASSET_DIR)/sprites.toml
# All files that should cause the sprites to regenerate
SPRITE_FILES := $(wildcard $(ASSET_DIR)/sprites/*.png) $(SPRITE_TABLE)

# Creates the sprites in the generated directory
$(SPRITE_OUT_DIR): $(SPRITE_FILES)
	rm -rf $@
	ti-asset-builder sprite -d $(SPRITE_TABLE) -o $@ -t c

.PHONY: generated_files
generated_files: $(SPRITE_OUT_DIR)

.PHONY: clean_generated
clean_generated:
	rm -rf $(GENERATED_DIR)
