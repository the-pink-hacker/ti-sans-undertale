# ----------------------------
# Makefile Options
# ----------------------------

NAME = SANS
#ICON = icon.png
DESCRIPTION = "Sans Undertale Boss Fight"
COMPRESSED = NO

CFLAGS = -Wall -Wextra -Oz -std=c23
CXXFLAGS = -Wall -Wextra -Oz

# ----------------------------

include $(shell cedev-config --makefile)

ASSET_BUILDER := ti-asset-builder$(EXE_SUFFIX)
PYTHON := python$(EXE_SUFFIX)

GENERATED_DIR := $(call NATIVEPATH,src/generated)
SPRITE_OUT_DIR := $(call NATIVEPATH,$(GENERATED_DIR)/sprites.h)
ASSET_DIR := assets
SPRITE_TABLE := $(call NATIVEPATH,$(ASSET_DIR)/sprites.toml)
SPRITE_FILES := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/sprites/*.png))

FONTPACK := $(call NATIVEPATH,$(ASSET_DIR)/fontpack.toml)
FONTPACK_NAME := SANSFNT
FONTPACK_BIN_OUT := $(call NATIVEPATH,$(BINDIR)/$(FONTPACK_NAME).bin)
FONTPACK_OUT := $(call NATIVEPATH,$(BINDIR)/$(FONTPACK_NAME).8xv)
FONTPACK_FILE := $(call NATIVEPATH,$(ASSET_DIR)/fontpack.toml)
FONTPACK_IMAGES := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/font/*/*.png)) 
FONTPACK_FONTS := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/font/*.toml))
FONTPACK_FILES := $(FONTPACK_FILE) $(FONTPACK_IMAGES) $(FONTPACK_FONTS)

GENERATE_SCRIPT := generate.py
LOOKUP_DIR := $(call NATIVEPATH,$(GENERATED_DIR)/lookup)
LOOKUP_BONE_WAVE := $(call NATIVEPATH,$(LOOKUP_DIR)/bone_wave.h)
LOOKUP_BLASTER_4A := $(call NATIVEPATH,$(LOOKUP_DIR)/blaster_4a.h)
LOOKUP_TARGETS := $(LOOKUP_BONE_WAVE) $(LOOKUP_BLASTER_4A)

BLASTER_SPRITE_TABLE_PREFIX := $(call NATIVEPATH,$(ASSET_DIR)/gaster_blaster_sprites_)
BLASTER_SPRITE_BIN_PREFIX := $(call NATIVEPATH,$(BINDIR)/gaster_blaster_sprites_)
BLASTER_SPRITE_TABLES := $(wildcard $(BLASTER_SPRITE_TABLE_PREFIX)*.toml)
BLASTER_NAME := SANSGB
BLASTER_SPRITE_PREFIX := $(call NATIVEPATH,$(BINDIR)/$(BLASTER_NAME))
# I hate make; there's probably a better way...but this works
BLASTER_SPRITE_BIN_FILES := $(subst .toml,.bin,$(BLASTER_SPRITE_TABLES))
BLASTER_SPRITE_FILES := $(patsubst $(BLASTER_SPRITE_TABLE_PREFIX)%.toml,$(BLASTER_SPRITE_PREFIX)%.8xv,$(BLASTER_SPRITE_TABLES))

MAIN_BIN := $(call NATIVEPATH,$(BINDIR)/$(TARGET))

# Creates the sprites in the generated directory
$(SPRITE_OUT_DIR): $(SPRITE_FILES) $(SPRITE_TABLE)
	$(ASSET_BUILDER) sprite -d $(SPRITE_TABLE) -o $(GENERATED_DIR) -t c

$(FONTPACK_BIN_OUT): $(FONTPACK_FILES)
	$(ASSET_BUILDER) fontpack -d $(FONTPACK) -o $@ -t binary

$(FONTPACK_OUT): $(FONTPACK_BIN_OUT)
	$(CONVBIN) -j bin -k 8xv -i $(FONTPACK_BIN_OUT) -o $@ -n $(FONTPACK_NAME) -r

$(BLASTER_SPRITE_BIN_FILES): $(BLASTER_SPRITE_TABLES) $(SPRITE_FILES)
	$(ASSET_BUILDER) sprite -d $(subst .bin,.toml,$@) -o $(BINDIR) -t binary

$(BLASTER_SPRITE_FILES): $(BLASTER_SPRITE_BIN_FILES)
	$(CONVBIN) -j bin -k 8xv -i $(patsubst $(BLASTER_SPRITE_PREFIX)%.8xv,$(BLASTER_SPRITE_BIN_PREFIX)%.bin,$@) -o $@ -n $(patsubst $(BLASTER_SPRITE_PREFIX)%.8xv,$(BLASTER_NAME)%,$@) -r

$(LOOKUP_BONE_WAVE): $(GENERATE_SCRIPT)
	$(PYTHON) $(GENERATE_SCRIPT) bone_wave $(LOOKUP_DIR)

$(LOOKUP_BLASTER_4A): $(GENERATE_SCRIPT)
	$(PYTHON) $(GENERATE_SCRIPT) blaster_4a $(LOOKUP_DIR)

.PHONY: generated_files
generated_files: $(SPRITE_OUT_DIR) $(LOOKUP_TARGETS)

.PHONY: clean_generated
clean_generated:
	$(call RMDIR,$(GENERATED_DIR))

.PHONY: all
all: $(MAIN_BIN) $(FONTPACK_OUT) $(BLASTER_SPRITE_FILES)
