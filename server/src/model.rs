#[derive(Clone, Debug, RustcDecodable)]
pub struct Mortgage {
    amount: u32,
    num_years: usize,
    apr: f32
}

#[derive(Clone, Debug, RustcEncodable)]
pub struct MortgageStats {
    monthly_repayment: f32
}

#[derive(Clone, Debug, RustcEncodable)]
pub struct MortgageWithStats {
    amount: u32,
    num_years: usize,
    apr: f32,
    stats: MortgageStats
}

impl Mortgage {
    pub fn new(amount: u32, num_years: usize, apr: f32) -> Mortgage {
        Mortgage {
            amount: amount,
            num_years: num_years,
            apr: apr
        }
    }

    pub fn amount(&self) -> u32 {
        self.amount
    }

    pub fn num_years(&self) -> usize {
        self.num_years
    }

    pub fn apr(&self) -> f32 {
        self.apr
    }
}

impl MortgageStats {
    pub fn new(monthly_repayment: f32) -> MortgageStats {
        MortgageStats { monthly_repayment: monthly_repayment }
    }

    pub fn monthly_repayment(&self) -> f32 {
        self.monthly_repayment
    }
}

impl MortgageWithStats {
    pub fn new(mortgage: &Mortgage, stats: MortgageStats) -> MortgageWithStats {
        MortgageWithStats {
            amount: mortgage.amount(),
            num_years: mortgage.num_years(),
            apr: mortgage.apr(),
            stats: stats
        }
    }
}
