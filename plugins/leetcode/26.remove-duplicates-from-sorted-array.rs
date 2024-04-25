// @leet start
impl Solution {
    pub fn remove_duplicates(nums: &mut Vec<i32>) -> i32 {
        *nums = Vec::<i32>::from_iter(std::collections::HashSet::from_iter(nums.iter().cloned()));
        nums.len() as i32
    }
}
// @leet end
