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
SPRITE_OUT_DIR := $(call NATIVEPATH,$(GENERATED_DIR)/sprites)
ASSET_DIR := assets
SPRITE_TABLE := $(call NATIVEPATH,$(ASSET_DIR)/sprites.toml)
SPRITE_FILES := $(wildcard $(call NATIVEPATH,$(ASSET_DIR)/sprites/*/*.png))

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

BLASTER_SPRITE_TABLE_PREFIX := $(call NATIVEPATH,$(ASSET_DIR)/gaster_blaster_sprites_)
BLASTER_SPRITE_TABLES := $(wildcard $(BLASTER_SPRITE_TABLE_PREFIX)*.toml)
BLASTER_NAME := SANSGB
BLASTER_SPRITE_PREFIX := $(call NATIVEPATH,$(BINDIR)/$(BLASTER_NAME))
# I hate make; there's probably a better way...but this works
BLASTER_SPRITE_BIN_FILES := $(patsubst $(BLASTER_SPRITE_TABLE_PREFIX)%.toml,$(BLASTER_SPRITE_PREFIX)%.bin,$(BLASTER_SPRITE_TABLES))
BLASTER_SPRITE_FILES := $(patsubst $(BLASTER_SPRITE_TABLE_PREFIX)%.toml,$(BLASTER_SPRITE_PREFIX)%.8xv,$(BLASTER_SPRITE_TABLES))

MAIN_BIN := $(call NATIVEPATH,$(BINDIR)/$(TARGETOBJ))

# Creates the sprites in the generated directory
$(SPRITE_OUT_DIR): $(SPRITE_FILES) $(SPRITE_TABLE)
	$(call RMDIR,$@)
	$(ASSET_BUILDER) sprite -d $(SPRITE_TABLE) -o $@ -t c

$(FONTPACK_BIN_OUT): $(FONTPACK_FILES)
	$(ASSET_BUILDER) fontpack -d $(FONTPACK) -o $@ -t binary

$(FONTPACK_OUT): $(FONTPACK_BIN_OUT)
	$(CONVBIN) -j bin -k 8xv -i $(FONTPACK_BIN_OUT) -o $@ -n $(FONTPACK_NAME)

$(BLASTER_SPRITE_BIN_FILES): $(BLASTER_SPRITE_TABLES) $(SPRITE_FILES)
	$(ASSET_BUILDER) sprite -d $(patsubst $(BLASTER_SPRITE_PREFIX)%.bin,$(BLASTER_SPRITE_TABLE_PREFIX)%.toml,$@) -o $(BINDIR) -t binary

$(BLASTER_SPRITE_FILES): $(BLASTER_SPRITE_BIN_FILES)
	$(CONVBIN) -j bin -k 8xv -i $(subst .8xv,.bin,$@) -o $@ -n $(patsubst $(BLASTER_SPRITE_PREFIX)%.8xv,$(BLASTER_NAME)%,$@)

.PHONY: bone_wave
bone_wave:
	$(call MKDIR,$(LOOKUP_DIR))
	$(PYTHON) $(GENERATE_SCRIPT) bone_wave $(LOOKUP_DIR)

.PHONY: generated_files
generated_files: $(SPRITE_OUT_DIR) bone_wave

.PHONY: clean_generated
clean_generated:
	$(call RMDIR,$(GENERATED_DIR))

.PHONY: all
all: $(MAIN_BIN) $(FONTPACK_BIN_OUT) $(BLASTER_SPRITE_FILES)
