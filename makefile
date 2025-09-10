# ----------------------------
# Makefile Options
# ----------------------------

NAME = SANS
#ICON = icon.png
DESCRIPTION = "Sans Undertale Boss Fight"
COMPRESSED = NO

CFLAGS = -Wall -Wextra -Oz
CXXFLAGS = -Wall -Wextra -Oz

# ----------------------------

include $(shell cedev-config --makefile)
