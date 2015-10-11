extern crate bodyparser;
extern crate iron;
extern crate mount;
extern crate num;
extern crate plugin;
extern crate router;
extern crate rustc_serialize;
extern crate staticfile;

mod core;
mod error;
mod model;
mod server;

pub use error::MortgageError;
pub use model::{IntroductoryRate, Mortgage, MortgageStats, MortgageWithStats};

use iron::prelude::*;
use mount::Mount;
use router::Router;
use staticfile::Static;

use std::net::Ipv4Addr;

fn main() {
    let mut api = Router::new();
    api.post("/", server::create);

    let client = Static::new("client/");

    let mut mount = Mount::new();
    mount.mount("/", client);
    mount.mount("/mortgages", api);

    Iron::new(mount).http((Ipv4Addr::new(0, 0, 0, 0), 3000)).unwrap();
}
