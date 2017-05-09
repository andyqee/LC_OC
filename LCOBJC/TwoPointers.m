//
//  TwoPointers.m
//  LCOBJC
//
//  Created by ethon_qi on 31/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "TwoPointers.h"

@implementation TwoPointers

#pragma mark - 第1类 从左往右，包含slide window

#pragma mark - strStr [E]

// 1.双指针
// 2.outer loop up bounds haystack.length - needle.length

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle
{
    //which integer indicate not found index
    // m * n
    // 如果俩枚都是空怎么播
    if (needle.length == 0 || haystack.length == 0) {
        return NSNotFound;
    }
    for (NSInteger i = 0; i <= haystack.length - needle.length; ++i) //这里是 <=
    {
        for (NSUInteger j = 0; j < needle.length; ++j)
        {
            if (![[haystack substringWithRange:NSMakeRange(i+j, 1)] isEqualToString:[needle substringWithRange:NSMakeRange(j, 1)]]) {
                break;
            }
            if (j == needle.length - 1) {
                return i;
            }
        }
    }
    return - 1;
}

#pragma mark - Trapping Rain Water [H]

// 想到用stack, 但是这里面有很多状态，这里为了计算宽度需要把index存起来
// 这里的关键还是状态控制 stack 为空，bottom 状态的变化

// 方法1 stack
// T: O(n) Space: worst case : O(n)

- (NSInteger)trap:(NSArray<NSNumber *> *)nums
{
    NSInteger result = 0;
    NSMutableArray<NSNumber *> *stack = [NSMutableArray array];
    NSInteger bottom = 0;//底部
    
    NSInteger idx = 0;
    while (idx < nums.count) {
        if([stack count] == 0 || nums[idx].integerValue <= nums[[stack lastObject].integerValue].integerValue){ //这里需要注意的是stack为空
            [stack addObject:@(idx)];
            idx++;
        } else {
            bottom = nums[[stack lastObject].integerValue].integerValue;
            [stack removeLastObject];
            
            if([stack count]){
                NSInteger height = MIN(nums[idx].integerValue, nums[[stack lastObject].integerValue].integerValue) - bottom;
                result += height * (idx - [stack lastObject].integerValue - 1);
            }
        }
    }
    
    return result;
}

#pragma mark - 第三类 两边往中间走

//方法二 Two pointers
// https://discuss.leetcode.com/topic/3016/share-my-short-solution
// 这种方法不太好想，需要对照着图，大脑演示一遍.
// Search from left to right and maintain a max height of left and right separately, which is like a one-side wall of partial container.
// Fix the higher one and flow water from the lower part.
// For example, if current height of left is lower, we fill water in the left bin. Until left meets right, we filled the whole container.

// 除此之外有第三种方法： https://discuss.leetcode.com/topic/40609/c-time-o-n-space-o-1-no-stack-no-two-pointers

- (NSInteger)trap_TwoPointers:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = nums.count - 1;
    NSInteger result = 0;
    
    NSInteger maxLeft = 0;
    NSInteger maxRight = 0;
    
    while (left < right) {
        if(nums[left].integerValue <= nums[right].integerValue){  //说明比maxLeft 矮的肯定可以容下水
            if(maxLeft < nums[left].integerValue){
                maxLeft = nums[left].integerValue;
            } else { // max > nums[left] && nums[left].integerValue <= nums[right].integerValue
                result += maxLeft - nums[left].integerValue;
            }
            left++;
        } else {
            if(maxRight < nums[right].integerValue){ //说明比maxRight 矮的肯定可以容下水
                maxRight = nums[right].integerValue;
            } else {
                result += maxRight - nums[right].integerValue;
            }
            right--;
        }
    }
    
    return result;
}

#pragma mark - sorted colors[M]
// fellow up 写一个stable color color，相同的key 保持原来的顺序

- (void)sortedColorsBucketSort:(NSMutableArray<NSNumber *> *)nums k:(NSInteger)k
{
    NSMutableDictionary<NSNumber*, NSNumber*> *dic = [NSMutableDictionary dictionary];
    for(NSNumber *num in nums){
        if(dic[num]){
            dic[num] = @(dic[num].integerValue + 1);
        } else {
            dic[num] = @(1);
        }
    }
    
    NSInteger j = 0;
    for(NSInteger i = 0; i < k; i++){
        if(dic[@(i)]){
            NSInteger count = dic[@(i)].integerValue;
            while(count > 0){
                nums[j] = @(i);
                j++;
                count--;
            }
        }
    }
}

//统计个数0 1 2，然后rewrite 的array。 Two pass algorithm
// 没有实现

// 记住这几个 index 的位置 九章算法版本
// 0......0   1......1  x1 x2 .... xm   2.....2
//            |         |           |
//           left      cur        right
//Fellow up 如果是sorted K，可以使用桶排序

- (void)sortedColors:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1) {
        return;
    }
    NSInteger left = 0; // 关键: 1.确保left 左边都是0，但不包含本身
    NSInteger right = [nums count] - 1; // 2.right 右边都是2 不包含本身， 注意 0 1 2 的比较顺序
    NSInteger cur = 0;   // 3. num[curr] == 2 的时候 不更新
    while(cur <= right) {
        if(nums[cur].integerValue == 0) {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:left]; //
            cur++; //因为要append sorted part
            left++;
        } else if(nums[cur].integerValue == 1) {
            cur++;
        } else {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:right];
            right--;
        }
    }
}

@end
