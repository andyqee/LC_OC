//
//  SlideWindow.m
//  LCOBJC
//
//  Created by ethon_qi on 21/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "SlideWindow.h"

@implementation SlideWindow

// 地里的面筋题，方法还蛮具有代表性的
// Find subsequence in an array which sums up to given target
// 使用hash table 法，这个和 two sum，使用了类似的技巧

//s[0] = a[0]
//map[s[0]] = 0 // s[i] => i
//for j = 1 to n-1:
//  s[j] = s[j-1] + a[j]
//  map[s[j]] = j
//if map has key (s[j] - target)
//   i = map[s[j]-target]+1
//find_solution(a[i..j])

// 53. Maximum Subarray
// 经典题目

- (NSInteger)maxSubArray:(NSArray<NSNumber *>*)nums
{
    NSInteger sum = 0;
    NSInteger maxSum = NSIntegerMin;
    
    for(NSInteger i = 0; i < nums.count; i++){
        sum += nums[i].integerValue;
        maxSum = MAX(sum, maxSum);
        if(sum < 0){ // 当小于，我们就可以放弃前面的部分了
            sum = 0;
        }
    }
    return maxSum;
}

// divid and conquer
// 3 posibility 1. subarray in left part 2. in right part 3. both

- (NSInteger)maxSubArrayM2:(NSArray<NSNumber *>*)nums
{
    return [self maxSubArrayM2:nums left:0 right:nums.count - 1];
}

// 有点问题

- (NSInteger)maxSubArrayM2:(NSArray<NSNumber *>*)nums left:(NSInteger)left right:(NSInteger)right
{
    if(left > right){ //break recursive
        return NSIntegerMin;
    }
    
    NSInteger mid = ( right - left ) / 2 + left;
    NSInteger leftRes = [self maxSubArrayM2:nums left:left right:mid - 1];
    NSInteger rightRes = [self maxSubArrayM2:nums left:mid + 1 right:right];
    
    NSInteger leftMax = NSIntegerMin;
    NSInteger sum = 0;
    for(NSInteger i = mid - 1; i >= left; i--){
        sum += nums[i].integerValue;
        leftMax = MAX(leftMax, sum);
    }
    
    NSInteger rightMax = NSIntegerMin;
    sum = 0;
    for(NSInteger i = mid + 1; i <= right; i++){
        sum += nums[i].integerValue;
        rightMax = MAX(rightMax, sum);
    }
    
    return MAX(rightMax + leftMax + nums[mid].integerValue, MAX(leftRes, rightRes));
}

// 九章版本的DP

// we use two array left[] right[]
// left[i] represent the max sum of subarray which end with nums[i], start from nums[0]
// right[i] represetn the max sum ... sub array start at nums[i].

// -1, 2, -3 , 4
 
- (NSInteger)maxSubArrayM2_dp:(NSArray<NSNumber *>*)nums
{
    NSMutableArray<NSNumber *> *left = [NSMutableArray array];
    NSMutableArray<NSNumber *> *right = [NSMutableArray array];
   
    for(NSInteger i = 0; i < nums.count; i++){
        [left addObject:@(0)];
        [right addObject:@(0)];
    }
    
    NSInteger maxSumSofar = NSIntegerMin;
    NSInteger minSumSofar = 0; // 这里为啥是初始化成0 呢
    
    NSInteger sum = 0;
    for(NSInteger i = 0; i < nums.count; i++){
        sum += nums[i].integerValue;
        maxSumSofar = MAX(maxSumSofar, sum - minSumSofar);// 为什么这里减去最小值，就是局部最大值呢？
        minSumSofar = MAX(minSumSofar, sum); // -1, -1, -2
        left[i] = @(maxSumSofar);
    }
    
    maxSumSofar = NSIntegerMin;
    minSumSofar = 0;
    sum = 0;
    
    for(NSInteger i = nums.count - 1; i >= 0; i--){
        sum += nums[i].integerValue;
        maxSumSofar = MAX(maxSumSofar, sum - minSumSofar);// 为什么这里减去最小值，就是局部最大值呢？
        minSumSofar = MAX(minSumSofar, sum); // -1, -1, -2
        right[i] = @(maxSumSofar);
    }
    
    maxSumSofar = NSIntegerMin;
    for (NSInteger i = 0; i < nums.count; i++) {
        maxSumSofar = MAX(left[i].integerValue + right[i].integerValue, maxSumSofar);
    }
    return maxSumSofar;
}

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
//    NSMutableArray<NSNumber *> *sum = [NSMutableArray array];
//    [sum addObject:nums[0]];
    NSInteger sum = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger minSize = NSIntegerMax;
    
    for(NSInteger i = 1; i < nums.count; i++){
//        [sum addObject: @(sum[i-1].integerValue + nums[i].integerValue)];
//        dic[sum[i]] = @(i);
        sum += nums[i].integerValue;
        NSNumber *start = dic[@(sum - target)];
        if(start){
            minSize = MIN(minSize, i - start.integerValue + 1);
        }
    }
    return minSize;
}

