FROM quay.io/matt_thomson/mortgage-base:latest

COPY server /srv/app

RUN cargo build --release

EXPOSE 3000
CMD ["target/release/mortgage"]
