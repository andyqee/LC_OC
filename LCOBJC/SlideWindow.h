//
//  SlideWindow.h
//  LCOBJC
//
//  Created by ethon_qi on 21/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 双指针的第一类情况

@interface SlideWindow : NSObject

// 53. Maximum Subarray
#pragma mark - 高频

// Difficulty: Medium
// Find the contiguous subarray within an array (containing at least one number) which has the largest sum.

// For example, given the array [-2,1,-3,4,-1,2,1,-5,4],
// the contiguous subarray [4,-1,2,1] has the largest sum = 6.

- (NSInteger)maxSubArray:(NSArray<NSNumber *>*)nums;

- (NSInteger)maxSubArrayM2:(NSArray<NSNumber *>*)nums;

// 209. Minimum Size Subarray Sum
// Difficulty: Medium
// Contributors: Admin
// Given an array of n positive integers and a positive integer s, find the minimal length of a subarray of which the sum ≥ s. If there isn't one, return 0 instead.

// For example, given the array [2,3,1,2,4,3] and s = 7,
// the subarray [4,3] has the minimal length under the problem constraint.

- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray *)nums;

//76. Minimum Window Substring

//Given a string S and a string T, find the minimum window in S which will contain all the characters in T in complexity O(n).
//
//For example,
//S = "ADOBECODEBANC"
//T = "ABC"
//Minimum window is "BANC".
//
//Note:
//If there is no such window in S that covers all characters in T, return the empty string "".
//
//If there are multiple such windows, you are guaranteed that there will always be only one unique minimum window in S.

- (NSString *)minWindow:(NSString *)str t:(NSString *)t;

//3. Longest Substring Without Repeating Characters[M]

//Difficulty: Medium
//Contributors: Admin
//Given a string, find the length of the longest substring without repeating characters.
//
//Examples:
//
//Given "abcabcbb", the answer is "abc", which the length is 3.
//
//Given "bbbbb", the answer is "b", with the length of 1.
//
//Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a substring, "pwke" is a subsequence and not a substring.

- (NSInteger)lengthOfLongestSubstring:(NSString *)str;

//26. Remove Duplicates from Sorted Array

//Difficulty: Easy
//Contributors: Admin
//Given a sorted array, remove the duplicates in place such that each element appear only once and return the new length.
//
//Do not allocate extra space for another array, you must do this in place with constant memory.
//
//For example,
//Given input array nums = [1,1,2],
//
//Your function should return length = 2, with the first two elements of nums being 1 and 2 respectively. It doesn't matter what you leave beyond the new length.

- (NSInteger)removeDuplicates:(NSMutableArray *)nums;

//80. Remove Duplicates from Sorted Array II

//Difficulty: Medium
//Contributors: Admin

//Follow up for "Remove Duplicates":
//What if duplicates are allowed at most twice?
//
//For example,
//Given sorted array nums = [1,1,1,2,2,3],
//
//Your function should return length = 5, with the first five elements of nums being 1, 1, 2, 2 and 3. It doesn't matter what you leave beyond the new length.

- (NSInteger)removeDuplicates2:(NSMutableArray *)nums;

//From careercup
//Given an array, remove the duplicates and return a unique array keeping the first occurrence of the duplicates and the order.
//
//[@2, @1, @3, @1, @2] --> [@2, @1, @3]

- (NSArray *)removeDuplicates3:(NSMutableArray *)nums;

// Longest Substring with At Most Two Distinct Characters

// 340 Longest Substring with At Most K Distinct Characters
//Given a string, find the length of the longest substring T that contains at most k distinct characters.
//
//For example, Given s = “eceba” and k = 2,
//
//T is "ece" which its length is 3

- (NSInteger)longestSubstring:(NSString *)str k:(NSInteger)k;

// 给一个array, 然后给一个k, 让你check 连续的k个integer是否含有dulplicate, 很简单的，用窗口为K的hashset一直扫一遍就行了，很简单
// 举个例子 abcsba 如果k = 3 就没有 duplicate
- (BOOL)containsDuplicate:(NSArray *)nums windowSize:(NSInteger)k;

//395. Longest Substring with At Least K Repeating Characters

//Difficulty: Medium
//Contributors: Admin
//Find the length of the longest substring T of a given string (consists of lowercase letters only) such that every character in T appears no less than k times.
//
//Example 1:
//
//Input:
//s = "aaabb", k = 3
//
//Output:
//3
//
//The longest substring is "aaa", as 'a' is repeated 3 times.
//Example 2:
//
//Input:
//s = "ababbc", k = 2
//
//Output:
//5
//
//The longest substring is "ababb", as 'a' is repeated 2 times and 'b' is repeated 3 times.

- (NSInteger)longestSubstring:(NSString *)str repeatingCount:(NSInteger)k;

//From career cup

//Given an array of positive integers and a target total of X, find if there exists a contiguous subarray with sum = X
//
//[1, 3, 5, 18] X = 8 Output: True
//X = 9 Output: True
//X = 10 Output: False
//X = 40 Output :False

- (BOOL)exitContigousSubarray:(NSArray *)array sum:(NSInteger)sum;

// Maximum Size Subarray Sum Equals k

@end
