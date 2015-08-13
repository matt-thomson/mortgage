FROM quay.io/matt_thomson/mortgage-base:latest

RUN mkdir -p /srv/app
WORKDIR /srv/app

COPY server /srv/app

RUN cargo build --release

EXPOSE 3000
CMD ["target/release/mortgage"]
