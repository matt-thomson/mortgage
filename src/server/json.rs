use MortgageError;
use super::stats::Stats;

use iron::request::Request;
use iron::typemap::Key;
use plugin::{Pluggable, Plugin};
use rustc_serialize::json;

pub struct StatsJson;

impl Key for StatsJson {
    type Value = String;
}

impl<'a, 'b> Plugin<Request<'a, 'b>> for StatsJson {
    type Error = MortgageError;

    fn eval(req: &mut Request) -> Result<String, MortgageError> {
        let stats = try!(req.get::<Stats>());
        let result = try!(json::encode(&stats).map_err(|_| MortgageError::internal_error("Could not encode JSON")));

        Ok(result)
    }
}
