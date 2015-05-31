extern crate bodyparser;
extern crate iron;
extern crate router;
extern crate rustc_serialize;

mod mortgage;
mod server;

pub use mortgage::Mortgage;

use iron::prelude::*;
use router::Router;

use std::net::Ipv4Addr;

fn main() {
    let mut router = Router::new();
    router.post("/mortgages", server::create);

    Iron::new(router).http((Ipv4Addr::new(127, 0, 0, 1), 3000)).unwrap();
}
