//
//  BackTracking.h
//  LCOBJC
//
//  Created by ethon_qi on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackTracking : NSObject

// 79. Word Search
// Difficulty: Medium
// Contributors: Admin
// Given a 2D board and a word, find if the word exists in the grid.

// The word can be constructed from letters of sequentially adjacent cell,
// where "adjacent" cells are those horizontally or vertically neighboring.
// The same letter cell may not be used more than once.

// For example,
// Given board =

// [
//   ['A','B','C','E'],
//   ['S','F','C','S'],
//   ['A','D','E','E']
// ]

// word = "ABCCED", -> returns true,
// word = "SEE", -> returns true,
// word = "ABCB", -> returns false.

- (BOOL)existWithBoard:(NSArray<NSArray<NSString *> *> *)board word:(NSString *)word;

// 17. Letter Combinations of a Phone Number   
// Total Accepted: 110836
// Total Submissions: 349890
// Difficulty: Medium
// Contributors: Admin
// Given a digit string, return all possible letter combinations that the number could represent.

// A mapping of digit to letters (just like on the telephone buttons) is given below.

// Input:Digit string "23"
// Output: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].
// Note:
// Although the above answer is in lexicographical order, your answer could be in any order you want.

- (NSArray<NSString *> *)letterCombinations:(NSString *)digits;
- (NSArray<NSString *> *)letterCombinations_recursive:(NSString *)digits;

// Combination Sum I

// Given a set of candidate numbers (C) and a target number (T), find all unique combinations in C where the candidate numbers sums to T.
// The same repeated number may be chosen from C unlimited number of times.
// Note:
// All numbers (including target) will be positive integers.
// Elements in a combination (a1, a2, … , ak) must be in non-descending order. (ie, a1 ≤ a2 ≤ … ≤ ak).
// The solution set must not contain duplicate combinations.
// For example, given candidate set 2,3,6,7 and target 7,
// A solution set is:
// [7]
// [2, 2, 3] 

- (NSArray<NSArray *> *)combinationSum:(NSArray *)array target:(NSInteger)target;

// Combination Sum 2
- (NSArray<NSArray *> *)combinationSum_2:(NSArray *)array target:(NSInteger)target;

// Combination Sum 3, 4没有做呢

// 10. Regular Expression Matching 重点
// Difficulty: Hard
// Contributors: Admin
// Implement regular expression matching with support for '.' and '*'.

// '.' Matches any single character.
// '*' Matches zero or more of the preceding element.

// The matching should cover the entire input string (not partial).

// The function prototype should be:
// bool isMatch(const char *s, const char *p)

// Some examples:
// isMatch("aa","a") → false
// isMatch("aa","aa") → true
// isMatch("aaa","aa") → false
// isMatch("aa", "a*") → true
// isMatch("aa", ".*") → true
// isMatch("ab", ".*") → true
// isMatch("aab", "c*a*b") → true

- (BOOL)isMatch:(NSString *)str withPatten:(NSString *)p;

// 301. Remove Invalid Parentheses
// Remove the minimum number of invalid parentheses in order to make the input string valid. Return all possible results.

// Note: The input string may contain letters other than the parentheses ( and ).

// Examples:
// "()())()" -> ["()()()", "(())()"]
// "(a)())()" -> ["(a)()()", "(a())()"]
// ")(" -> [""]
// Credits:

- (NSArray<NSString *> *)removeInvalidParentheses:(NSString *)str;

// 78. Subsets   
// Difficulty: Medium
// Contributors: Admin
// Given a set of distinct integers, nums, return all possible subsets.

// Note: The solution set must not contain duplicate subsets.

// For example,
// If nums = [1,2,3], a solution is:

// [
//   [3],
//   [1],
//   [2],
//   [1,2,3],
//   [1,3],
//   [2,3],
//   [1,2],
//   []
// ]

- (NSArray<NSArray *> *)subSets:(NSArray *)nums;

- (NSArray<NSArray *> *)subSet_r:(NSArray *)nums;

