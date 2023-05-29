FROM rust:1.68.2-slim-bullseye as build

# Install build dependancies
RUN apt-get update && apt-get -y install git build-essential m4 llvm libclang-dev diffutils curl

WORKDIR /zenotta

# Clone dependancies
RUN git clone https://github.com/Zenotta/keccak-prime.git /keccak-prime && git clone -b develop https://github.com/Zenotta/naom.git /naom && git clone -b develop https://github.com/Zenotta/ZNP.git ./

# Build for release
RUN cargo build --release

# Copy config as we're removing src
# RUN cp ./src/bin/initial_block.json ./src/bin/tls_certificates.json ./src/bin/api_config.json /etc/
# COPY zenotta-miner-config.toml /etc/zenotta-miner-config.toml

# Remove src
RUN rm -Rvf src
    
# Use a multi-stage build and a distroless image for less attack vectors and a small image
#FROM gcr.io/distroless/cc-debian11

#COPY --from=build /zenotta/target/release/node /usr/local/bin/
COPY ./conf/* /etc/.

ENV RUST_LOG=info,debug

CMD ["/zenotta/target/release/node", "miner", "--config=/etc/node_settings.toml", "--tls_config=/etc/tls_certificates.json", "--initial_block_config=/etc/initial_block.json", "--api_config=/etc/api_config.json", "--api_use_tls=0", "--with_user_index=0"]