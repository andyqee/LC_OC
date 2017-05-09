//
//  TwoPointers.h
//  LCOBJC
//
//  Created by ethon_qi on 31/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoPointers : NSObject

// 28. Implement strStr() [E]
// Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle;

// 42. Trapping Rain Water

// Difficulty: Hard
// Contributors: Admin
// Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it is able to trap after raining.

// For example,
// Given [0,1,0,2,1,0,1,3,2,1,2,1], return 6.

- (NSInteger)trap:(NSArray<NSNumber *> *)nums;

- (NSInteger)trap_TwoPointers:(NSArray<NSNumber *> *)nums;

// 75. Sort Colors
// Difficulty: Medium
// Contributors: Admin
// Given an array with n objects colored red, white or blue, sort them so that objects of the same color are adjacent, with the colors in the order red, white and blue.

// Here, we will use the integers 0, 1, and 2 to represent the color red, white, and blue respectively.

// Note:
// You are not suppose to use the library's sort function for this problem.
// 根据LC里面的函数定义，没有返回值，是in place modify

- (void)sortedColors:(NSMutableArray *)nums;

@end
