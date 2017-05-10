//
//  math.h
//  LCOBJC
//
//  Created by ethon_qi on 20/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface math : NSObject

//13. Roman to Integer
//Difficulty: Easy
//Contributors: Admin
//Given a roman numeral, convert it to an integer.
//
//Input is guaranteed to be within the range from 1 to 3999.

- (NSInteger)romanToInt:(NSString *)str;

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

// 168. Excel Sheet Column Title
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

//326. Power of Three   Add to List QuestionEditorial Solution  My Submissions
//
//Difficulty: Easy
//Contributors: Admin
//Given an integer, write a function to determine if it is a power of three.
//
//Follow up:
//Could you do it without using any loop / recursion?

- (BOOL)isPowerOfThree:(NSInteger)n;

//191. Number of 1 Bits

//Difficulty: Easy
//Write a function that takes an unsigned integer and returns the number of ’1' bits it has (also known as the Hamming weight).
//
//For example, the 32-bit integer ’11' has binary representation 00000000000000000000000000001011, so the function should return 3.

- (NSInteger)hammingWeight:(NSInteger)n;

//224. Basic Calculator
//
//Implement a basic calculator to evaluate a simple expression string.
//
//The expression string may contain open ( and closing parentheses ), the plus + or minus sign -, non-negative integers and empty spaces .
//
//You may assume that the given expression is always valid.
//
//Some examples:
//"1 + 1" = 2
//" 2-1 + 2 " = 3
//"(1+(4+5+2)-3)+(6+8)" = 23
//Note: Do not use the eval built-in library function.
//
//Subscribe to see which companies asked this question

- (NSInteger)calculate:(NSString *)s;

// 43. Multiply Strings
// Difficulty: Medium
// Given two numbers represented as strings, return multiplication of the numbers as a string.

// Note:
// The numbers can be arbitrarily large and are non-negative.
// Converting the input string to integer is NOT allowed.
// You should NOT use internal library such as BigInteger.

- (NSString *)multiplyStr:(NSString *)str1 andStr:(NSString *)str2;

- (NSString *)multiplyStr3:(NSString *)str1 andStr:(NSString *)str2;

// Given two binary strings, return their sum (also a binary string).
// For example,
// a = "11"
// b = "1"
// Return "100".

- (NSString *)addBinary:(NSString *)str1 andStr:(NSString *)str2;

// 66 plus one
- (NSArray *)plusone:(NSArray *)nums;


- (BOOL)validNumber:(NSString *)str;

@end
