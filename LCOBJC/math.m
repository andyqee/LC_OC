//
//  math.m
//  LCOBJC
//
//  Created by ethon_qi on 20/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "math.h"

@implementation math

// http://www.cnblogs.com/grandyang/p/5619296.html

// 方法1 ：binary search log(num) 
// 0 算不算
// 缩短范围
// https://discuss.leetcode.com/topic/49339/o-1-time-c-solution-inspired-by-q_rsqrt

- (BOOL)isPerfectSquare:(NSInteger)num
{
    if(num < 0){
        return NO;
    }
    NSInteger l = 1;
    NSInteger r = num / 2 + 1;
    while(l <= r){
        NSInteger mid = (r - l) / 2 + 1;
        NSInteger product = mid * mid; // 可能会溢出 问题
        if(product == num){
            return YES;
        } else if(product < num) {
            r = mid - 1;
        } else {
            l = mid + 1;
        }
    }
    return NO;
}

// 数学方法  O（sqrt（n））
// 1 = 1
// 4 = 1 + 3
// 9 = 1 + 3 + 5
// 16 = 1 + 3 + 5 + 7
// 25 = 1 + 3 + 5 + 7 + 9
// 36 = 1 + 3 + 5 + 7 + 9 + 11
// ....
// 1+3+...+(2n-1) = (2n-1 + 1)n/2 = n*n

// class Solution {
// public:
//     bool isPerfectSquare(int num) {
//         int i = 1;
//         while (num > 0) {
//             num -= i;
//             i += 2;
//         }
//         return num == 0;
//     }
// };

//  牛顿法
//  boolean isPerfectSquare(int num) {
//       if (num < 1) return false;
//       long t = num / 2;
//       while (t * t > num) {
//         t = (t + num / t) / 2;
//       }
//       return t * t == num;
//     }

@end
