//
//  SlideWindow.h
//  LCOBJC
//
//  Created by ethon_qi on 21/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideWindow : NSObject

// 209. Minimum Size Subarray Sum
// Difficulty: Medium
// Contributors: Admin
// Given an array of n positive integers and a positive integer s, find the minimal length of a subarray of which the sum ≥ s. If there isn't one, return 0 instead.

// For example, given the array [2,3,1,2,4,3] and s = 7,
// the subarray [4,3] has the minimal length under the problem constraint.

- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray *)nums;

//76. Minimum Window Substring

//Given a string S and a string T, find the minimum window in S which will contain all the characters in T in complexity O(n).
//
//For example,
//S = "ADOBECODEBANC"
//T = "ABC"
//Minimum window is "BANC".
//
//Note:
//If there is no such window in S that covers all characters in T, return the empty string "".
//
//If there are multiple such windows, you are guaranteed that there will always be only one unique minimum window in S.

- (NSString *)minWindow:(NSString *)str t:(NSString *)t;

//3. Longest Substring Without Repeating Characters[M]

//Difficulty: Medium
//Contributors: Admin
//Given a string, find the length of the longest substring without repeating characters.
//
//Examples:
//
//Given "abcabcbb", the answer is "abc", which the length is 3.
//
//Given "bbbbb", the answer is "b", with the length of 1.
//
//Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a substring, "pwke" is a subsequence and not a substring.

- (NSInteger)lengthOfLongestSubstring:(NSString *)str;

//80. Remove Duplicates from Sorted Array II   Add to List QuestionEditorial Solution
//Difficulty: Medium
//Contributors: Admin
//Follow up for "Remove Duplicates":
//What if duplicates are allowed at most twice?
//
//For example,
//Given sorted array nums = [1,1,1,2,2,3],
//
//Your function should return length = 5, with the first five elements of nums being 1, 1, 2, 2 and 3. It doesn't matter what you leave beyond the new length.

- (void)removeDuplicates:(NSMutableArray *)nums;

@end
