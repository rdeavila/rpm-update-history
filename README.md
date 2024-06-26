# rpm-update-history

[![OpenSSF Best
Practices](https://www.bestpractices.dev/projects/8070/badge)](https://www.bestpractices.dev/projects/8070)
[![SemVer](https://img.shields.io/badge/SemVer-2.0.0-22bfda.svg 'SemVer
Format')](https://semver.org) [![Contributor
Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

The RPM Update History project aims to track package history on RPM systems,
compiling data on the number of updates and installs. Designed to enhance system
reliability, this initiative collects and centralizes information, providing
valuable insights into the evolution of packages.

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

To make changes on this project, you need:

### Crystal

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
```

### Podman

```bash
sudo dnf install -y podman podman-docker
sudo touch /etc/containers/nodocker
```

> Want docker instead of Podman? read the [Engine
> Install](https://docs.docker.com/engine/install/#server) doc for instructions.

### nFPM

```bash
echo '[goreleaser]
name=GoReleaser
baseurl=https://repo.goreleaser.com/yum/
enabled=1
gpgcheck=0' | sudo tee /etc/yum.repos.d/goreleaser.repo
sudo yum install -y nfpm
```

### Development commands

While modifying the source code:

* `shards install`: install any new shard dependency
* `shards run`: run the project. To pass the `rpm-update-history` commands, use
  `--`. Ex.: `shards run -- --build`

To create the binary and distribute

* `make clean`: remove compiled binaries and packages, and reset database file
* `make docker`: build a docker image to statically compile the project
* `make build`: build a production-ready binary on `./bin` directory
* `make build-static`: same as `make build`, but statically linked
* `make man`: compile the `man rpm-update-history` manpage
* `make rpm`: create new `.rpm` package

## Contributing

1. Fork it (<https://github.com/rdeavila/rpm-update-history/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
