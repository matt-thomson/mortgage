mod body;
mod stats;

use iron::status;
use iron::prelude::*;

pub fn create(req: &mut Request) -> IronResult<Response> {
    let result = req.get::<stats::Stats>();
    println!("{:#?}", result);

    Ok(Response::with(status::NoContent))
}