//: Maximum Size Subarray Sum Equals k

//Given an array nums and a target value k, find the maximum length of a subarray that sums to k. If there isn't one, return 0 instead.
//Example 1:
//Given nums = [1, -1, 5, -2, 3], k = 3,
//return 4. (because the subarray [1, -1, 5, -2] sums to 3 and is the longest)
//Example 2:
//Given nums = [-2, -1, 2, 1], k = 1,
//return 2. (because the subarray [-1, 2] sums to 1 and is the longest)
//Follow Up:
//Can you do it in O(n) time?

//:提示可以用 HashMap。 和2sum 的方法其实很类似
//:没有很快的想到这个办法，刚开始是往two pointer 那个方向去想，发现不可行。

//FIXME:  Note the map.put(0, -1). We need to put this entry into the map before, because if the maximal range starts from 0, we need to calculate sum(j) - sum(i - 1).

// BUG: map.put(0, -1)
// BUG: 这是区间 i - sumIndexMap[@(acc - k)].integerValue 不用 再 + 1， 因为起点起找到的坐标的那个index 之后开始的部分

- (NSInteger)maxSizeSubArray:(NSArray<NSNumber *> *)nums k:(NSInteger)k
{
    if(nums.count == 0)
        return 0;
    
    NSMutableDictionary<NSNumber *, NSNumber*> *sumIndexMap = [NSMutableDictionary dictionary];
    //        map.put(0, -1); // IMPOARTANT
    sumIndexMap[@0] = @(-1);
    
    NSInteger acc = 0;
    NSInteger len = 0;
    
    for(NSInteger i = 0; i < nums.count; i++){
        acc += nums[i].integerValue;
        
        if(sumIndexMap[@(acc - k)]){
            len = MAX(len, i - sumIndexMap[@(acc - k)].integerValue);// 这里不能加！1
        }
        if(!sumIndexMap[@(acc)]){ // 这里为了避免重复将相同的 和 对应的index 覆盖掉，所以需要检测。我们store index更小的
            sumIndexMap[@(acc)] = @(i);
        }
    }
    
    return len;
}

#pragma mark - 76. Minimum Window Substring hard

// Similar  (H) Substring with Concatenation of All Words , (H) Sliding Window Maximum  (H) Sliding Window Maximum
// Fellow up : 如果t是unique的, 该怎么弄？
// https://discuss.leetcode.com/topic/30941/here-is-a-10-line-template-that-can-solve-most-substring-problems/2
// 这种双指针 + HashMap的构建一个代码，用来解决上面几种问题

//1. Use two pointers: start and end to represent a window.
//2. Move end to find a valid window.
//3. When a valid window is found, move start to find a smaller window.
//

