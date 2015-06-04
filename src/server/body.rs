use {Mortgage, MortgageError};

use bodyparser::Struct;
use iron::request::Request;
use iron::typemap::Key;
use plugin::{Pluggable, Plugin};

pub struct MortgageBody;

impl Key for MortgageBody {
    type Value = Mortgage;
}

impl<'a, 'b> Plugin<Request<'a, 'b>> for MortgageBody {
    type Error = MortgageError;

    fn eval(req: &mut Request) -> Result<Mortgage, MortgageError> {
        match req.get::<Struct<Mortgage>>() {
            Ok(Some(mortgage)) => Ok(mortgage),
            Ok(None)           => Err(MortgageError::invalid_body("No body supplied")),
            Err(e)             => Err(MortgageError::invalid_body(&format!("Error reading JSON: {}", e.detail)))
        }
    }
}
