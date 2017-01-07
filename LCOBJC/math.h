//
//  math.h
//  LCOBJC
//
//  Created by ethon_qi on 20/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface math : NSObject

// 367. Valid Perfect Square   QuestionEditorial Solution  My Submissions

// Difficulty: Medium
// Contributors: Admin
// Given a positive integer num, write a function which returns True if num is a perfect square else False.
// Note: Do not use any built-in library function such as sqrt.
// Example 1:

// Input: 16
// Returns: True
// Example 2:

// Input: 14
// Returns: False

- (BOOL)isPerfectSquare:(NSInteger)num;

- (double)power:(NSInteger)n k:(NSInteger)k;

//29. Divide Two Integers
// 肯定不太可能完成float 精度级别的
- (NSInteger)divide:(NSInteger)dividend divisor:(NSInteger)divisor;

- (NSInteger)divideMethod2:(NSInteger)dividend divisor:(NSInteger)divisor;

// 168. Excel Sheet Column Title   Add to List QuestionEditorial Solution  My Submissions
// Difficulty: Easy
// Contributors: Admin
// Given a positive integer, return its corresponding column title as appear in an Excel sheet.

// For example:

//     1 -> A
//     2 -> B
//     3 -> C
//     ...
//     26 -> Z
//     27 -> AA
//     28 -> AB 

- (NSString *)convertToTitle:(NSInteger)n;

// determine is power of 2
- (BOOL)isPowerOfTwo:(NSInteger)n;

//191. Number of 1 Bits

//Difficulty: Easy
//Write a function that takes an unsigned integer and returns the number of ’1' bits it has (also known as the Hamming weight).
//
//For example, the 32-bit integer ’11' has binary representation 00000000000000000000000000001011, so the function should return 3.
- (NSInteger)hammingWeight:(NSInteger)n;

@end
