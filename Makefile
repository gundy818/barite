
AMEBA	:= bin/ameba
AMEBAFLAGS	:=

CRYSTAL	:= crystal
CRYSTALFLAGS	:=


all:
	@echo Hi

check_ameba:
	@echo Lint checks
	$(AMEBA) $(AMEBAFLAGS)

functional_tests:
	@echo "Functional tests"
	$(CRYSTAL) $(CRYSTALFLAGS) spec spec/*cr

unit_tests:
	@echo "Unit tests"
	$(CRYSTAL) $(CRYSTALFLAGS) spec --error-trace spec/unit/*cr

# static tests are all local, they don't touch Backblaze, so should be cheap and fast.
static_tests:	check_ameba unit_tests

# the tests should only run the functional tests (which actually touch Backblaze)
# if all the static tests pass.
check:	static_tests functional_tests

doc:
	$(CRYSTAL) $(CRYSTALFLAGS) doc

.PHONY:	check_ameba doc static_tests unit_tests functional_tests

