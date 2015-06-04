#[derive(Debug)]
enum MortgageErrorType {
    InvalidBody
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
}
