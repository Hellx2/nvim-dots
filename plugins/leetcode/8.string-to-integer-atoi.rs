// @leet start
impl Solution {
    pub fn my_atoi(s: String) -> i32 {
        s.replace(" ", "")
            .split_once(|c: char| !c.is_ascii_digit() && c != '-')
            .unwrap_or((s.replace(" ", "").as_str(), ""))
            .0
            .parse::<i64>()
            .unwrap_or(0) as i32
    }
}
// @leet end
