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

# ----------------------------

include $(shell cedev-config --makefile)