- (NSString *)minWindow:(NSString *)str t:(NSString *)t
{
    NSMutableDictionary<NSString *, NSNumber *> *map = [NSMutableDictionary dictionary];
    for(NSInteger i = 0; i < t.length; i++){
        NSString *ch = [t substringWithRange:NSMakeRange(i, 1)];
        map[ch] = @(map[ch].integerValue + 1); //统计次数
    } // dic 可能会变成negative
    
    NSInteger start = 0;
    NSInteger head = 0;// head 和start 有什么区别？ start 是traverse 指针， head 是用来track min length string 的开头位置
    NSInteger end = 0;
    NSInteger count = t.length; //这里没有想到用count
    NSInteger minLen = NSIntegerMax;
    // Move end to find a valid window.
    while (end < str.length) {
        NSString *ch = [str substringWithRange:NSMakeRange(end, 1)];
        if(map[ch].integerValue > 0){ // 发现在t中 --
            count--; //
        }
        map[ch] = @(map[ch].integerValue - 1); // Decrease If char does not exist in t, m[s[end]] will be negative.
        end++; // 指向使得 count == 0 的下一个字符串，所以在算长度的时候，不需要 + 1
        
        while(count == 0){ // When we found a valid window, move start to find smaller window.
            if(end - start < minLen){
                head = start;
                minLen = end - start;
            }
            NSString *ch = [str substringWithRange:NSMakeRange(start, 1)];
            map[ch] = @(map[ch].integerValue + 1); //不管怎样先++
            start++;
            if(map[ch].integerValue > 0){ //发现 如果在t中
                count++;
            }
        }
    }
    return minLen == NSIntegerMax ? @"" : [str substringWithRange:NSMakeRange(head, minLen)];
}

// 不够通透

- (NSString *)minWindow_2s:(NSString *)str t:(NSString *)t
{
    NSParameterAssert(str);
    NSParameterAssert(t);
    
    if(str.length < t.length){
        return @"";
    }
    
    NSMutableDictionary<NSString *, NSNumber *> *expectMap = [NSMutableDictionary dictionary];
    for(NSInteger i = 0; i < t.length; i++){
        NSString *ch = [t substringWithRange:NSMakeRange(i, 1)];
        expectMap[ch] = @(expectMap[ch].integerValue + 1); //step 1: 统计次数
    }
    NSMutableDictionary<NSString *, NSNumber *> *appeartMap = [NSMutableDictionary dictionary];

    NSInteger minLen = NSIntegerMax;
    NSInteger appeared = 0;
    NSInteger start = 0;
    NSInteger subStrHead = 0;

    for (NSInteger end = 0; end < str.length; end++) {
        NSString *ch = [str substringWithRange:NSMakeRange(end, 1)];
        appeartMap[ch] = @(appeartMap[ch].integerValue + 1);
        //step 2: calculate the frequency of char in t wihch appeared which appared in s. and skip the char which not in str t
        //
        if(appeartMap[ch].integerValue <= expectMap[ch].integerValue){ //step 2: 如果不是t中的字符，这里就不满足条件，所以这里是统计找到t 中的字符的个数
            appeared++;
        }
        //step 3: when the length if == t.length. Then we move the rear pointer
        
        if (appeared == t.length) { //开始缩小slide window 获取更小的length
            NSString *sh = [str substringWithRange:NSMakeRange(start, 1)];//前进的策略是,
            while (appeartMap[sh].integerValue > expectMap[sh].integerValue || !expectMap[sh]) { //对于没有在t中出现的, 或者出现频率更高的move start
                appeartMap[sh] = @(appeartMap[sh].integerValue - 1);
                start++;
                sh = [str substringWithRange:NSMakeRange(start, 1)]; //这里不能忘记了 需要重新assign给sh
            }
            if(minLen > end - start + 1){
                minLen = end - start + 1;
                subStrHead = start;
            }
        }
    }
    
    return minLen == NSIntegerMax ? @"" : [str substringWithRange:NSMakeRange(subStrHead, minLen)];
}

//3. Longest Substring Without Repeating Characters [M]

// pwwkew
// abcabcbb
// bacabcd

