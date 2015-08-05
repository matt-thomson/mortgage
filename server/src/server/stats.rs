use {core, MortgageError, MortgageWithStats};
use super::body::MortgageBody;

use iron::request::Request;
use iron::typemap::Key;
use plugin::{Pluggable, Plugin};

pub struct Stats;

impl Key for Stats {
    type Value = MortgageWithStats;
}

impl<'a, 'b> Plugin<Request<'a, 'b>> for Stats {
    type Error = MortgageError;

    fn eval(req: &mut Request) -> Result<MortgageWithStats, MortgageError> {
        let mortgage = try!(req.get::<MortgageBody>());
        let stats = core::calculate_stats(&mortgage);

        Ok(MortgageWithStats::new(&mortgage, stats))
    }
}
