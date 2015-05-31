#[derive(Clone, Debug, RustcDecodable)]
pub struct Mortgage {
    amount: f32,
    num_years: usize,
    apr: f32
}
