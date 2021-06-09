
AMEBA	:= bin/ameba
AMEBAFLAGS	:=

CRYSTAL	:= crystal
CRYSTALFLAGS	:=


all:
	@echo Hi

check_ameba:
	$(AMEBA) $(AMEBAFLAGS)

check_spec:
	$(CRYSTAL) $(CRYSTALFLAGS) spec

check:	check_ameba check_spec

doc:
	$(CRYSTAL) $(CRYSTALFLAGS) doc

.PHONY:	check_ameba check_spec doc

