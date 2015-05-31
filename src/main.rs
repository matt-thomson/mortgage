extern crate hyper;
extern crate iron;
extern crate router;

mod error;
mod server;

pub use error::Error;

fn main() {
    server::create(3000).unwrap();
}
