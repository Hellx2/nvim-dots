// @leet start
impl Solution {
    pub fn is_power_of_two(n: i32) -> bool {
        (n as f64).log2() % 1.0 == 0.0
    }
}
// @leet end
