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



//85. Maximal Rectangle   Add to List QuestionEditorial Solution  My Submissions

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

@end
