

CRYSTAL	:= crystal
CRYSTALFLAGS	:=


all:
	@echo Hi

check:
	$(CRYSTAL) $(CRYSTALFLAGS) spec

