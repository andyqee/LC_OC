//
//  BackTracking.h
//  LCOBJC
//
//  Created by ethon_qi on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"

@interface BackTracking : NSObject

- (NSArray<NSString *> *)binaryTreePaths:(TreeNode *)node;
- (NSArray<NSString *> *)binaryTreePaths_LJSolution:(TreeNode *)node;

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
// Difficulty: Medium
// Contributors: Admin
// Given a digit string, return all possible letter combinations that the number could represent.

// A mapping of digit to letters (just like on the telephone buttons) is given below.

// Input:Digit string "23"
// Output: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].
// Note:
// Although the above answer is in lexicographical order, your answer could be in any order you want.

- (NSArray<NSString *> *)letterCombinations:(NSString *)digits;
- (NSArray<NSString *> *)letterCombinations_dfs:(NSString *)digits;

//39
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

- (NSArray<NSArray *> *)combinationSum_optimize:(NSArray *)array target:(NSInteger)target;


// 40 Combination Sum 2
- (NSArray<NSArray *> *)combinationSum_2:(NSArray *)array target:(NSInteger)target;

// 216. Combination Sum III
//Find all possible combinations of k numbers that add up to a number n, given that only numbers from 1 to 9 can be used and each combination should be a unique set of numbers.
//
//
//Example 1:
//
//Input: k = 3, n = 7
//
//Output:
//
//[[1,2,4]]
//
//Example 2:
//
//Input: k = 3, n = 9
//
//Output:
//
//[[1,2,6], [1,3,5], [2,3,4]]

- (NSArray<NSArray *> *)combinationSum_3:(NSInteger)sum count:(NSInteger)k;

//46. Permutations   
//Difficulty: Medium
//Contributors: Admin
//Given a collection of distinct numbers, return all possible permutations.
//
//For example,
//[1,2,3] have the following permutations:
//[
// [1,2,3],
// [1,3,2],
// [2,1,3],
// [2,3,1],
// [3,1,2],
// [3,2,1]
// ]
//

- (NSArray<NSArray *> *)permut:(NSArray<NSNumber *> *)nums;
- (NSArray<NSArray *> *)permut_i:(NSArray<NSNumber *> *)nums;

- (NSArray<NSArray *> *)permut2:(NSArray<NSNumber *> *)nums;

// 60. Permutation Sequence
//The set [1,2,3,…,n] contains a total of n! unique permutations.
//
//By listing and labeling all of the permutations in order,
//We get the following sequence (ie, for n = 3):
//
//"123"
//"132"
//"213"
//"231"
//"312"
//"321"
//Given n and k, return the kth permutation sequence.

- (NSString *)getPermutation:(NSInteger)n k:(NSInteger)k;

//31. Next Permutation
//Difficulty: Medium
//Implement next permutation, which rearranges numbers into the lexicographically next greater permutation of numbers.
//
//If such arrangement is not possible, it must rearrange it as the lowest possible order (ie, sorted in ascending order).
//
//The replacement must be in-place, do not allocate extra memory.
//
//Here are some examples. Inputs are in the left-hand column and its corresponding outputs are in the right-hand column.
//1,2,3 → 1,3,2
//3,2,1 → 1,2,3
//1,1,5 → 1,5,1

- (void)nextPermutation:(NSMutableArray *)nums;

- (void)previousPermutation:(NSMutableArray *)nums;

//131. Palindrome Partitioning
//Difficulty: Medium
//Given a string s, partition s such that every substring of the partition is a palindrome.
//Return all possible palindrome partitioning of s.
//For example, given s = "aab",
//Return
//
//[
// ["aa","b"],
// ["a","a","b"]
//]

- (NSArray<NSArray<NSString *> *> *)partition:(NSString *)str;

// 77. Combinations
// Given two integers n and k, return all possible combinations of k numbers out of 1 ... n.
// For example,
// If n = 4 and k = 2, a solution is:
// [
//   [2,4],
//   [3,4],
//   [2,3],
//   [1,2],
//   [1,3],
//   [1,4],
// ]

