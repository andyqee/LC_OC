//
//  SlideWindow.m
//  LCOBJC
//
//  Created by ethon_qi on 21/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "SlideWindow.h"

@implementation SlideWindow

// https://discuss.leetcode.com/topic/17063/4ms-o-n-8ms-o-nlogn-c
// Binary Search 的实现有些复杂 Olg(n). TODO： 可以自己实现下
// 209. Minimum Size Subarray Sum
// 滑动窗口
// >= s

//  Since the array elements are all positive numbers, we could use a sliding window approach. W first move the front pointer until the sum of the subarray is greater or equal to the target value s, then we calculate the size of the window. Then we try to move the rear pointer and recalculate the window size, until the sum of the window is less than the target s.
//  要求是非负数
- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray<NSNumber *> *)nums
{
    NSInteger start = 0;
    NSInteger minSize = NSIntegerMax;
    NSInteger sum = 0;
    
    for(NSInteger i = 0; i < [nums count]; i++) {
        sum += nums[i].integerValue;
        while(sum >= s) {//
            minSize = MIN(minSize, i - start + 1);
            sum = sum - nums[start].integerValue;
            start++;
        }
    }
    return minSize == NSIntegerMax ? 0 : minSize;
}

//53. Maximum Subarray
//这种解法是找 sum == s， >=s不行吧

- (NSInteger)minimumSizeSubArraySum_Method:(NSInteger)target nums:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *> *sum = [NSMutableArray array];
    [sum addObject:nums[0]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger minSize = NSIntegerMax;
    
    for(NSInteger i = 1; i < nums.count; i++){
        [sum addObject: @(sum[i-1].integerValue + nums[i].integerValue)];
        dic[sum[i]] = @(i);
        NSNumber *start = dic[@(sum[i].integerValue - target)];
        if(start){
            minSize = MIN(minSize, i - start.integerValue + 1);
        }
    }
    return minSize;
}



#pragma mark - hard

// Similar  (H) Substring with Concatenation of All Words , (H) Sliding Window Maximum  (H) Sliding Window Maximum
// Fellow up : 如果t是unique的, 该怎么弄？
//https://discuss.leetcode.com/topic/30941/here-is-a-10-line-template-that-can-solve-most-substring-problems/2
// 这种双指针 + HashMap的构建一个代码，用来解决上面几种问题

- (NSString *)minWindow:(NSString *)str t:(NSString *)t
{
    NSMutableDictionary<NSString *, NSNumber *> *map = [NSMutableDictionary dictionary];
    for(NSInteger i = 0; i < t.length; i++){
        NSString *ch = [t substringWithRange:NSMakeRange(i, 1)];
        map[ch] = @(map[ch].integerValue + 1); //统计次数
    }
    
    NSInteger start = 0;
    NSInteger head = 0;
    NSInteger end = 0;
    NSInteger count = t.length; //这里没有想到用count
    NSInteger minLen = NSIntegerMax;
    
    while (end < str.length) {
        NSString *ch = [str substringWithRange:NSMakeRange(end, 1)];
        if(map[ch] && map[ch].integerValue > 0){ // 发现在t中 --
            count--; //
        }
        map[ch] = @(map[ch].integerValue - 1); // 减少frequecy
        end++; // 指向使得count == 0 的下一个字符串，所以在算长度的时候，不需要 + 1
        
        while(count == 0){ // 0
            if(end - start < minLen){
                head = start;
                minLen = end - start;
            }
            NSString *ch = [str substringWithRange:NSMakeRange(start, 1)];
            map[ch] = @(map[ch].integerValue + 1); //不管怎样先++
            start++;
            if(map[ch] && map[ch].integerValue > 0){ //发现 如果在t中
                count++;
            }
        }
    }
    return minLen == NSIntegerMax ? @"" : [str substringWithRange:NSMakeRange(head, minLen)];
}

@end
