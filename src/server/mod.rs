mod create;

use hyper::server::Listening;
use iron::error::HttpResult;
use iron::prelude::*;
use router::Router;

use std::net::Ipv4Addr;

pub fn create(port: u16) -> HttpResult<Listening> {
    let mut router = Router::new();
    router.post("/mortgages", create::handle);

    Iron::new(router).http((Ipv4Addr::new(127, 0, 0, 1), port))
}
