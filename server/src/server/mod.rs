mod body;
mod json;
mod stats;

use self::json::StatsJson;

use iron::headers::ContentType;
use iron::modifiers::Header;
use iron::status;
use iron::prelude::*;

pub fn create(req: &mut Request) -> IronResult<Response> {
    let json = try!(req.get::<StatsJson>().map_err(|e| e.to_iron()));
    Ok(Response::with((status::Created, Header(ContentType::json()), json)))
}
