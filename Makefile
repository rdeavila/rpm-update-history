.PHONY: clean build pack run

clean:
	@rm -rf bin/
	@truncate -s0 db/ruh.db
	@docker rmi ruh-builder

docker:
	@docker build -t ruh-builder .

build:
	@docker run --rm -it -v .:/workspace -w /workspace ruh-builder shards build --release --no-debug --progress --static

pack:
	@nfpm pkg --packager deb --target ./bin/
	@nfpm pkg --packager rpm --target ./bin/
