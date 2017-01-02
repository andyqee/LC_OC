//
//  DP.h
//  LCOBJC
//
//  Created by ethon_qi on 23/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DP : NSObject

// 139. Word Break
// Difficulty: Medium

// Given a string s and a dictionary of words dict, determine if s can be segmented into a space-separated sequence of one or more dictionary words.

// For example, given
// s = "leetcode",
// dict = ["leet", "code"].

// Return true because "leetcode" can be segmented as "leet code".

- (BOOL)wordBreak:(NSString *)str set:(NSSet*)set;

- (NSString *)wordBreakFollowup:(NSString *)str set:(NSSet*)set;

// 140. Word Break II

// Difficulty: Hard
// Contributors: Admin
// Return all such possible sentences.

// For example, given
// s = "catsanddog",
// dict = ["cat", "cats", "and", "sand", "dog"].

// A solution is ["cats and dog", "cat sand dog"].

- (NSArray<NSString *> *)wordBreak_2:(NSString *)str set:(NSSet*)set;

//https://leetcode.com/articles/longest-palindromic-substring/


// Boom Enemy 炸弹人

// Given a 2D grid, each cell is either a wall 'W', an enemy 'E' or empty '0' (the number zero), return the maximum enemies you can kill using one bomb.
// The bomb kills all the enemies in the same row and column from the planted point until it hits the wall since the wall is too strong to be destroyed.
// Note that you can only put the bomb at an empty cell.

// For the given grid

// 0 E 0 0
// E 0 W E
// 0 E 0 0

// return 3. (Placing a bomb at (1,1) kills 3 enemies)

- (NSInteger)maxKilledEnemies:(NSArray<NSArray<NSNumber *> *> *)matrix;

//85. Maximal Rectangle   Add to List QuestionEditorial Solution

//Difficulty: Hard
//Contributors: Admin
//Given a 2D binary matrix filled with 0's and 1's, find the largest rectangle containing only 1's and return its area.
//
//For example, given the following matrix:
//
//1 0 1 0 0
//1 0 1 1 1
//1 1 1 1 1
//1 0 0 1 0
//Return 6.

- (NSInteger)maximalRectangle:(NSArray<NSArray<NSString *> *> *)matrix;

// Paint House 
// There are a row of n houses, each house can be painted with one of the three colors: red, blue or green. 
// The cost of painting each house with a certain color is different. 
// You have to paint all the houses such that no two adjacent houses have the same color.
// The cost of painting each house with a certain color is represented by a n x 3 cost matrix. 
// For example, costs[0][0] is the cost of painting house 0 with color red; 
// costs[1][2] is the cost of painting house 1 with color green, and so on... Find the minimum cost to paint all houses.

// Note:
// All costs are positive integers.
// int minCost(vector<vector<int>>& costs)

- (NSInteger)minCost:(NSArray<NSArray<NSNumber *> *> *)matrix;

// Paint House 2

//There are a row of n houses, each house can be painted with one of the k colors. The cost of painting each house with a certain color is different. You have to paint all the houses such that no two adjacent houses have the same color.
//
//The cost of painting each house with a certain color is represented by a n x k cost matrix. For example, costs[0][0] is the cost of painting house 0 with color 0; costs[1][2]is the cost of painting house 1 with color 2, and so on... Find the minimum cost to paint all houses.
//
//Note:
//All costs are positive integers.
//
//Follow up:
//Could you solve it in O(nk) runtime?

- (NSInteger)minCost2:(NSArray<NSArray<NSNumber *> *> *)matrix;

- (NSInteger)minCost2_optmize:(NSArray<NSArray<NSNumber *> *> *)matrix;

- (NSInteger)minCost2_optmize2:(NSArray<NSArray<NSNumber *> *> *)matrix;

// Paint Fence

//There is a fence with n posts, each post can be painted with one of the k colors.
//You have to paint all the posts such that no more than two adjacent fence posts have the same color.
//Return the total number of ways you can paint the fence.
//Note:
//n and k are non-negative integers.

