use Error;

use hyper::server::Listening;
use iron::{Iron, Request, Response, IronResult};
use iron::status;
use router::{Router};

use std::net::Ipv4Addr;

pub fn create(port: u16) -> Result<Listening, Error> {
    let mut router = Router::new();
    router.get("/", handler);

    Iron::new(router).http((Ipv4Addr::new(127, 0, 0, 1), port)).map_err(|e| Error::Iron(e))
}

fn handler(req: &mut Request) -> IronResult<Response> {
    Ok(Response::with((status::Ok, "hello, world")))
}
