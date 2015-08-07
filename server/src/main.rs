extern crate bodyparser;
extern crate iron;
extern crate num;
extern crate plugin;
extern crate router;
extern crate rustc_serialize;

mod core;
mod error;
mod model;
mod server;

pub use error::MortgageError;
pub use model::{Mortgage, MortgageStats, MortgageWithStats};

use iron::prelude::*;
use router::Router;

use std::net::Ipv4Addr;

fn main() {
    let mut router = Router::new();
    router.post("/mortgages", server::create);

    Iron::new(router).http((Ipv4Addr::new(0, 0, 0, 0), 3000)).unwrap();
}
