FROM rust:1.68.2-slim-bullseye as build

# Install build dependancies
RUN apt-get update && apt-get -y install git build-essential m4 llvm libclang-dev diffutils curl

WORKDIR /zenotta

# Clone dependancies
RUN git clone -b increased_cb_maturity https://github.com/Zenotta/ZNP.git ./

# Build for release
RUN cargo build --release

# Remove src
RUN rm -Rvf src

# config for the miner node
COPY ./conf/* /etc/.

ENV RUST_LOG=info,debug

CMD ["/zenotta/target/release/node", "miner", "--config=/etc/node_settings.toml", "--tls_config=/etc/tls_certificates.json", "--initial_block_config=/etc/initial_block.json", "--api_config=/etc/api_config.json", "--api_use_tls=0", "--with_user_address=127.0.0.1:23460"]