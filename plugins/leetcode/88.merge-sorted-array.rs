// @leet start
impl Solution {
    pub fn merge(nums1: &mut Vec<i32>, m: i32, nums2: &mut Vec<i32>, n: i32) {
        *nums1 = nums1[0..(m as usize)].to_vec();
        nums1.append(&mut nums2[0..(n as usize)].to_vec());
        nums1.sort();
    }
}
// @leet end
