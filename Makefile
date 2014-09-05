.PROXY: all

help:
	@echo
	@echo "Default targets: all"
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

test: force_make
	# run against test data and check results
	@mkdir -p target
	python -m vcf2abook test/test.vcf target/test.out
	diff test/test.expected target/test.out

clean: 
	# Cleaning workspace
	python-coverage erase
	-$(RM) -f *.pyc *.pyo
	# Clean generated documents
	-$(RM) -rf target

force_make:
	true

#EOF
