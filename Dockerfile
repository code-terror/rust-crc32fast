# Build Stage
FROM fuzzers/cargo-fuzz:0.10.0 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl git-all build-essential
RUN cargo install afl
RUN git clone https://github.com/srijs/rust-crc32fast.git
WORKDIR /rust-crc32fast/fuzz/
RUN cargo afl build
WORKDIR /
COPY Mayhemfile Mayhemfile
WORKDIR /rust-crc32fast/fuzz/
RUN mkdir in
RUN head -c 1000 </dev/urandom >in/random

ENTRYPOINT ["cargo", "afl", "fuzz", "-i", "/rust-crc32fast/fuzz/in", "-o", "/rust-crc32fast/fuzz/out"]
CMD ["/rust-crc32fast/fuzz/target/debug/fuzz"]
