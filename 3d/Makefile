OPENSCAD := /mnt/c/Program\ Files/OpenSCAD/openscad.exe

%.stl: %.scad
	@echo GEN $@
	@${OPENSCAD} -o $@ -D '$$fn=180' $< >/dev/null 2>&1

all: $(patsubst %.scad,%.stl,$(wildcard *.scad))

clean:
	$(RM) *.stl

.PHONY: all clean
.DEFAULT_GOAL := all
