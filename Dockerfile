FROM jimmycuadra/rust:latest

RUN mkdir -p /srv/app
WORKDIR /srv/app

COPY server /srv/app

RUN cargo build --release

EXPOSE 3000
CMD ["target/release/mortgage"]
