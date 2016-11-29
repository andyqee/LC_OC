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

// 140. Word Break II

// Difficulty: Hard
// Contributors: Admin
// Return all such possible sentences.

// For example, given
// s = "catsanddog",
// dict = ["cat", "cats", "and", "sand", "dog"].

// A solution is ["cats and dog", "cat sand dog"].

- (NSArray<NSString *> *)wordBreak_2:(NSString *)str set:(NSSet*)set;

//44. Wildcard Matching

//Implement wildcard pattern matching with support for '?' and '*'.
//
//'?' Matches any single character.
//'*' Matches any sequence of characters (including the empty sequence).
//
//The matching should cover the entire input string (not partial).
//
//The function prototype should be:
//bool isMatch(const char *s, const char *p)
//
//Some examples:
//isMatch("aa","a") → false
//isMatch("aa","aa") → true
//isMatch("aaa","aa") → false
//isMatch("aa", "*") → true
//isMatch("aa", "a*") → true
//isMatch("ab", "?*") → true
//isMatch("aab", "c*a*b") → false

- (BOOL)isMatchString:(NSString *)str patten:(NSString *)p;

@end
