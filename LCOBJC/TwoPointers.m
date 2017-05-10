//
//  TwoPointers.m
//  LCOBJC
//
//  Created by ethon_qi on 31/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "TwoPointers.h"

@implementation TwoPointers

BOOL isAalphaNumber(unichar ch)
{
    NSCharacterSet *alphanumericCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    return [alphanumericCharacterSet characterIsMember:ch];
}

//头尾双指针，可以和快速排序对比下

- (BOOL)isPalindrome:(NSString *)str
{
    if(str.length <= 1) {
        return YES;
    }
    
    NSInteger start = 0;
    NSInteger end = str.length - 1;
    
    while(start < end) { //这里也可以用if else 的写法
        while(!isAalphaNumber([str characterAtIndex:start]) && start < end) {
            start++;
        }
        while(!isAalphaNumber([str characterAtIndex:end]) && start < end) {
            end--;
        }
        if (start < end) {// 这里不加这个判断条件也可以了也可以，正好是  i == j ,
            if([[str substringWithRange:NSMakeRange(start, 1)] caseInsensitiveCompare:[str substringWithRange:NSMakeRange(end, 1)]] != NSOrderedSame) {
                return NO;
            }
            start++;
            end--;
        }
    }
    return YES;
}

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
    return NSNotFound;
}

#pragma mark - Trapping Rain Water [H] 难题实现方法还要再研究下

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

#pragma mark - 第2类 两边往中间走, K sum 也是这种思路

//11 Container With Most Water[M]
// use pointer with left and right
// step 1:compare the heigh[left] with height[right], we chose to move lowwer side,
// beacuse the height of the container is determinded by the lower line. 如果我们移动高的那个的话，就不可能找到更大的容器，因为高度没有变，宽度反而减小了
//
- (NSInteger)maxArea:(NSArray<NSNumber *> *)heights
{
    NSInteger maxArea = 0;
    NSInteger left = 0;
    NSInteger right = heights.count - 1;
    
    while (left < right) {
        if(heights[right].integerValue > heights[left].integerValue){
            maxArea = MAX(maxArea, heights[left].integerValue * (right - left));
            left++;
        } else {
            maxArea = MAX(maxArea, heights[right].integerValue * (right - left));
            right--;
        }
    }
    return maxArea;
}

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

//public class Solution {
//    public void sortColors(int[] nums) {
//        if (nums == null || nums.length <= 1) {
//            return;
//        }
//        int[] count = new int[3];
//        int[] temp = new int[nums.length];
//        for (int i : nums) {
//            count[i]++;
//        }
//        for (int i = 1; i < 3; i++) {
//            count[i] += count[i - 1];//calculate the starting index of inserting, of each kinds of colors
//        }
//        for (int i = nums.length - 1; i >= 0; i--) { // 这里的顺序是一致的,就是保存通排序的顺序，这里需要逆向遍历
//            int color = nums[i];
//            int pos = --count[color];
//            temp[pos] = color;
//        }
//        for (int i = 0; i < nums.length; i++) {
//            nums[i] = temp[i];
//        }
//    }
//}

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

// 逐步夹逼

////int getCategory(int n), outputs the category(1 to k) of given n
////sort k categories in descending order
//public void sortKColors(int[] nums, int k) {//we assume input left is 0 and right is nums.length - 1
//    if (nums == null || nums.length <= 1 || k <= 1) {
//        return;
//    }
//    int left = 0;
//    int right = nums.length - 1;
//    int min = 1;
//    int max = k;
//    while (left < right) {
//        int i = left;
//        while (i <= right) {
//            if (getCategory(nums[i]) == min) {
//                swap(nums, i, left);
//                left++;
//                i++;
//            } else if (getCategory(nums[i]) > min && getCategory(nums[i]) < max) {
//                i++;
//            } else {
//                swap(nums, i, right);
//                right--;
//            }
//        }
//        min++;
//        max--;
//    }
//}


////http://www.1point3acres.com/bbs/thread-209155-1-1.html
//public class Solution {
//    //given three functions: isHigh(), isMid(), isLow()
//    //sort 3 categories in descending order
//    public void sortColors(int[] nums, int left, int right) {//we assume input left is 0 and right is nums.length - 1
//        if (nums == null || nums.length <= 1) {
//            return;
//        }
//        int i = left;
//        while (i <= right) {//should be i <= right, not i < nums.length !!!eg.[2, 2]; not i < right !!!eg.[1,0];
//            if (isLow(nums[i])) {
//                swap(nums, i, left);
//                left++;//left side of left pointer are all 0, between left & i are all 1
//                i++;//i++ cuz we know what we swap from left pointer is either 0 or 1, i's left side are all 0 and 1
//            } else if (isMid(nums[i])) {
//                i++;
//            } else {//isHigh(nums[i])
//                swap(nums, i, right);
//                right--;//we can't i++ cuz we don't know what we swapped from right pointer, so we still need to check later
//            }
//        }
//    }

#pragma mark - 3 Sum 系列 左右两个指针往中间跑

// MIT open class has video. 这里面用的双指针法，可以解决 “一道把排好序的数组每个element平方，输出还是排好序的”。 head tail 进行比较
// follow up : dont sort use HashMap

