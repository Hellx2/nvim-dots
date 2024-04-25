// @leet start
impl Solution {
    pub fn reverse(x: i32) -> i32 {
        if let Some(y) = x.to_string().strip_prefix('-') {
            -y.chars().rev().collect::<String>().parse().unwrap_or(0)
        } else {
            x.to_string()
                .chars()
                .rev()
                .collect::<String>()
                .parse()
                .unwrap_or(0)
        }
    }
}
// @leet end
