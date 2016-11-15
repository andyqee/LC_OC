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

// 17. Letter Combinations of a Phone Number   QuestionEditorial Solution  My Submissions
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

@end
