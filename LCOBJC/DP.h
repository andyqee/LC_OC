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

@end
