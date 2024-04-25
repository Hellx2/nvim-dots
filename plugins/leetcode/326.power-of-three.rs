// @leet start
impl Solution {
    pub fn is_power_of_three(n: i32) -> bool {
        let x = (n as f64).log(3.0) % 1.0;
        x >= (1.0 - f64::EPSILON * 100.0) || x <= (f64::EPSILON * 10.0)
    }
}
// @leet end
