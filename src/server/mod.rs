use Mortgage;

use bodyparser::Struct;
use iron::status;
use iron::prelude::*;

pub fn create(req: &mut Request) -> IronResult<Response> {
    let mortgage = req.get::<Struct<Mortgage>>();
    println!("{:#?}", mortgage);

    Ok(Response::with((status::Ok, "hello, world")))
}
