//
//  Solution.h
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface Solution : NSObject

@end

@interface Solution (Tree)
- (NSArray<NSString *> *)binaryTreePaths:(TreeNode *)node;
- (NSArray<NSString *> *)binaryTreePaths_LJSolution:(TreeNode *)node;
- (NSArray<NSArray<NSNumber *> *> *)zigzagLevelOrder:(TreeNode *)treeNode;

//114. Flatten Binary Tree to Linked List   
//Total Accepted: 102256
//Total Submissions: 309986
//Difficulty: Medium
//Contributors: Admin
//Given a binary tree, flatten it to a linked list in-place.
//
//For example,
//Given
//
//1
/// \
//2   5
/// \   \
//3   4   6
//The flattened tree should look like:
//1
//\
//2
//\
//3
//\
//4
//\
//5
//\
//6

- (void)flattenBSTWithNode:(TreeNode *)node;

//109. Convert Sorted List to Binary Search Tree
//Given a singly linked list where elements are sorted in ascending order, convert it to a height balanced BST.

- (TreeNode *)sortedListToBST:(ListNode *)listNode;

//108. Convert Sorted Array to Binary Search Tree
//Given an array where elements are sorted in ascending order, convert it to a height balanced BST.

- (TreeNode *)sortedArrayToBST:(NSArray *)nodes;

- (TreeNode *)inorderSuccessor:(TreeNode *)root withTargetNode:(TreeNode *)targetNode;

//Given a binary tree, return the vertical order traversal of its nodes' values. (ie, from top to bottom, column by column).
//If two nodes are in the same row and column, the order should be from left to right.
// Examples:
// Given binary tree [3,9,20,null,null,15,7],
//     3
//    / \
//   9  20
//     /  \
//    15   7
// return its vertical order traversal as:
// [
//   [9],
//   [3,15],
//   [20],
//   [7]
// ]
// Given binary tree [3,9,20,4,5,2,7],
//     _3_
//    /   \
//   9    20
//  / \   / \
// 4   5 2   7
// return its vertical order traversal as:
// [
//   [4],
//   [9],
//   [3,5,2],
//   [20],
//   [7]
// ]

- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal:(TreeNode *)treeNode;
- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal_BFS:(TreeNode *)treeNode;


// 297. Serialize and Deserialize Binary Tree
// Difficulty: Hard
// Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

// Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

// For example, you may serialize the following tree

// 1
// / \
// 2   3
// / \
// 4   5
// as "[1,2,3,null,null,4,5]", just the same as how LeetCode OJ serializes a binary tree. You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.
// Note: Do not use class member/global/static variables to store states. Your serialize and deserialize algorithms should be stateless.

- (NSString *)serialize:(TreeNode *)treeNode;

- (TreeNode *)deserialize:(NSString *)string;

- (NSString *)serialize_R:(TreeNode *)treeNode;

- (TreeNode *)deserialize_I:(NSString *)string;
@end


@interface Solution (String)

//394. Decode String   QuestionEditorial Solution
//Difficulty: Medium
//Contributors: Admin
//Given an encoded string, return it's decoded string.
//
//The encoding rule is: k[encoded_string], where the encoded_string inside the square brackets is being repeated exactly k times. Note that k is guaranteed to be a positive integer.
//
//You may assume that the input string is always valid; No extra white spaces, square brackets are well-formed, etc.
//
//Furthermore, you may assume that the original data does not contain any digits and that digits are only for those repeat numbers, k. For example, there won't be input like 3a or 2[4].
//
//Examples:
//
//s = "3[a]2[bc]", return "aaabcbc".
//s = "3[a2[c]]", return "accaccacc".
//s = "2[abc]3[cd]ef", return "abcabccdcdcdef".
//
//Show Tags

- (NSString *)decodeString:(NSString *)str;

//91. Decode Ways   
//Total Accepted: 91338
//Total Submissions: 493602
//Difficulty: Medium
//Contributors: Admin
//A message containing letters from A-Z is being encoded to numbers using the following mapping:
//
//'A' -> 1
//'B' -> 2
//...
//'Z' -> 26
//Given an encoded message containing digits, determine the total number of ways to decode it.
//
//For example,
//Given encoded message "12", it could be decoded as "AB" (1 2) or "L" (12).
//
//The number of ways decoding "12" is 2.

- (NSInteger)numDecodings:(NSString *)s;

// 43. Multiply Strings   
// Total Accepted: 80404
// Total Submissions: 316395
// Difficulty: Medium
// Contributors: Admin
// Given two numbers represented as strings, return multiplication of the numbers as a string.

// Note:
// The numbers can be arbitrarily large and are non-negative.
// Converting the input string to integer is NOT allowed.
// You should NOT use internal library such as BigInteger.

- (NSString *)multiplyStr:(NSString *)str1 andStr:(NSString *)str2;

// Given two binary strings, return their sum (also a binary string).

// For example,
// a = "11"
// b = "1"
// Return "100".

- (NSString *)addBinary:(NSString *)str1 andStr:(NSString *)str2;

// 336. Palindrome Pairs   
// Contributors: Admin
// Given a list of unique words, find all pairs of distinct indices (i, j) in the given list, so that the concatenation of the two words, i.e. words[i] + words[j] is a palindrome.

