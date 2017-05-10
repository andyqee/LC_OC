//
//  TwoPointers.h
//  LCOBJC
//
//  Created by ethon_qi on 31/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoPointers : NSObject

// 125. Valid Palindrome
// Difficulty: Easy
// Contributors: Admin
// Given a string, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.

// For example,
// "A man, a plan, a canal: Panama" is a palindrome.
// "race a car" is not a palindrome.

// Note:
// Have you consider that the string might be empty? This is a good question to ask during an interview.

// For the purpose of this problem, we define empty string as valid palindrome.

- (BOOL)isPalindrome:(NSString *)str;

// 28. Implement strStr() [E]
// Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle;

// 42. Trapping Rain Water

// Difficulty: Hard
// Contributors: Admin
// Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it is able to trap after raining.

// For example,
// Given [0,1,0,2,1,0,1,3,2,1,2,1], return 6.

- (NSInteger)trap:(NSArray<NSNumber *> *)nums;

- (NSInteger)trap_TwoPointers:(NSArray<NSNumber *> *)nums;

//11 Container With Most Water[M]

//Given n non-negative integers a1, a2, ..., an, where each represents a point at coordinate (i, ai). n vertical lines are drawn such that the two endpoints of line i is at (i, ai) and (i, 0). Find two lines, which together with x-axis forms a container, such that the container contains the most water.
//
//Note: You may not slant the container and n is at least 2.

- (NSInteger)maxArea:(NSArray<NSNumber *> *)heights;

// 75. Sort Colors
// Difficulty: Medium
// Contributors: Admin
// Given an array with n objects colored red, white or blue, sort them so that objects of the same color are adjacent, with the colors in the order red, white and blue.

// Here, we will use the integers 0, 1, and 2 to represent the color red, white, and blue respectively.

// Note:
// You are not suppose to use the library's sort function for this problem.
// 根据LC里面的函数定义，没有返回值，是in place modify

- (void)sortedColors:(NSMutableArray *)nums;

// sum 系列
// Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0?
// Find all unique triplets in the array which gives the sum of zero.
// Note: The solution set must not contain duplicate triplets.
// For example, given array S = [-1, 0, 1, 2, -1, -4],
// A solution set is:
// [
//   [-1, 0, 1],
//   [-1, -1, 2]
// ]

- (NSArray<NSArray *> *)threeSum:(NSArray *)nums; // 3sum

//Given an array S of n integers, find three integers in S such that the sum is closest to a given number, target. Return the sum of the three integers. You may assume that each input would have exactly one solution.
//
//For example, given array S = {-1 2 1 -4}, and target = 1.
//
//The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).

- (NSInteger)threeSumCloset:(NSArray *)nums target:(NSInteger)target; // 3sum

//- (NSInteger)3sumSmaller;
// Given an array of integers, return indces of the two numbers such that they add up to a specific target.

// You may assume that each input would have exactly one solution.

// Example:
// Given nums = [2, 7, 11, 15], target = 9,

// Because nums[0] + nums[1] = 2 + 7 = 9,
// return [0, 1].
// UPDATE (2016/2/13):
// The return format had been changed to zero-based indices. Please read the above updated description carefully.

- (NSArray *)twoSum:(NSArray *)nums target:(NSInteger)target;

//167. Two Sum II - Input array is sorted
//Difficulty: Medium
//Given an array of integers that is already sorted in ascending order, find two numbers such that they add up to a specific target number.
//
//The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2. Please note that your returned answers (both index1 and index2) are not zero-based.
//
//You may assume that each input would have exactly one solution.
//
//Input: numbers={2, 7, 11, 15}, target=9
//Output: index1=1, index2=2

- (NSArray *)twosumSortedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target;

//- (NSInteger)4sum;

@end
