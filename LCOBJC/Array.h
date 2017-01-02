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

//57. Insert Interval
//Difficulty: Hard
//Contributors: Admin
//Given a set of non-overlapping intervals, insert a new interval into the intervals (merge if necessary).
//You may assume that the intervals were initially sorted according to their start times.
//Example 1:
//Given intervals [1,3],[6,9], insert and merge [2,5] in as [1,5],[6,9].
//
//Example 2:
//Given [1,2],[3,5],[6,7],[8,10],[12,16], insert and merge [4,9] in as [1,2],[3,10],[12,16].
//
//This is because the new interval [4,9] overlaps with [3,5],[6,7],[8,10].

- (NSArray<Interval *> *)insert:(NSArray<Interval *> *)intervals withInterval:(Interval *)interval2;

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

// 53. Maximum Subarray
#pragma mark - 高频
// Difficulty: Medium
// Find the contiguous subarray within an array (containing at least one number) which has the largest sum.

// For example, given the array [-2,1,-3,4,-1,2,1,-5,4],
// the contiguous subarray [4,-1,2,1] has the largest sum = 6.

- (NSInteger)maxSubArray:(NSArray<NSNumber *>*)nums;
- (NSInteger)maxSubArrayM2:(NSArray<NSNumber *>*)nums;

// 48. Rotate Image   Add to List QuestionEditorial Solution  My Submissions
// Difficulty: Medium
// You are given an n x n 2D matrix representing an image.
// Rotate the image by 90 degrees (clockwise).
// Follow up:
// Could you do this in-place?

- (void)rotate:(NSMutableArray<NSMutableArray *> *)matrix;

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

//283. Move Zeroes   Add to List QuestionEditorial Solution  My Submissions

//Difficulty: Easy
//Contributors: Admin
//Given an array nums, write a function to move all 0's to the end of it while maintaining the relative order of the non-zero elements.
//
//For example, given nums = [0, 1, 0, 3, 12], after calling your function, nums should be [1, 3, 12, 0, 0].
//
//Note:
//You must do this in-place without making a copy of the array.
//Minimize the total number of operations.

- (void)moveZeros:(NSMutableArray<NSNumber *> *)nums;
- (void)moveZeros_no_order:(NSMutableArray<NSNumber *> *)nums;

- (NSArray *)cooldown:(NSArray *)tasks;

//191. Number of 1 Bits

//Difficulty: Easy
//Write a function that takes an unsigned integer and returns the number of ’1' bits it has (also known as the Hamming weight).
//
//For example, the 32-bit integer ’11' has binary representation 00000000000000000000000000001011, so the function should return 3.
- (NSInteger)hammingWeight:(NSInteger)n;

- (NSInteger)sparseVector:(NSArray<NSArray<NSNumber *> *> *)vector dotVector:(NSArray<NSArray<NSNumber *> *> *)vector2;

// 34. Search for a Range

// Difficulty: Medium
// Given a sorted array of integers, find the starting and ending position of a given target value.
// Your algorithm's runtime complexity must be in the order of O(log n).
// If the target is not found in the array, return [-1, -1].

// For example,
// Given [5, 7, 7, 8, 8, 10] and target value 8,
// return [3, 4].

- (NSArray<NSNumber *> *)searchRange:(NSArray<NSNumber *> *)nums target:(NSInteger)target;

- (NSArray<NSNumber *> *)searchRangeMethod2:(NSArray<NSNumber *> *)nums target:(NSInteger)target;

//54. Spiral Matrix
//
//Difficulty: Medium
//Contributors: Admin
//Given a matrix of m x n elements (m rows, n columns), return all elements of the matrix in spiral order.
//
//For example,
//Given the following matrix:
//
//[
// [ 1, 2, 3 ],
// [ 4, 5, 6 ],
// [ 7, 8, 9 ]
// ]
//You should return [1,2,3,6,9,8,7,4,5].