// Example 1:
// Given words = ["bat", "tab", "cat"]
// Return [[0, 1], [1, 0]]
// The palindromes are ["battab", "tabbat"]
// Example 2:
// Given words = ["abcd", "dcba", "lls", "s", "sssll"]
// Return [[0, 1], [1, 0], [3, 2], [2, 4]]
// The palindromes are ["dcbaabcd", "abcddcba", "slls", "llssssll"]

- (NSString *)palindromePairs:(NSArray<NSString *> *)strs;

// 28. Implement strStr()   
// Total Accepted: 139091
// Total Submissions: 524976
// Difficulty: Easy
// Contributors: Admin
// Implement strStr().

// Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

// 278. First Bad Version   
// Total Accepted: 70219
// Total Submissions: 293176
// Difficulty: Easy
// Contributors: Admin
// You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

// Suppose you have n versions [1, 2, ..., n] and you want to find out the first bad one, which causes all the following ones to be bad.

// You are given an API bool isBadVersion(version) which will return whether version is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.

- (NSInteger)firstBadVersion:(NSInteger)n;

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

// 68. Text Justification   // Difficulty: Hard
// Given an array of words and a length L, format the text such that each line has exactly L characters and is fully (left and right) justified.
// You should pack your words in a greedy approach; that is, pack as many words as you can in each line. Pad extra spaces ' ' 
// when necessary so that each line has exactly L characters.
// Extra spaces between words should be distributed as evenly as possible. 
// If the number of spaces on a line do not divide evenly between words, the empty slots on the left will be assigned more spaces than the slots on the right.
// For the last line of text, it should be left justified and no extra space is inserted between words.

// For example,
// words: ["This", "is", "an", "example", "of", "text", "justification."]
// L: 16.

// Return the formatted lines as:
// [
//    "This    is    an",
//    "example  of text",
//    "justification.  "
// ]
// Note: Each word is guaranteed not to exceed L in length.

- (NSArray<NSString *> *)fullJustify:(NSArray<NSString *> *)str;

// The count-and-say sequence is the sequence of integers beginning as follows:
// 1, 11, 21, 1211, 111221, ...

// 1 is read off as "one 1" or 11.
// 11 is read off as "two 1s" or 21.
// 21 is read off as "one 2, then one 1" or 1211.
// Given an integer n, generate the nth sequence.

// Note: The sequence of integers will be represented as a string.
// 递归 iterate 两种方式
- (NSString *)countAndSay_recursive:(NSInteger)n;
- (NSString *)countAndSay_iterative:(NSInteger)n;

// 49. Group Anagrams 
// Difficulty: Medium
// Given an array of strings, group anagrams together.

// For example, given: ["eat", "tea", "tan", "ate", "nat", "bat"], 
// Return:

// [
//   ["ate", "eat","tea"],
//   ["nat","tan"],
//   ["bat"]
// ]
// Note: All inputs will be in lower-case.

- (NSArray<NSString *> *)groupAnagrams:(NSArray<NSString *> *)strs;

// 139. Word Break 
// Difficulty: Medium

// Given a string s and a dictionary of words dict, determine if s can be segmented into a space-separated sequence of one or more dictionary words.

// For example, given
// s = "leetcode",
// dict = ["leet", "code"].

// Return true because "leetcode" can be segmented as "leet code".

- (BOOL)wordBreak:(NSString *)str set:(NSSet*)set;

// 140. Word Break II   QuestionEditorial Solution  My Submissions

// Difficulty: Hard
// Contributors: Admin
// Given a string s and a dictionary of words dict, add spaces in s to construct a sentence where each word is a valid dictionary word.

// Return all such possible sentences.

// For example, given
// s = "catsanddog",
// dict = ["cat", "cats", "and", "sand", "dog"].

// A solution is ["cats and dog", "cat sand dog"].

- (NSArray<NSString *> *)wordBreak_2:(NSString *)str set:(NSSet*)set;

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

@end

@interface Solution (Array)

// sum 系列
// Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.

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

- (NSArray *)Twosum:(NSArray *)nums target:(NSInteger)target;

//167. Two Sum II - Input array is sorted   
//Total Accepted: 36413
//Total Submissions: 75803
//Difficulty: Medium
//Contributors: Admin
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
// Total Accepted: 6871
// Total Submissions: 26183
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

//- (NSArray<interval *> *)mergeIntervals:(NSArray<interval *> *)intervals;

//350. Intersection of Two Arrays II
//
//Given two arrays, write a function to compute their intersection.
//
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
// Contributors: Admin
// Given two arrays, write a function to compute their intersection.

// Example:
// Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2].

// Note:
// Each element in the result must be unique.
// The result can be in any order.

// unique
- (NSArray<NSNumber *> *)intersectionOfTwoArrayUnique:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2;

// 75. Sort Colors   
// Total Accepted: 127582
// Total Submissions: 351187
// Difficulty: Medium
// Contributors: Admin
// Given an array with n objects colored red, white or blue, sort them so that objects of the same color are adjacent, with the colors in the order red, white and blue.

// Here, we will use the integers 0, 1, and 2 to represent the color red, white, and blue respectively.

// Note:
// You are not suppose to use the library's sort function for this problem.
// 根据LC里面的函数定义，没有返回值，是in place modify

- (void)sortedColors:(NSMutableArray *)nums;

// 153. Find Minimum in Rotated Sorted Array   
// Total Accepted: 120232
// Total Submissions: 314650
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



@end

