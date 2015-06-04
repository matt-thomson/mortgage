use iron::error::IronError;
use iron::status::Status;

use std::error::Error as StdError;
use std::fmt::{Display, Formatter, Result};

#[derive(Debug)]
enum MortgageErrorType {
    InvalidBody,
    InternalError
}

#[derive(Debug)]
pub struct MortgageError {
    error_type: MortgageErrorType,
    message: String
}

impl MortgageError {
    fn new(error_type: MortgageErrorType, message: &str) -> MortgageError {
        MortgageError { error_type: error_type, message: message.to_string() }
    }

    pub fn invalid_body(message: &str) -> MortgageError {
        MortgageError::new(MortgageErrorType::InvalidBody, message)
    }

    pub fn internal_error(message: &str) -> MortgageError {
        MortgageError::new(MortgageErrorType::InternalError, message)
    }

    pub fn to_iron(self) -> IronError {
        IronError::new(self, Status::InternalServerError)
    }
}

impl StdError for MortgageError {
    fn description(&self) -> &str {
        &self.message[..]
    }
}

impl Display for MortgageError {
    fn fmt(&self, formatter: &mut Formatter) -> Result {
        self.message.fmt(formatter)
    }
}
