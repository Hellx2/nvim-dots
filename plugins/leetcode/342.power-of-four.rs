// @leet start
impl Solution {
    pub fn is_power_of_four(n: i32) -> bool {
        (n as f64).log(4.0) % 1.0 == 0.0
    }
}
// @leet end
