use iron;

#[derive(Debug)]
pub enum Error {
    Iron(iron::error::HttpError)
}