- (NSInteger)numWays:(NSInteger)n color:(NSInteger)k;

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

//A line other than the last line might contain only one word. What should you do in this case?
//In this case, that line should be left-justified.

- (NSArray<NSString *> *)fullJustify:(NSArray<NSString *> *)str length:(NSInteger)len;

//312. Burst Balloons
//Difficulty: Hard
//Contributors: Admin
//Given n balloons, indexed from 0 to n-1. Each balloon is painted with a number on it represented by array nums. You are asked to burst all the balloons. If the you burst balloon i you will get nums[left] * nums[i] * nums[right] coins. Here left and right are adjacent indices of i. After the burst, the left and right then becomes adjacent.
//
//Find the maximum coins you can collect by bursting the balloons wisely.
//
//Note:
//(1) You may imagine nums[-1] = nums[n] = 1. They are not real therefore you can not burst them.
//(2) 0 ≤ n ≤ 500, 0 ≤ nums[i] ≤ 100
//
//Example:
//
//Given [3, 1, 5, 8]
//
//Return 167
//
//nums = [3,1,5,8] --> [3,5,8] -->   [3,8]   -->  [8]  --> []
//coins =  3*1*5      +  3*5*8    +  1*3*8      + 1*8*1   = 167
//Credits:

- (NSInteger)maxCoin:(NSArray<NSNumber *> *)nums;

//    309. Best Time to Buy and Sell Stock with Cooldown
//    Difficulty: Medium
//    Say you have an array for which the ith element is the price of a given stock on day i.
//
//    Design an algorithm to find the maximum profit. You may complete as many transactions as you like (ie, buy one and sell one share of the stock multiple times) with the following restrictions:
//
//    You may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).
//    After you sell your stock, you cannot buy stock on next day. (ie, cooldown 1 day)
//    Example:
//
//    prices = [1, 2, 3, 0, 2]
//    maxProfit = 3
//    transactions = [buy, sell, cooldown, buy, sell]

- (NSInteger)maxProfitCooldown:(NSArray<NSNumber *> *)pairs;

// 121. Best Time to Buy and Sell Stock
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

// 122. Best Time to Buy and Sell Stock II
// Difficulty: Medium
// Contributors: Admin
// Say you have an array for which the ith element is the price of a given stock on day i.

// Design an algorithm to find the maximum profit.
// You may complete as many transactions as you like (ie, buy one and sell one share of the stock multiple times).
// However, you may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

- (NSInteger)maxProfit_2:(NSArray<NSNumber *> *)prices;

//123. Best Time to Buy and Sell Stock III

//Say you have an array for which the ith element is the price of a given stock on day i.
//
//Design an algorithm to find the maximum profit. You may complete at most two transactions.
//
//Note:
//You may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

- (NSInteger)maxProfit_3:(NSArray<NSNumber *> *)prices;

//188. Best Time to Buy and Sell Stock IV

//Difficulty: Hard
//Contributors: Admin
//Say you have an array for which the ith element is the price of a given stock on day i.
//
//Design an algorithm to find the maximum profit. You may complete at most k transactions.
//
//Note:
//You may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

- (NSInteger)maxProfit:(NSArray<NSNumber *> *)prices k:(NSInteger)k;

// 300. Longest Increasing Subsequence [M]
// TAG: DP
//Given an unsorted array of integers, find the length of longest increasing subsequence.
//
//For example,
//Given [10, 9, 2, 5, 3, 7, 101, 18],
//The longest increasing subsequence is [2, 3, 7, 101], therefore the length is 4. Note that there may be more than one LIS combination, it is only necessary for you to return the length.
//
//Your algorithm should run in O(n2) complexity.
//
//Follow up: Could you improve it to O(n log n) time complexity?

- (NSInteger)longestLIS:(NSArray<NSNumber *> *)prices;

@end