- (NSArray<NSArray *> *)threeSum_w3:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 3, @"invalid input");
    
    NSMutableArray *result = [NSMutableArray array];
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    for(NSInteger i = 0; i < nums.count - 2; i++) {
        if (i > 0 && [nums[i] compare:nums[i-1]] == NSOrderedSame) { //去除重复的经典方法
            continue; //skipe duplicate
        }
        NSInteger start = i + 1;
        NSInteger end = nums.count - 1;
        
        while(start < end){
            NSInteger sum = sortedNums[i].integerValue + sortedNums[start].integerValue + sortedNums[end].integerValue;
            if (sum == 0) {
                [result addObject:@[sortedNums[i], sortedNums[start], sortedNums[end]]];
                start++;
                end--;
                while (start < end && sortedNums[start].integerValue == sortedNums[start-1].integerValue) {//这里是和i-1比较
                    start++;
                }
                while (start < end && sortedNums[end].integerValue == sortedNums[end+1].integerValue) { //这里和后面一个进行比较
                    end--;
                }
            } else if(sum < 0){
                start++;
            } else {
                end--;
            }
        }
    }
    return result;
}

- (NSInteger)threeSumCloset:(NSArray<NSNumber *> *)nums target:(NSInteger)target; // 3sum
{
    //sort array
    NSAssert([nums count] >= 3 , @"");
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    
    NSInteger result = NSIntegerMax;
    for(NSUInteger i = 0; i < [nums count] - 2; i++) {
        if(i > 0 && sortedNums[i] == sortedNums[i-1]) {
            continue;
        }
        NSUInteger left = i + 1;
        NSUInteger right = [nums count] - 1;
        NSInteger sum = target - sortedNums[i].integerValue;
        while(left < right) {
            NSInteger diff = (sum - sortedNums[left].integerValue - sortedNums[right].integerValue);
            if(diff == 0) {
                return 0;
            } else
                if(diff < 0) {
                    result = MIN(labs(diff), result);
                    left++;
                } else {
                    result = MIN(labs(diff), result);
                    right--;
                }
            //这里不需要
            while(left < right && sortedNums[left] == sortedNums[left + 1]) {
                left++;
            }
            while(left < right && sortedNums[right] == sortedNums[right - 1]) {
                right--;
            }
        }
    }
    return result;
}

//下面这个版本好
- (NSInteger)threeSumCloset_w2:(NSArray *)nums target:(NSInteger)target
{
    NSAssert([nums count] >= 3, @"invalid input");
    
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    NSInteger result = NSIntegerMax;
    
    for(NSInteger i = 0; i < nums.count - 2; i++) {
        NSInteger start = i + 1;
        NSInteger end = nums.count - 1;
        
        while(start < end){
            NSInteger sum = sortedNums[i].integerValue + sortedNums[start].integerValue + sortedNums[end].integerValue;
            NSInteger diff = (sum - target);
            if(ABS(result) < ABS(diff)) {
                result = diff;
            }
            if (diff > 0) {
                end--;
            } else if(diff < 0){
                start++;
            } else {
                return 0;
            }
        }
    }
    return result + target;// 返回的不是diff，而是和
}

// - (NSInteger)3sumSmaller
// {

// }

#pragma mark - 2 sum

- (NSArray *)twoSum:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    // can we assume the length of nums larger than 1
    if(nums.count < 2) {
        return @[];
    }
    NSMutableDictionary<NSNumber *, NSNumber *> *map = [NSMutableDictionary dictionary];
    for(NSUInteger idx = 0; idx < nums.count; idx++) {
        NSNumber *prevIdx = map[@(target - nums[idx].integerValue)]; //不能有重复元素
        if(prevIdx) {
            return @[prevIdx, @(idx)];
        } else {
            map[nums[idx]] = @(idx); //
        }
    }
    return @[];
}

- (NSArray *)twosumSortedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    // can we assume the length of nums larger than 1
    if(nums.count < 2) {
        return @[];
    }
    
    //idx Two pointer
    NSUInteger l = 0;
    NSUInteger h = nums.count - 1;
    
    while(l < h) {
        NSInteger res = nums[l].integerValue + nums[h].integerValue;
        if(res == target) {
            break;
        } else if(res < target) {
            l++;
        } else {
            h--;
        }
    }
    return @[@(l + 1), @(h + 1)];
}

#pragma mark - 4sum 4 sum

- (NSArray *)fourSum:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] >= 3 , @"");
    
    NSMutableArray *result = [NSMutableArray array];
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSInteger k = 0; k < nums.count - 3; k++) {
        if (k > 0 && [nums[k] compare:nums[k - 1]] == NSOrderedSame) {
            continue; //skipe duplicate
        }
        for(NSInteger i = k + 1; i < nums.count - 2; i++) { // 这里细心点 start form k + 1
            if (i > 0 && [nums[i] compare:nums[i - 1]] == NSOrderedSame) {
                continue; //skipe duplicate
            }
            
            NSInteger start = i + 1;
            NSInteger end = nums.count - 1;
            
            while(start < end){
                NSInteger sum = sortedNums[k].integerValue + sortedNums[i].integerValue + sortedNums[start].integerValue + sortedNums[end].integerValue;
                if (sum == 0) {
                    [result addObject:@[sortedNums[k], sortedNums[i], sortedNums[start], sortedNums[end]]];
                    start++;
                    end--;
                    while (start < end && sortedNums[start].integerValue == sortedNums[start-1].integerValue) {//这里是和i-1比较
                        start++;
                    }
                    while (start < end && sortedNums[end].integerValue == sortedNums[end+1].integerValue) { //这里和后面一个进行比较
                        end--;
                    }
                } else if(sum < 0){
                    start++;
                } else {
                    end--;
                }
            }
        }
    }
    return result;
}

@end