// j : fast index ，找符合条件的解，并更新
// i : 当有不符合的时候，开始更新，使得重新 符合条件
// while 的condition 条件 看是否和 i 和j 都有关， 因为 i 与 j 本身也有制约关系，很有可能是可以压缩成 j < str.length

// worst case O(2n)
// space : O(k) k is the size of set

// we use two indexes to keep a slide window. The right index to

- (NSInteger)lengthOfLongestSubstring:(NSString *)str
{
    NSInteger maxLen = 0;
    NSMutableSet *set = [NSMutableSet set];
    NSInteger i = 0;
    NSInteger j = 0;
    
    while (j < str.length) { //这里可以精简掉 j < str.length
        NSString *ch = [str substringWithRange:NSMakeRange(j, 1)];
        if(![set containsObject:ch]){
            [set addObject:ch];
            j++;
            maxLen = MAX(maxLen, [set count]); //
        } else {
            NSString *prev = [str substringWithRange:NSMakeRange(i, 1)];//
            [set removeObject:prev];
            i++;
        }
    }
    return maxLen;
}

// 方法2 O(n) 利用dic 来标记当前ch 的index
// instead of using a set to tell if a chracter exists or not , we could define a mapping of the characters to its index.

- (NSInteger)lengthOfLongestSubstring_Optimize:(NSString *)str
{
    NSInteger maxLen = 0;
    NSMutableDictionary<NSString *, NSNumber *> *indexMap = [NSMutableDictionary dictionary];
    NSInteger i = 0;
    
    for (NSInteger j = 0; j < str.length; j++) {
        NSString *ch = [str substringWithRange:NSMakeRange(j, 1)];
        if(indexMap[ch]){ //
            i = MAX(i, indexMap[ch].integerValue);
        }
        maxLen = MAX(maxLen, j - i + 1);
        indexMap[ch] = @(j + 1);
    }
    return maxLen;
}

// in place
// i 用来track 左边已经处理好的数组， j 用来traversal the array,
// compare nums[j] with nums[i] , if equal , j++ else , exchange nums[i] with nums[j]
// 对于 1 2 3 这种没有重复的，其实是和自己 交换

// 容易出错的 !!! 就是返回值 返回 i + 1 ， not i,
// 容易忘记更新 j 是一直更新
// 如果要进一步减少写的次数 可以把 [nums exchangeObjectAtIndex:i withObjectAtIndex:j] 优化成 nums[i] = nums[j]
// 关键是 sorted array, 

