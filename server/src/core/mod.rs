use num;

use {Mortgage, MortgageStats};

pub fn calculate_stats(mortgage: &Mortgage) -> MortgageStats {
    let rate = mortgage.apr() / ((12 * 100) as f32);
    let compound_rate = num::pow(1.0 + rate, mortgage.num_years() * 12);

    let monthly_repayment = (mortgage.amount() as f32 * rate * compound_rate) / (compound_rate - 1.0);

    MortgageStats::new(monthly_repayment)
}

#[cfg(test)]
mod tests {
    use Mortgage;

    #[test]
    fn should_calculate_monthly_repayment() {
        let mortgage = Mortgage::new(250000, 20, 3.99);
        let stats = super::calculate_stats(&mortgage);

        assert_eq!(stats.monthly_repayment() as u32, 1513);
    }
}
