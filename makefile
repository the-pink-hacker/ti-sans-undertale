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

EXTRA_CLEAN = cargo clean --manifest-path $(ASSET_BUILDER_MANIFEST)
# TODO: Generated aren't showing to the complier on first run
#DEPS = generated_files

# ----------------------------

include $(shell cedev-config --makefile)

ASSET_BUILDER_DIR := asset-builder
ASSET_BUILDER_MANIFEST := $(ASSET_BUILDER_DIR)/Cargo.toml
ASSET_BUILDER_EXE := $(ASSET_BUILDER_DIR)/target/release/asset-builder$(EXE_SUFFIX)
# All files that should cause a rebuild
ASSET_BUILDER_FILES := $(ASSET_BUILDER_MANIFEST) $(ASSET_BUILDER_DIR)/Cargo.lock $(wildcard $(ASSET_BUILDER_DIR)/src/*.rs)

GENERATED_DIR := src/generated
SPRITE_OUT_DIR := $(GENERATED_DIR)/sprites
ASSET_DIR := assets
SPRITE_TABLE := $(ASSET_DIR)/sprites.toml
# All files that should cause the sprites to regenerate
SPRITE_FILES := $(wildcard $(ASSET_DIR)/sprites/*.png) $(SPRITE_TABLE)

# Builds the asset builder
$(ASSET_BUILDER_EXE): $(ASSET_BUILDER_FILES)
	cargo build --manifest-path $(ASSET_BUILDER_MANIFEST) -r

# Creates the sprites in the generated directory
$(SPRITE_OUT_DIR): $(ASSET_BUILDER_EXE) $(SPRITE_FILES)
	rm -rf $@
	$(ASSET_BUILDER_EXE) sprites $(SPRITE_TABLE) $@

.PHONY: generated_files
generated_files: $(SPRITE_OUT_DIR)

.PHONY: clean_generated
clean_generated:
	rm -rf $(GENERATED_DIR)