- (NSArray<NSNumber *> *)combineNumber:(NSInteger)n k:(NSInteger)k;
- (NSArray<NSArray<NSNumber *> *> *)combineNumberMethod2:(NSInteger)n k:(NSInteger)k;
- (NSSet<NSSet<NSNumber *> *> *)combineNumberMethod3:(NSInteger)n k:(NSInteger)k;

// 10. Regular Expression Matching 重点
// Difficulty: Hard
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

- (NSInteger)numIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid;

// Fellow up: max size of largest Island
- (NSInteger)maxSizeIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid;

// Fellow up 2: remove Island that less than k size

- (void)removeIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid k:(NSInteger)k;

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

//DP 161 One Edit Distance

- (BOOL)isOneEditDistance:(NSString *)str withStr:(NSString *)str2;

//282. Expression Add Operators

//Difficulty: Hard
//Contributors: Admin
//Given a string that contains only digits 0-9 and a target value, return all possibilities to add binary operators (not unary) +, -, or * between the digits so they evaluate to the target value.
//
//Examples:
//"123", 6 -> ["1+2+3", "1*2*3"]
//"232", 8 -> ["2*3+2", "2+3*2"]
//"105", 5 -> ["1*0+5","10-5"]
//"00", 0 -> ["0+0", "0-0", "0*0"]
//"3456237490", 9191 -> []

- (NSString *)addOperators:(NSString *)num target:(NSInteger)target;

//218. The Skyline Problem

//LZ用的是max heap扫一遍的做法，小哥表示没有见过~不过time complexity跟devide and conquer一样嘛，都是O(nlog(n))~
//在用PriorityQueue加入和移除height上跟小哥讨论了很久
//最后他让我用个Binary search tree做~

- (NSArray<NSNumber *> *)getSkyline:(NSArray<NSArray<NSNumber *> *> *)nums;

//[LOCK]Walls and Gates

//You are given a m x n 2D grid initialized with these three possible values.
//
//-1 - A wall or an obstacle.
//0 - A gate.
//INF - Infinity means an empty room. We use the value 2^31 - 1 = 2147483647 to represent INF as you may assume that the distance to a gate is less than 2147483647.
//Fill each empty room with the distance to its nearest gate. If it is impossible to reach a gate, it should be filled with INF.
//
//For example, given the 2D grid:
//INF  -1  0  INF
//INF INF INF  -1
//INF  -1 INF  -1
//0  -1 INF INF
//
//After running your function, the 2D grid should be:
//3  -1   0   1
//2   2   1  -1
//1  -1   2  -1
//0  -1   3   4

- (void)wallsAndGates:(NSMutableArray *)rooms;

//51. N-Queens

//Difficulty: Hard
//Contributors: Admin
//The n-queens puzzle is the problem of placing n queens on an n×n chessboard such that no two queens attack each other.
//
//Given an integer n, return all distinct solutions to the n-queens puzzle.
//
//Each solution contains a distinct board configuration of the n-queens' placement, where 'Q' and '.' both indicate a queen and an empty space respectively.
//
//For example,
//There exist two distinct solutions to the 4-queens puzzle:
//
//[
// [".Q..",  // Solution 1
//  "...Q",
//  "Q...",
//  "..Q."],
// 
// ["..Q.",  // Solution 2
//  "Q...",
//  "...Q",
//  ".Q.."]
// ]
//

- (NSArray<NSArray<NSNumber *> *> *)solveNQueens:(NSInteger)n;

// TODO: 面筋新题
// http://www.1point3acres.com/bbs/forum.php?mod=viewthread&tid=218509&extra=page%3D1%26filter%3Dsortid%26sortid%3D311%26searchoption%5B3046%5D%5Bvalue%5D%3D2%26searchoption%5B3046%5D%5Btype%5D%3Dradio%26sortid%3D311
//一个m x n 的 array 只有 0 和 1  给一个 int k
//需要把 小于 k 数量 连续的 1 变成 0
//连续： 上下左右和四个斜线方向
//面试官是个中国女孩

@end

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

