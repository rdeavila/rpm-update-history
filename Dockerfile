FROM crystallang/crystal:1.13.1
RUN apt-get update && apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*
