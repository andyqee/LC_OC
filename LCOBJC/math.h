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

@end