- (NSArray<NSArray *> *)subSets_iterate:(NSArray *)nums;


//90. Subsets II
//Total Accepted: 88078
//Total Submissions: 264717
//Difficulty: Medium
//Contributors: Admin
//Given a collection of integers that might contain duplicates, nums, return all possible subsets.
//
//Note: The solution set must not contain duplicate subsets.
//
//For example,
//If nums = [1,2,2], a solution is:
//
//[
// [2],
// [1],
// [1,2,2],
// [2,2],
// [1,2],
// []
// ]

- (NSArray<NSArray *> *)subSetsWithDup:(NSArray *)nums;

// 200. Number of Islands

// Difficulty: Medium
// Given a 2d grid map of '1's (land) and '0's (water), count the number of islands. 
// An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically.
// You may assume all four edges of the grid are all surrounded by water.
// Example 1:

// 11110
// 11010
// 11000
// 00000
// Answer: 1

// Example 2:

// 11000
// 11000
// 00100
// 00011
// Answer: 3

- (NSInteger)numIslands:(NSArray<NSNumber *> *)grid;

// 22. Generate Parentheses
// Difficulty: Medium
// Contributors: Admin
// Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.
// For example, given n = 3, a solution set is:

// [
//   "((()))",
//   "(()())",
//   "(())()",
//   "()(())",
//   "()()()"
// ]

- (NSArray<NSString *> *)generateParenthesis:(NSInteger)count;

// 32. Longest Valid Parentheses
// Difficulty: Hard
// Contributors: Admin
// Given a string containing just the characters '(' and ')', find the length of the longest valid (well-formed) parentheses substring.
// For "(()", the longest valid parentheses substring is "()", which has length = 2.
// Another example is ")()())", where the longest valid parentheses substring is "()()", which has length = 4.

- (NSInteger)longestValidParentheses:(NSString *)str;

//DP 161 One Edit Distance
- (BOOL)isOneEditDistance:(NSString *)str withStr:(NSString *)str2;

// 121. Best Time to Buy and Sell Stock
// Difficulty: Easy
// Contributors: Admin
// Say you have an array for which the ith element is the price of a given stock on day i.
// If you were only permitted to complete at most one transaction (ie, buy one and sell one share of the stock), design an algorithm to find the maximum profit.

// Example 1:
// Input: [7, 1, 5, 3, 6, 4]
// Output: 5

// max. difference = 6-1 = 5 (not 7-1 = 6, as selling price needs to be larger than buying price)
// Example 2:
// Input: [7, 6, 4, 3, 1]
// Output: 0

- (NSInteger)maxProfit:(NSArray<NSNumber *> *)prices;

// 122. Best Time to Buy and Sell Stock II   QuestionEditorial Solution  My Submissions
// Difficulty: Medium
// Contributors: Admin
// Say you have an array for which the ith element is the price of a given stock on day i.

// Design an algorithm to find the maximum profit. 
// You may complete as many transactions as you like (ie, buy one and sell one share of the stock multiple times). 
// However, you may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

- (NSInteger)maxProfit_2:(NSArray<NSNumber *> *)prices;

//198. House Robber
// TAG: DP
//Difficulty: Easy
//Contributors: Admin
//You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.
//
//Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police.

- (NSInteger)rob:(NSArray<NSNumber *> *)nums;

@end

//218. The Skyline Problem

//211. Add and Search Word - Data structure design   
//Difficulty: Medium
//Contributors: Admin
//Design a data structure that supports the following two operations:
//
//void addWord(word)
//bool search(word)
//search(word) can search a literal word or a regular expression string containing only letters a-z or .. A . means it can represent any one letter.
//
//For example:
//
//addWord("bad")
//addWord("dad")
//addWord("mad")
//search("pad") -> false
//search("bad") -> true
//search(".ad") -> true
//search("b..") -> true
//Note:
//You may assume that all words are consist of lowercase letters a-z.

@interface WordDictionary : NSObject

- (void)addWord:(NSString *)word;

- (BOOL)search:(NSString *)word;

@end

