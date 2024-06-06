.PHONY: clean docker build dev build-static rpm man

clean:
	@rm -rf bin/
	@rm -rf doc/*.gz
	@truncate -s0 db/ruh.db
	@docker rmi ruh-builder

docker:
	@docker build -t ruh-builder .

build:
	@docker run --rm -it -v .:/workspace -w /workspace ruh-builder shards build --release --no-debug --progress

dev:
	@docker run --rm -it -v .:/workspace -w /workspace ruh-builder shards build

build-static:
	@docker run --rm -it -v .:/workspace -w /workspace ruh-builder shards build --release --no-debug --progress --static

rpm:
	@nfpm pkg --packager rpm --target ./bin/

man:
	@rm -f doc/ruh.1.gz
	@pandoc doc/ruh.1.md -s -t man -o doc/ruh.1
	@gzip doc/ruh.1
	@man -l doc/ruh.1.gz
