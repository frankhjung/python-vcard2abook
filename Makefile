.DEFAULT_GOAL := help
.PHONY: clean test

help:
	@echo
	@echo "Default goal: ${.DEFAULT_GOAL}"
	@echo "  all: check run test"
	@echo "  check: run pychecker and pep8"
	@echo "  test:  run against test data"
	@echo "  install: copy to bin"
	@echo "  clean: delete all generated files"
	@echo

all: check run test

check:
	# check with PyChecker
	pychecker --only vcard2abook.py
	# check with Pep8
	pep8 --verbose --repeat --statistics vcard2abook.py

run:
	# run main with verbose to stdout
	python -m vcard2abook test/test.vcf

test:
	# run against test data and check results
	-@mkdir -p target
	python -m vcard2abook test/test.vcf target/test.out
	diff test/test.expected target/test.out

install:
	# run against test data and check results
	-@install -v -p vcard2abook.py ~/bin/

clean: 
	# cleaning workspace
	python-coverage erase
	-@rm -f *.pyc *.pyo
	# clean generated artifacts
	-@rm -rf target

#EOF
