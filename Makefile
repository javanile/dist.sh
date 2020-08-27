#!make

.PHONY: test
test:
	cd test/fixtures && ../../dist.sh

push:
	git add .
	git commit -am "new release"
	git push
