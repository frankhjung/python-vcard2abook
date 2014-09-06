.DEFAULT_GOAL := help
.PHONY: clean test

help:
	@echo
	@echo "Default goal: ${.DEFAULT_GOAL}"
	@echo "  all: check run test"
	@echo "  check: run pychecker and pep8"
	@echo "  test:  run against test data"
	@echo "  clean: delete all generated files"
	@echo

all: check run test

check:
	# check with PyChecker
	pychecker --only vcf2abook.py
	# check with Pep8
	pep8 --verbose vcf2abook.py

run:
	# run main with verbose to stdout
	python -m vcf2abook test/test.vcf

test:
	# run against test data and check results
	@mkdir -p target
	python -m vcf2abook test/test.vcf target/test.out
	diff test/test.expected target/test.out

clean: 
	# cleaning workspace
	python-coverage erase
	-$(RM) -f *.pyc *.pyo
	# clean generated artifacts
	-$(RM) -rf target

#EOF
