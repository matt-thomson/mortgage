FROM quay.io/jimmycuadra/rust:latest

RUN mkdir -p /srv/app/client
WORKDIR /srv/app

COPY server /srv/app
RUN cargo build --release

COPY client/index.html /srv/app/client/index.html
COPY client/mortgage.js /srv/app/client/mortgage.js

EXPOSE 3000
CMD ["target/release/mortgage"]