- (NSInteger)removeDuplicates:(NSMutableArray *)nums
{
    if(nums.count <= 1){
        return nums.count;
    }
    
    NSInteger i = 0;
    NSInteger j = 1;
    
    while (j < nums.count) {
        if([nums[j] compare:nums[i]] != NSOrderedSame){
            i++;
            [nums exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        j++;
    }
    return i + 1;
}

//Given sorted array nums = [1,1,1,2,2,3],

// @1,@1,@1,@2,@2,@2,@3,@3,@4
//
// 需要再复习下

- (NSInteger)removeDuplicates2:(NSMutableArray *)nums
{
    if(nums.count <= 1){
        return nums.count;
    }
    
    NSInteger i = 0;
    NSInteger j = 1;
    NSInteger count = 1;
    
    while (j < nums.count) {
        if([nums[j] compare:nums[j-1]] != NSOrderedSame){
            count = 1;
            i++;
            nums[i] = nums[j];
        } else {
            if(count < 2){
                count++;
                i++;
                nums[i] = nums[j];
            }
        }
        j++;
    }
    return i + 1;
}

//[@2, @1, @3, @1, @2] --> [@2, @1, @3]
//电话面试就是这题, with set & mutablearray
//或者orderset

- (NSArray *)removeDuplicates3:(NSMutableArray *)nums
{
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:nums];
    return [orderedSet array];
}

// google

// 340 Longest Substring with At Most K Distinct Characters
// 这道题思路不难想，但是要弄对，坑很多.
// eceba

// we need to use a dictionary to store the char - frequecy pairs, when scane the string from left to right
// and use two pinters to keep a sliding window. when we the count of the dic is larger than k, we move the rear pointer and update the dic accordingly
//

- (NSInteger)longestSubstring:(NSString *)str k:(NSInteger)k
{
    if(str.length == 0){
        return 0;
    }
    
    NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    NSInteger j = 0;
    NSInteger max = 0;
    for(NSInteger i = 0; i < str.length; i++){
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        dic[ch] = @(dic[ch].integerValue + 1); //如果不存在 integerValue 为0
        while ([dic.allKeys count] > k) { //第一次到达满足条件是"eceb" 如果出现invalid 的状态就 移动left pointer，确保下面计算的max 肯定是合法的状态
            NSString *ch = [str substringWithRange:NSMakeRange(j, 1)];
            if([dic[ch] isEqualToNumber:@1]){
                [dic removeObjectForKey:ch];
            } else {
                dic[ch] = @(dic[ch].integerValue - 1);
            }
            j++;
        }
        max = MAX((i - j + 1), max);
    }
    return max;
}

// 举个例子 abcsba 如果k = 3 就没有 duplicate, MJ
// abcd k = 2
// BUG: 这里的顺序是先remove 后加, 如果先add 可能add 不进去

// 给一个array, 然后给一个k, 让你check 连续的k个integer是否含有dulplicate, 很简单的，用窗口为K的hashset一直扫一遍就行了，很简单
// 举个例子 abcsba 如果k = 3 就没有 duplicate

// scane the array from the left to right, use a set of bandwidth of k to track record element
// and we use two pointers to keep a sliding window, when i is reach at k, we need to check if the count of the set is small than k
// otherwise remove the element which is pointered by the rear index

- (BOOL)containsDuplicate:(NSArray *)nums windowSize:(NSInteger)k
{
    NSParameterAssert(k > 0);
    NSParameterAssert(nums);
    
    NSMutableSet *set = [NSMutableSet set];
    NSInteger j = 0;
    for (NSInteger i = 0; i < nums.count; i++) {
        if(i >= k){
            if([set count] < k){
                return YES;
            }
            [set removeObject:nums[j]];
            [set addObject:nums[i]];
            j++;
        } else {
            [set addObject:nums[i]];
        }
    }
    return NO;
}

//395. Longest Substring with At Least K Repeating Characters
// 1.scane from left to right, count the frequncey of each characters
// 2. divide and conquer
// take an example  aabbcjkkj  split the string with c
// 分治的思想，我没有想到

- (NSInteger)longestSubstring:(NSString *)str repeatingCount:(NSInteger)k
{
    NSParameterAssert(str);
    NSParameterAssert(k > 0);

    if(str.length < k){
        return 0;
    }
    return [self longestSubstring:str repeatingCount:k left:0 right:str.length];
}

- (NSInteger)longestSubstring:(NSString *)str repeatingCount:(NSInteger)k left:(NSInteger)left right:(NSInteger)right
{
    NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSInteger i = 0; i < str.length; i++){
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        dic[ch] = @(dic[ch].integerValue + 1); //如果不存在 integerValue 为0
    }
    
    for (NSString *key in dic.allKeys) {
        if(dic[key].integerValue < k){
            for(NSInteger i = 0; i < str.length; i++){
                NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
                if([key isEqualToString:ch]){
                    NSInteger l = [self longestSubstring:str repeatingCount:k left:left right:i];
                    NSInteger r = [self longestSubstring:str repeatingCount:k left:i + 1 right:right];
                    return MAX(l, r);
                }
            }
        }
    }
    return right - left;
}

// 注意: if the array is sorted , we can use two pointers, 如果是排好序的才可以用Two pointer 的方法来缩简区间，你想想3sum 是不是就是这么来弄的
// 可以说是3Sum 的简化版

- (BOOL)exitContigousSubarray:(NSArray *)array sum:(NSInteger)sum
{
    return YES;
}




@end
