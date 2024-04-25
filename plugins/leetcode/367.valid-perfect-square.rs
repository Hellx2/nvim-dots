// @leet start
impl Solution {
    pub fn is_perfect_square(num: i32) -> bool {
        (num as f64).sqrt() % 1.0 == 0.0
    }
}
// @leet end