- (NSArray<NSNumber *> *)spiralOrder:(NSArray<NSArray<NSNumber *> *> *)nums;

// 217. Contains Duplicate
// Given an array of integers, find if the array contains any duplicates. 
// Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.
- (BOOL)containsDuplicate:(NSArray<NSNumber *> *)nums;


// Given an array of integers and an integer k, find out whether there are two distinct indices i and j in the array such that 
// nums[i] = nums[j] and the difference between i and j is at most k.
- (BOOL)containsDuplicate2:(NSArray<NSNumber *> *)nums;

// 35. Search Insert Position
// Given a sorted array and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.
// You may assume no duplicates in the array.

// Here are few examples.
// [1,3,5,6], 5 → 2
// [1,3,5,6], 2 → 1
// [1,3,5,6], 7 → 4
// [1,3,5,6], 0 → 0

- (NSInteger)searchInsert:(NSArray<NSNumber *> *)nums target:(NSInteger)target;

//277 Find the Celebrity
//
//Suppose you are at a party with n people (labeled from 0 to n - 1) and among them, there may exist one celebrity. The definition of a celebrity is that all the other n - 1 people know him/her but he/she does not know any of them.
//
//Now you want to find out who the celebrity is or verify that there is not one. The only thing you are allowed to do is to ask questions like: "Hi, A. Do you know B?" to get information of whether A knows B. You need to find out the celebrity (or verify there is not one) by asking as few questions as possible (in the asymptotic sense).
//
//You are given a helper function bool knows(a, b) which tells you whether A knows B. Implement a function int findCelebrity(n), your function should minimize the number of calls to knows.
//
//Note: There will be exactly one celebrity if he/she is in the party. Return the celebrity's label if there is a celebrity in the party. If there is no celebrity, return -1.

- (NSInteger)findCelebrity:(NSArray *)nums;

// 280 wiggle sort
//Given an unsorted array nums, reorder it in-place such that nums[0] <= nums[1] >= nums[2] <= nums[3]....
//For example, given nums = [3, 5, 2, 1, 6, 4], one possible answer is [1, 6, 2, 5, 3, 4].

- (void)wiggleSort:(NSMutableArray<NSNumber *> *)nums;

// 280 wiggle sort
//Given an unsorted array nums, reorder it in-place such that nums[0] <= nums[1] >= nums[2] <= nums[3]....
//For example, given nums = [3, 5, 2, 1, 6, 4], one possible answer is [1, 6, 2, 5, 3, 4].

- (void)wiggleSortII:(NSMutableArray<NSNumber *> *)nums;

// 74. Search a 2D Matrix
// Write an efficient algorithm that searches for a value in an m x n matrix. This matrix has the following properties:

// Integers in each row are sorted from left to right.
// The first integer of each row is greater than the last integer of the previous row.
// For example,

// Consider the following matrix:

// [
//   [1,   3,  5,  7],
//   [10, 11, 16, 20],
//   [23, 30, 34, 50]
// ]
// Given target = 3, return true.

- (BOOL)searchMatrix:(NSMutableArray<NSNumber *> *)nums target:(NSInteger)target;

// 268. Missing Number
// Given an array containing n distinct numbers taken from 0, 1, 2, ..., n, find the one that is missing from the array.

// For example,
// Given nums = [0, 1, 3] return 2.

// Note:
// Your algorithm should run in linear runtime complexity. Could you implement it using only constant extra space complexity?

- (NSInteger)missingNumber:(NSArray *)nums;

// 55. Jump Game   
// Given an array of non-negative integers, you are initially positioned at the first index of the array.
// Each element in the array represents your maximum jump length at that position.
// Determine if you are able to reach the last index.
// For example:
// A = [2,3,1,1,4], return true.
// A = [3,2,1,0,4], return false.

- (BOOL)canJump:(NSArray *)nums;

