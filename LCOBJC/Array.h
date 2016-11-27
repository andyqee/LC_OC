//
//  Array.h
//  LCOBJC
//
//  Created by ethon_qi on 25/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface Array : NSObject

// 278. First Bad Version 二分法

// Difficulty: Easy
// You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

// Suppose you have n versions [1, 2, ..., n] and you want to find out the first bad one, which causes all the following ones to be bad.

// You are given an API bool isBadVersion(version) which will return whether version is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.

- (NSInteger)firstBadVersion:(NSInteger)n;

// Product of Array Except Self
//Given an array of n integers where n > 1, nums, return an array output such that output[i] is equal to the product of all the elements of nums except nums[i].
//
//Solve it without division and in O(n).
//
//For example, given [1,2,3,4], return [24,12,8,6].
//
//Follow up:
//Could you solve it with constant space complexity? (Note: The output array does not count as extra space for the purpose of space complexity analysis.)

// 这里复杂的关键在于处理如何 元素为0 的情况

- (NSArray<NSNumber *> *)productExceptSelf:(NSArray<NSNumber *> *)nums;

//Find the kth largest element in an unsorted array. Note that it is the kth largest element in the sorted order, not the kth distinct element.
//
//For example,
//Given [3,2,1,5,6,4] and k = 2, return 5.
//
//Note:
//You may assume k is always valid, 1 ≤ k ≤ array's length.

- (NSNumber *)findKthLargest:(NSInteger)k inArray:(NSArray<NSNumber *> *)nums;

// 367. Valid Perfect Square

// Difficulty: Medium
// Contributors: Admin
// Given a positive integer num, write a function which returns True if num is a perfect square else False.

// Note: Do not use any built-in library function such as sqrt.

// Example 1:

// Input: 16
// Returns: True
// Example 2:

// Input: 14
// Returns: False


// 128. Longest Consecutive Sequence
// 最长连续序列
// Given an unsorted array of integers, find the length of the longest consecutive elements sequence.
// For example,
// Given [100, 4, 200, 1, 3, 2],
// The longest consecutive elements sequence is [1, 2, 3, 4]. Return its length: 4.
// Your algorithm should run in O(n) complexity.

- (NSInteger)longestConsecutive:(NSArray<NSNumber *> *)nums;

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

// 414. Third Maximum Number

// Difficulty: Easy
// Contributors: ZengRed , 1337c0d3r
// Given a non-empty array of integers, return the third maximum number in this array. If it does not exist, return the maximum number. The time complexity must be in O(n).

// Example 1:
// Input: [3, 2, 1]

// Output: 1

// Explanation: The third maximum is 1.
// Example 2:
// Input: [1, 2]

// Output: 2

// Explanation: The third maximum does not exist, so the maximum (2) is returned instead.
// Example 3:
// Input: [2, 2, 3, 1]

// Output: 1

// Explanation: Note that the third maximum here means the third maximum distinct number.
// Both numbers with value 2 are both considered as second maximum.

- (NSInteger)thirdMax:(NSArray<NSNumber *> *)nums;

// 33. Search in Rotated Sorted Array

// Difficulty: Hard
// Contributors: Admin
// Suppose a sorted array is rotated at some pivot unknown to you beforehand.

// (i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2). 分析偏移的数组最大值在中点左边还是右边两种情况
// 说明其中有一半是递增的，那么就可以锁定区间啦。😄😄
// eg 67012345
// eg 34567012

// You are given a target value to search. If found in the array return its index, otherwise return -1.
// You may assume no duplicate exists in the array.

- (NSInteger)searchInRotatedArray:(NSArray *)nums target:(NSInteger)target;

// 81. Search in Rotated Sorted Array II
// Follow up for "Search in Rotated Sorted Array":
// What if duplicates are allowed?

// Would this affect the run-time complexity? How and why?

// Write a function to determine if a given target is in the array.

- (BOOL)searchInRotatedArrayDuplicate:(NSArray *)nums target:(NSInteger)target;

// 4. Median of Two Sorted Arrays
// Difficulty: Hard
// Contributors: Admin
// There are two sorted arrays nums1 and nums2 of size m and n respectively.

// Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)).

// Example 1:
// nums1 = [1, 3]
// nums2 = [2]

// The median is 2.0
// Example 2:
// nums1 = [1, 2]
// nums2 = [3, 4]

// The median is (2 + 3)/2 = 2.5

- (double)findMedianInSortedArrays:(NSArray *)arr1 anotherArray:(NSArray *)arr2;

// 56. Merge Intervals

// Difficulty: Hard
// Contributors: Admin
// Given a collection of intervals, merge all overlapping intervals.

// For example,
// Given [1,3],[2,6],[8,10],[15,18

