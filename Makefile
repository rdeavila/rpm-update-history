.PHONY: build pack run

build:
	@docker run --rm -it -v .:/workspace -w /workspace crystallang/crystal:latest-alpine shards build --release --no-debug --progress --static

pack:
	@nfpm pkg --packager deb --target ./bin/
	@nfpm pkg --packager rpm --target ./bin/

run:
	@shards run -- $(filter-out $@,$(MAKECMDGOALS))