// 45. Jump Game II
// Difficulty: Hard
// Given an array of non-negative integers, you are initially positioned at the first index of the array.
// Each element in the array represents your maximum jump length at that position.
// Your goal is to reach the last index in the minimum number of jumps.
// For example:
// Given array A = [2,3,1,1,4]

// The minimum number of jumps to reach the last index is 2. (Jump 1 step from index 0 to 1, then 3 steps to the last index.)

- (NSInteger)jump:(NSArray<NSNumber *> *)nums;

//334. Increasing Triplet Subsequence
//Difficulty: Medium
//Contributors: Admin
//Given an unsorted array return whether an increasing subsequence of length 3 exists or not in the array.
//
//Formally the function should:
//Return true if there exists i, j, k
//such that arr[i] < arr[j] < arr[k] given 0 ≤ i < j < k ≤ n-1 else return false.
//Your algorithm should run in O(n) time complexity and O(1) space complexity.
//
//Examples:
//Given [1, 2, 3, 4, 5],
//return true.
//
//Given [5, 4, 3, 2, 1],
//return false.

- (BOOL)increasingTriplet:(NSArray<NSNumber *> *)nums;

- (BOOL)increasing:(NSArray<NSNumber *> *)nums k:(NSInteger)k;

// todo : implement circular buffer
// 457. Circular Array Loop [M]  这题和circular buffer 不一样

//You are given an array of positive and negative integers. If a number n at an index is positive, then move forward n steps. Conversely, if it's negative (-n), move backward n steps. Assume the first element of the array is forward next to the last element, and the last element is backward next to the first element. Determine if there is a loop in this array. A loop starts and ends at a particular index with more than 1 element along the loop. The loop must be "forward" or "backward'.
//
//Example 1: Given the array [2, -1, 1, 2, 2], there is a loop, from index 0 -> 2 -> 3 -> 0.
//
//Example 2: Given the array [-1, 2], there is no loop.
//
//Note: The given array is guaranteed to contain no element "0".
//
//Can you do it in O(n) time complexity and O(1) space complexity?

- (BOOL)circularArrayLoop:(NSArray<NSNumber *> *)nums;

@end

// 303. Range Sum Query - Immutable
// Difficulty: Easy
// Contributors: Admin
// Given an integer array nums, find the sum of the elements between indices i and j (i ≤ j), inclusive.

// Example:
// Given nums = [-2, 0, 3, -5, 2, -1]

// sumRange(0, 2) -> 1
// sumRange(2, 5) -> -1
// sumRange(0, 5) -> -3
// Note:
// You may assume that the array does not change.
// There are many calls to sumRange function.

@interface NumArray : NSObject

- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums;
- (NSInteger)sumRange:(NSInteger)l r:(NSInteger)r;

@end

@interface NumMatrix : NSObject

- (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix;

- (NSInteger)sumRange:(NSInteger)l1 r:(NSInteger)r1 l2:(NSInteger)l2 r:(NSInteger)r2;

@end

//segmentTree

@interface NumArray2 : NSObject

- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums;

- (NSInteger)sumRange:(NSInteger)l r:(NSInteger)r;

- (void)update:(NSInteger)idx val:(NSInteger)val;

@end

// 398. Random Pick Index 
// Difficulty: Medium
// Contributors: Admin
// Given an array of integers with possible duplicates, randomly output the index of a given target number. 
// You can assume that the given target number must exist in the array.
// Note:
// The array size can be very large. Solution that uses too much extra space will not pass the judge.

// Example:
// int[] nums = new int[] {1,2,3,3,3};
// Solution solution = new Solution(nums);

// // pick(3) should return either index 2, 3, or 4 randomly. Each index should have equal probability of returning.
// solution.pick(3);

// // pick(1) should return 0. Since in the array only nums[0] is equal to 1.
// solution.pick(1);

@interface RandomPickIndex : NSObject
- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums;
- (NSInteger)pick:(NSInteger)target;

@end

@interface Vector2D : NSObject
- (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix;
- (NSNumber *)next;
- (BOOL)hasNext;

@end


