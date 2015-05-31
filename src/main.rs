extern crate bodyparser;
extern crate hyper;
extern crate iron;
extern crate router;
extern crate rustc_serialize;

mod mortgage;
mod server;

pub use mortgage::Mortgage;

fn main() {
    server::create(3000).unwrap();
}
