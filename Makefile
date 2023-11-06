.PHONY: clean build pack run

clean:
	@rm -rf bin/
	@truncate -s0 db/ruh.db

build:
	@docker run --rm -it -v .:/workspace -w /workspace crystallang/crystal:latest-alpine shards build --release --no-debug --progress --static

pack:
	@nfpm pkg --packager deb --target ./bin/
	@nfpm pkg --packager rpm --target ./bin/