- (NSArray<Interval *> *)mergeIntervals:(NSArray<Interval *> *)intervals;

//57. Insert Interval   Add to List QuestionEditorial Solution  My Submissions
//Difficulty: Hard
//Contributors: Admin
//Given a set of non-overlapping intervals, insert a new interval into the intervals (merge if necessary).
//
//You may assume that the intervals were initially sorted according to their start times.
//
//Example 1:
//Given intervals [1,3],[6,9], insert and merge [2,5] in as [1,5],[6,9].
//
//Example 2:
//Given [1,2],[3,5],[6,7],[8,10],[12,16], insert and merge [4,9] in as [1,2],[3,10],[12,16].
//
//This is because the new interval [4,9] overlaps with [3,5],[6,7],[8,10].

- (NSArray<Interval *> *)insert:(Interval *)interval1 withInterval:(Interval *)interval2;

//350. Intersection of Two Arrays II
//Given two arrays, write a function to compute their intersection.
//Example:
//Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2, 2].
//
//Note:
//Each element in the result should appear as many times as it shows in both arrays.
//The result can be in any order.
//Follow up:
//What if the given array is already sorted? How would you optimize your algorithm?
//What if nums1's size is small compared to nums2's size? Which algorithm is better?
//What if elements of nums2 are stored on disk, and the memory is limited such that you cannot load all elements into the memory at once?

- (NSArray<NSNumber *> *)intersectionOfTwoArray:(NSArray *)array andArray2:(NSArray *)array2;

// 349. Intersection of Two Arrays
// Difficulty: Easy
// Given two arrays, write a function to compute their intersection.

// Example:
// Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2].

// Note:
// Each element in the result must be unique.
// The result can be in any order.

// unique
- (NSArray<NSNumber *> *)intersectionOfTwoArrayUnique:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2;

- (void)sortedColors_bs:(NSMutableArray<NSNumber *> *)nums k:(NSInteger)k;

// 75. Sort Colors
// Difficulty: Medium
// Contributors: Admin
// Given an array with n objects colored red, white or blue, sort them so that objects of the same color are adjacent, with the colors in the order red, white and blue.

// Here, we will use the integers 0, 1, and 2 to represent the color red, white, and blue respectively.

// Note:
// You are not suppose to use the library's sort function for this problem.
// 根据LC里面的函数定义，没有返回值，是in place modify

- (void)sortedColors:(NSMutableArray *)nums;

// 153. Find Minimum in Rotated Sorted Array
// Difficulty: Medium
// Contributors: Admin
// Suppose a sorted array is rotated at some pivot unknown to you beforehand.
// (i.e., 0 1 2 4 5 6 7 might become 4 5 6 7 0 1 2).

// Find the minimum element.
// You may assume no duplicate exists in the array.

- (NSNumber *)findMin:(NSArray<NSNumber *> *)nums;

// 允许重复，会对time complexity 有什么影响
- (NSNumber *)findMin2:(NSArray<NSNumber *> *)nums;

// 209. Minimum Size Subarray Sum
// Difficulty: Medium
// Contributors: Admin
// Given an array of n positive integers and a positive integer s, find the minimal length of a subarray of which the sum ≥ s. If there isn't one, return 0 instead.

// For example, given the array [2,3,1,2,4,3] and s = 7,
// the subarray [4,3] has the minimal length under the problem constraint.

- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray *)nums;

// 152. Maximum Product Subarray
// Difficulty: Medium
// Contributors: Admin
// Find the contiguous subarray within an array (containing at least one number) which has the largest product.

// For example, given the array [2,3,-2,4],
// the contiguous subarray [2,3] has the largest product = 6.

- (NSInteger)maxProduct:(NSArray<NSNumber *>*)nums;

- (NSInteger)maxProduct_OptimizeSpace:(NSArray<NSNumber *>*)nums;

// Meeting Rooms
// Given an array of meeting time intervals consisting of start and end times [[s1,e1],[s2,e2],...] (si < ei), determine if a person could attend all meetings.
// For example,
// Given [[0, 30],[5, 10],[15, 20]],
// return false.
// Understand the problem:
// The problem looks very similar to the merge interval and insert intervals.
// So the idea is still the same: first sort the intervals according to the start times, then check if there is any overlap.

- (BOOL)canAttendMeetings:(NSArray<Interval *> *)intervals;

// Leetcode: Meeting Rooms II
// Given an array of meeting time intervals consisting of start and end times [[s1,e1],[s2,e2],...] (si < ei),
// find the minimum number of conference rooms required.
// For example,
// Given [[0, 30],[5, 10],[15, 20]],
// return 2.

- (NSInteger)minMeetingRooms:(NSArray<Interval *> *)intervals;

- (NSArray *)mergeKSortedArray:(NSArray *)array;

@end
