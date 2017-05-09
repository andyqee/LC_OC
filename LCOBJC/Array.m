//
//  Array.m
//  LCOBJC
//
//  Created by ethon_qi on 25/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Array.h"
#import "TreeNode.h"

@interface NSValue (Compare)

- (NSComparisonResult)fbiCompare:(NSValue *)value;

@end

@implementation NSValue (Compare)

- (NSComparisonResult)fbiCompare:(NSValue *)value
{
    float d = self.pointValue.x * self.pointValue.x + self.pointValue.y * self.pointValue.y;
    float b = value.pointValue.x * value.pointValue.x + value.pointValue.y * value.pointValue.y;
    
    if(d == b){
        return NSOrderedSame;
    } else if(d > b){
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending; 
    }
}

@end

@implementation Array

#pragma mark - Array

///128
//methon1: 排序后再遍历，但是比较慢
//是否有重复的元素
//methos2: 技巧性很强, 遇到数组，如果O（n）的算法复杂度要求，思考下hashtable的作用
//Fellow up 如果数组很大，dic 放不下怎么办？

// 九章的版本
- (NSInteger)longestConsecutive:(NSArray<NSNumber *> *)nums
{
    NSInteger res = 0;
    NSMutableSet *set = [NSMutableSet setWithArray:nums];

    for(NSInteger i = 0; i < nums.count; i++){
        NSNumber *down = @(nums[i].integerValue - 1);
        while([set containsObject:down]){
            [set removeObject:down]; //避免重复
            down = @(down.integerValue - 1);
        }
        NSNumber *up = @(nums[i].integerValue + 1);
        while([set containsObject:up]){
            [set removeObject:up]; //避免重复
            up = @(up.integerValue + 1);
        }
        res = MAX(res, up.integerValue - down.integerValue - 1);
    }
    return res;
}

// method 1. 用product of all elements dived by each element
// method 2
// first scan form right to left calculate the product of all elements in the left side of a[i] excluding a[i]

// scan form left to right

// assum integer can hold

- (NSArray<NSNumber *> *)productExceptSelf:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *> *product = [NSMutableArray array];
    NSInteger preProduct = 1;
    for(NSInteger i = 0; i < [nums count]; i++) {
        [product addObject: @(preProduct)];
        preProduct *= nums[i].integerValue;
    }
    
    preProduct = 1;
    for(NSInteger i = [nums count] - 1; i >= 0; i--){
        product[i] = @(product[i].integerValue * preProduct);
        preProduct *= nums[i].integerValue;
    }
    return product;
}

#pragma mark - 3Sum

// MIT open class has video. 这里面用的双指针法，可以解决 “一道把排好序的数组每个element平方，输出还是排好序的”。 head tail 进行比较
// follow up : dont sort use HashMap

- (NSArray<NSArray *> *)threeSum_w3:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 3, @"invalid input");

    NSMutableArray *result = [NSMutableArray array];
    
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    for(NSInteger i = 0; i < nums.count - 2; i++) {
        if (i > 0 && [nums[i] compare:nums[i-1]] == NSOrderedSame) {
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
            map[@(idx)] = @(idx); //
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
        if (k > 0 && [nums[k] compare:nums[k-1]] == NSOrderedSame) {
            continue; //skipe duplicate
        }
        for(NSInteger i = k + 1; i < nums.count - 2; i++) { // 这里细心点 start form k + 1
            if (i > 0 && [nums[i] compare:nums[i-1]] == NSOrderedSame) {
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

// k the max number 题型。
// 有相同值的情况咋办
// 1. sort
// 2. heap
// 3  ...... 上面两种不满足 O(n) 的复杂度要求

- (NSInteger)thirdMax:(NSArray<NSNumber *> *)nums
{
    NSInteger max1 = NSIntegerMin;
    NSInteger max2 = NSIntegerMin;
    NSInteger max3 = NSIntegerMin;
    
    for(NSInteger idx = 0; idx < [nums count]; idx++) {
        NSInteger item = nums[idx].integerValue;
        if(item == max3 || item == max2 || item == max1) {
            continue;
        }
        if(item > max3) {
            max1 = max2;
            max2 = max3;
            max3 = item;
        } else if(item > max2) {
            max1 = max2;
            max2 = item;
        } else if(item > max1) {
            max1 = item;
        }
    }
    return max1 == NSIntegerMin ? max3 : max1;
}

#pragma mark - $$$ Binary Search $$$

//1,2,3,4,5,6,7

#pragma mark
#pragma mark - isBadVersion

- (BOOL)isBadVersion:(NSInteger)k
{
    return k >= 3; //fake implemetation
}

// 这道题目需要考虑一个情况，这里一定有bad version嘛
- (NSInteger)firstBadVersion:(NSInteger)n
{
    //找一个满足条件的
    NSInteger left = 1;
    NSInteger right = n;
    while (left < right) {
        NSInteger mid = (right - left) / 2 + left;
        if([self isBadVersion:mid]){
            right = mid; // is always bad version down right是bad,所以当他们一样大的时候，就是第一个bad version
        } else {
            left = mid + 1; //up 左边是好的
        }
    }
    return left;
}

#pragma mark - search In Rotated Array

// BS 过程中 idx 如何更新
// index 处理的需要注意 数组中是否有相等的元素。
// 在遇到 case [3, 1] targe = 1 的时候 错了. 是因为 在判断排好序的左边那一行 写成 > 正确的应该是 >=

- (NSInteger)searchInRotatedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSUInteger left = 0;
    NSUInteger right = [nums count] - 1;
    // eg1 67012345
    // eg2 34567012
    while(left <= right) {
        NSUInteger mid = (right - left) / 2 + left;
        //两种结构情况
        if(nums[mid].integerValue == target) {
            return mid;
        }
        // 排好序的在左边
        if(nums[mid].integerValue >= nums[left].integerValue) {
            if(target >= nums[left].integerValue && target < nums[mid].integerValue) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
            // 反之
        } else {
            if(target > nums[mid].integerValue && target <= nums[right].integerValue) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
    }
    return -1;
}

//- (NSInteger)searchInRotatedArray_w2:(NSArray<NSNumber *> *)nums target:(NSInteger)target
//{
//    NSInteger left = 0;
//    NSInteger right = [nums count] - 1;
//    while(left <= right) {
//        NSInteger mid = (right - left) / 2 + left;
//        if(nums[mid].integerValue > nums[left].integerValue) { //
//            if(target > nums[mid].integerValue || target <= nums[right].integerValue){
//                left = mid + 1;
//            } else if (target < nums[mid].integerValue){
//                right = mid - 1;
//            } else {
//                return mid;
//            }
//        } else {
//            if(target >= nums[left].integerValue || target < nums[mid].integerValue){
//                right = mid - 1;
//            } else if(target > nums[mid].integerValue) {
//                left = mid + 1;
//            } else {
//                return mid;
//            }
//        }
//    }
//    return -1;
//}

// https://discuss.leetcode.com/topic/310/when-there-are-duplicates-the-worst-case-is-o-n-could-we-do-better/2

// eg 111811111

- (BOOL)searchInRotatedArrayDuplicate:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSUInteger left = 0;
    NSUInteger right = [nums count] - 1;
    while(left <= right) {
        NSUInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue == target) {
            return YES;
        }
        if(nums[mid] > nums[left]) {
            if(target >= nums[left].integerValue && target < nums[mid].integerValue) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        } else if(nums[mid] < nums[left]) {
            if(target > nums[mid].integerValue && target <= nums[right].integerValue) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        } else { // 主要就是多了一行这个处理， Worst case O(n)
            left += 1;
        }
    }
    return NO;
}

// 递归
// int search(int A[], int n, int target) {
//         return searchRotatedSortedArray(A, 0, n-1, target);
//     }

//     int searchRotatedSortedArray(int A[], int start, int end, int target) {
//         if(start>end) return -1;
//         int mid = start + (end-start)/2;
//         if(A[mid]==target) return mid;

//         if(A[mid]<A[end]) { // right half sorted
//             if(target>A[mid] && target<=A[end])
//                 return searchRotatedSortedArray(A, mid+1, end, target);
//             else
//                 return searchRotatedSortedArray(A, start, mid-1, target);
//         }
//         else {  // left half sorted
//             if(target>=A[start] && target<A[mid])
//                 return searchRotatedSortedArray(A, start, mid-1, target);
//             else
//                 return searchRotatedSortedArray(A, mid+1, end, target);
//         }
//     }

// 153. Find Minimum in Rotated Sorted Array

//prove the correctness of alogrithm
// leftmost element is always larger than right most
// campare the mid of the element with left most
//

// corner case: 是否元素唯一
// [1, 2] , [2, 1]
// *****

// 和Search in Rotated Sorted Array I这题换汤不换药。同样可以根据A[mid]和A[end]来判断右半数组是否sorted：
// 原数组：0 1 2 4 5 6 7
// 情况1：  6 7 0 1 2 4 5
// 情况2：  2 4 5 6 7 0 1
// (1) A[mid] < A[end]：A[mid : end] sorted => min不在A[mid+1 : end]中
// 搜索A[start : mid]
// (2) A[mid] > A[end]：A[start : mid] sorted且又因为该情况下A[end]<A[start] => min不在A[start : mid]中
// 搜索A[mid+1 : end]
// (3) base case：
// a. start =  end，必然A[start]为min，为搜寻结束条件。
// b. start + 1 = end，此时A[mid] =  A[start]，而min = min(A[mid], A[end])。而这个条件可以合并到(1)和(2)中。

#pragma mark - Find Minimum in Rotated Sorted Array

- (NSNumber *)findMin:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");
    
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue < nums[right].integerValue) {
            right = mid;
        } else if(nums[mid].integerValue > nums[right].integerValue) {
            left = mid + 1;
        }
    }
    return nums[left];
}

// mid with left ，需要特殊处理没有排序的情况
// 有重复元素的情况

- (NSNumber *)findMin2:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");
    
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue < nums[right].integerValue) {
            right = mid;
        } else if(nums[mid].integerValue > nums[right].integerValue) {
            left = mid + 1;
        } else {
            right--; // 这里不能写成left++
        }
    }
    return nums[left];
}

#pragma mark - Median of Two Sorted Arrays

// 如果数组很大怎么办
// assum array not emtpy
// 難題目
// https://discuss.leetcode.com/topic/16797/very-concise-o-log-min-m-n-iterative-solution-with-detailed-explanation
// - (double)findMedianInSortedArrays:(NSArray<NSNumber *> *)arr1 anotherArray:(NSArray<NSNumber *> *)arr2
// {   //two special case
//      //step 1 odd
//      NSInteger m = [arr1 count];
//      NSInteger n = [arr2 count];
//      NSInteger mid = (m + n) / 2;
    
//      if ((m + n) % 2 ==  1) {
//          return [self _kth:mid + 1 inArray:arr1 m:0 withArray:arr2 n:0];
//      }
//     double a = [self _kth:mid inArray:arr1 m:0 withArray:arr2 n:0];
//     double b = [self _kth:mid+1 inArray:arr1 m:0 withArray:arr2 n:0];
//     return (a + b) * 0.5;
// }
// 将数组分成4段

// - (double)_kth:(NSInteger)k inArray:(NSArray<NSNumber *> *)arr1 m:(NSInteger)m withArray:(NSArray<NSNumber *> *)arr2 n:(NSInteger)n
// {
//     if(m > n){
//         return [self _kth:k inArray:arr1 m:m withArray:arr2 n:n];
//     }
//     if(m == 0){
//         return (double)arr2[k - 1].integerValue;
//     }
//     if (k == 1) {
//         return (double) MIN([arr1 firstObject].integerValue, [arr2 firstObject].integerValue);
//     }
//     NSInteger p = MIN(k/2, m);
//     NSInteger q = k - p;
    
//     if (arr1[p-1].integerValue < arr2[q -1].integerValue) {
//         return [self _kth:k-p inArray:arr1 m: withArray:arr2 n:];
//     }
// }

// Solution A: scane it , build an dictionary
// which nums is larger , does it has some impact the alogrithm we choose ?
// 数组里面是整数吗？／／ 这个要确定
// Two hash table 我对于这到题目的理解，和网上的不太一样，区别在于数组的中元素的重复个数是不是一定要相同
// 区别在于[1,2,2,2,3] [2,2,3]

// What if the given array is already sorted? How would you optimize your algorithm?
// A: 先搜索，在开始scan 的数组, 利用two pointers

// Q: What if nums1's size is small compared to nums2's size? Which algorithm is better?

// A: If two arrays are sorted, we could use binary search, i.e.,
// for each element in the shorter array, search in the longer one.
// So the overall time complexity is O(nlogm), where n is the length of the shorter array, and m is the length of the longer array.
// Note that this is better than Solution 1 since the time complexity is O(n + m) in the worst case.

// Q: What if elements of nums2 are stored on disk, and the memory is limited such that you cannot load all elements into the memory at once?
// A: If only nums2 cannot fit in memory, put all elements of nums1 into a HashMap,
// read chunks of array that fit into the memory, and record the intersections.
// If both nums1 and nums2 are so huge that neither fit into the memory, sort them individually (external sort),
//  then read 2 elements from each array at a time in memory, record intersections

- (NSArray<NSNumber *> *)intersectionOfTwoArray:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    //这里可以对小的进行scane 让后放到内存中，这样空间复杂度小一些。

    NSMutableDictionary<NSNumber *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSNumber *num in array) {
        if(dic[num]) {
            dic[num] = @(dic[num].integerValue + 1);
        } else {
            dic[num] = @(1);
        }
    }
    
    NSMutableDictionary<NSNumber *, NSNumber *> *copyDic = [dic mutableCopy];
    for(NSNumber *num in array2) {
        if(copyDic[num]) {
            copyDic[num] = @(copyDic[num].integerValue - 1);
        }
        //skip the not found num©
    }
    // filter the result
    NSMutableArray *result = [NSMutableArray array];
    for(NSNumber *key in copyDic.allKeys) {
        if(copyDic[key].integerValue == 0) {
            NSInteger count = dic[key].integerValue;
            while(count > 0) {
                [result addObject:dic[key]];
                count--;
            }
        }
    }
    return [result copy]; // we should return an imutable object
}

// unique 的话, we can use an set
// 或者添加 3 sum 那种常见的去重复方法，

- (NSArray<NSNumber *> *)intersectionOfTwoArray_TwoPointer:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    NSArray<NSNumber *> *sArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSArray<NSNumber *> *sArray2 = [array sortedArrayUsingSelector:@selector(compare:)];

    if([sArray lastObject] < [sArray2 firstObject] || [sArray firstObject] > [sArray2 lastObject]) {
        return @[];
    }
    
    NSInteger i = 0; // scan array
    NSInteger j = 0;
    NSMutableArray *result = [NSMutableArray array];
    while(i < [sArray count] && j < [sArray2 count]) {  // 这里的问题是如果数组很长，但是另外一个数组很小，可以通过二分查找先快速定位
        if(sArray[i].integerValue == sArray2[j].integerValue) {
            [result addObject: array[i]];
            i++;
            j++;
        } else if(sArray[i].integerValue < sArray2[j].integerValue) {
            i++;
        } else {
            j++;
        }
    }
    return result;
}

// 这种解法 因为用到的set 的高级的api，那么得和面试官确认下这样是否 允许

- (NSArray<NSNumber *> *)intersectionOfTwoArrayUnique:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    NSMutableSet *set = [NSMutableSet setWithArray:array];
    NSSet *set2 = [NSSet setWithArray:array2];
    [set intersectSet:set2];
    return [set allObjects];
}

#pragma mark - sorted colors
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

// 顺序是：

- (void)sortedColors:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1) {
        return;
    }
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    NSInteger cur = 0;
    while(cur <= right) {
        if(nums[cur].integerValue == 0) {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:left];
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

#pragma mark -

// 1. sort return [n-k]
// 2. priority queue . oc 没有原生的
// 3. quick select
// https://discuss.leetcode.com/topic/15256/4-c-solutions-using-partition-max-heap-priority_queue-and-multiset-respectively/2
// https://discuss.leetcode.com/topic/14597/solution-explained/2

- (NSNumber *)findKthLargest:(NSInteger)k inArray:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    NSInteger p = 0;
    NSMutableArray *mutableNums = [NSMutableArray arrayWithArray:nums];
    while(left < right) {
        p = [self partition:mutableNums left:left right:right];
        if(p == k - 1) {
            break;
        } else if( p < k - 1) {
            left = p + 1;
        } else {
            right = p - 1;
        }
    }
    return mutableNums[p];
}
//这里是把大的放在左边
- (NSInteger)partition:(NSMutableArray<NSNumber *> *)nums left:(NSInteger)left right:(NSInteger)right
{
    NSInteger pivot = nums[left].integerValue;
    NSInteger i = left + 1; // 
    NSInteger j = right;
    while(i <= j) { //把大的放置在左边
        if(nums[j].integerValue > pivot && nums[i].integerValue < pivot) { // 右边比pivot 大 以及 left 比pivot小
            [nums exchangeObjectAtIndex:i withObjectAtIndex:j]; // 交换
            i++;
            j--;
        }
        if(nums[j].integerValue <= pivot){
            j--;
        }
        if(nums[i].integerValue >= pivot){
            i++;
        }
    }   //最后j会退到比pivot大的元素上。所以需要exchage一下
    [nums exchangeObjectAtIndex:left withObjectAtIndex:j];
    return j;
}

// put small in left
#pragma mark - closest point

- (NSInteger)partition2DPoints:(NSMutableArray<NSValue *> *)nums left:(NSInteger)left right:(NSInteger)right
{
    NSValue *pivot = nums[left];

    NSInteger i = left + 1;
    NSInteger j = right;

    while(i <= j) {
        // put small in
        if ([nums[i] fbiCompare:pivot] == NSOrderedDescending && [nums[j] fbiCompare:pivot] == NSOrderedAscending) {
            [nums exchangeObjectAtIndex:i withObjectAtIndex:j];
            i++;
            j--;
        }
        if([nums[i] fbiCompare:pivot] == NSOrderedAscending){
            i++;
        }
        if([nums[j] fbiCompare:pivot] == NSOrderedDescending){
            j--;
        }
    }   //最后j会退到比pivot大的元素上。所以需要exchage一下
    [nums exchangeObjectAtIndex:left withObjectAtIndex:j];
    return j;
}

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

//index 的转移规律
// step1; 找到index转移关系
// step2: travesal 可以想象成 n/2 环，旋转这 n/2个环形.
// 举例子 4 * 4  3 * 3 这里需要注意的是 4 需要处理两环 那么 i < n/2 没有等于

// O(n * n) each element in the matrix will be write only once
// 另外一种解法 https://discuss.leetcode.com/topic/6796/a-common-method-to-rotate-the-image
// 这是一道非常容易出错的题目，各种index, 判断条件很多，要写对不容易啊

- (void)rotate:(NSMutableArray<NSMutableArray *> *)matrix
{
    if(!matrix || matrix.count <= 1 || matrix.firstObject.count <= 1){
        return ;
    }
    NSInteger n = matrix.count;

    for(NSInteger i = 0; i < n/2; i++) { // represent each cycle 
        for(NSInteger j = i; j < n - i - 1; j++) { // 这里是主意每一行的最后一个不需要处理，因为是下一列的开头，是有重叠的，所以这里的区间是
            // 0 ~ len - 2
            // 四次替换
            NSNumber *temp = matrix[i][j];
            matrix[i][j] = matrix[n-j-1][i]; //最后一个赋给第一个  4 --> 1
            matrix[n-j-1][i] = matrix[n-i][j]; // 3 --> 4
            matrix[n-i-1][j] = matrix[j][n-i-1]; // 2-->3
            matrix[j][n-i-1] = temp;  // 1 --> 2
            // nums[i][j]; //  状态转移
            // nums[j][n-i];
            // nums[n-i][j];
            // nums[n-j][i];
        }
    }
}

// 注意over flow
// 没想到 one pass 的方法
// DP 分别state两种状态。这个技巧很重要

- (NSInteger)maxProduct:(NSArray<NSNumber *> *)nums
{
    NSInteger count = [nums count];
    
    NSMutableArray<NSNumber *> *maxProduct = [NSMutableArray array];
    NSMutableArray<NSNumber *> *minProduct = [NSMutableArray array]; // [j] indicate the largest and samllest value end up with nums[j-1]
    [maxProduct addObject:nums[0]];
    [minProduct addObject:nums[0]];
    
    NSInteger maxRes = nums[0].integerValue;
    for(NSInteger j = 1; j < count; j++) {
        NSInteger curr = nums[j].integerValue;
        
        if(nums[j].integerValue >= 0) {
            [maxProduct addObject:@(MAX(curr, curr * maxProduct[j-1].integerValue))];
            [minProduct addObject:@(MIN(curr, curr * minProduct[j-1].integerValue))];
        } else {
            [maxProduct addObject:@(MAX(curr, curr * minProduct[j-1].integerValue))];
            [minProduct addObject:@(MIN(curr, curr * maxProduct[j-1].integerValue))];
        }
        maxRes = MAX(maxRes, maxProduct[j].integerValue);
    }
    return maxRes;
}

- (NSInteger)maxProduct_OptimizeSpace:(NSArray<NSNumber *> *)nums
{
    NSInteger count = [nums count];
    NSInteger currMax = [nums firstObject].integerValue;
    NSInteger currMin = currMax;
    
    NSInteger maxRes = nums[0].integerValue;
    for(NSInteger j = 1; j < count; j++) {
        NSInteger curr = nums[j].integerValue;
        NSInteger prevMax = currMax;
        currMax = MAX(MAX(prevMax * curr, currMin * curr), curr);
        currMin = MIN(MIN(currMin * curr, prevMax * curr), curr);
        maxRes = MAX(maxRes, currMax);
    }
    return maxRes;
}

#pragma mark - Interval

- (NSArray<Interval *> *)mergeIntervals:(NSArray<Interval *> *)intervals
{
    //sort interval O(nlog(n))
    if([intervals count] < 2) {
        return intervals;
    }
    //step 1: sort the interval
    NSArray *sortedIntervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(Interval *first, Interval *second ) {
        if(first.start < second.start) {
            return NSOrderedAscending;
        } else if(first.start == second.start) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    // step 2 : compare cur.start inter with next 
    // if > merge  else insert to array
    NSMutableArray *result;
    Interval *cur = sortedIntervals[0];
    Interval *next;
    for(NSInteger idx = 1; idx < [sortedIntervals count]; idx ++){
        next = sortedIntervals[idx];
        if(cur.end >= next.start) {
            cur.end = MAX(cur.end, next.end); //注意这里需要和第二个的end进行比较 //
        } else {
            [result addObject:cur];
            cur = next;
        }
    }
    [result addObject:cur]; //添加last value
    return result;
}

//
- (NSArray<Interval *> *)insert:(NSArray<Interval *> *)intervals withInterval:(Interval *)interval2
{
    NSMutableArray *result = [NSMutableArray array];

    NSInteger k = 0;
    NSInteger count = intervals.count;
    //step 1: insert the left side part which is not overlap with interval2
    while(k < count && intervals[k].end < interval2.start){
        [result addObject: intervals[k]];
        k++;
    }
    Interval *newInterval = interval2; // 如果没有overlap 也要加进去
    while(k < count && intervals[k].start <= newInterval.end){ // step2 : merge the overlap interval
        newInterval = [Interval new];
        newInterval.start = MIN(intervals[k].start, newInterval.start); //start 挑选小的合并
        newInterval.end = MAX(intervals[k].end, newInterval.end); //start 挑选小的合并
        k++;
    }
    [result addObject:newInterval]; // step3 : insert right part 
    while(k < count){
        [result addObject:intervals[k]];
        k++;
    }
    return result;
}

- (BOOL)canAttendMeetings:(NSArray<Interval *> *)intervals
{
    //sort the intervals 这里需要确认的是 如果后面interva 的end == 前面start 的时间，算不算重叠
    if([intervals count] <= 1){
        return YES;
    }
    
    NSArray<Interval *> *sortedIntervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(Interval *first, Interval *second ) {
        if(first.start < second.start) {
            return NSOrderedAscending;
        } else if(first.start == second.start) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    for(NSInteger idx = 1; idx < [sortedIntervals count]; idx++){
        if(sortedIntervals[idx].start < sortedIntervals[idx - 1].end){
            return NO;
        }
    }
    return YES;
}

// Very similar with what we do in real life. Whenever you want to start a meeting,
// you go and check if any empty room available (available > 0) and
// if so take one of them ( available -=1 ). Otherwise,
// you need to find a new room someplace else ( numRooms += 1 ).
// After you finish the meeting, the room becomes available again ( available += 1 ).

// [[0, 30],[5, 10],[15, 20]]

//  start : 0, 5, 15
//  end :   10, 20 , 30

// i   j  numOfRoom freeRoom
// 0   0      1       0         0 < 10
// 1   0      2       0         5 < 10
// 2   0      2       1         15 > 10

// 3   1      2       0         15 < 20  // quit loop

// https://discuss.leetcode.com/topic/20971/c-o-n-log-n-584-ms-3-solutions

//Fellow up: 给出重合最多的时间点，或者说有最多meeting的时间点

- (NSInteger)minMeetingRooms:(NSArray<Interval *> *)intervals
{
    NSMutableArray<NSNumber *> *starts = [NSMutableArray array];
    NSMutableArray<NSNumber *> *ends = [NSMutableArray array];
    for(Interval *it in intervals){
        [starts addObject:@(it.start)];
        [ends addObject:@(it.end)];
    }
    //step 1.分别排序
    [starts sortUsingSelector:@selector(compare:)]; // nlog(n)
    [ends sortUsingSelector:@selector(compare:)];
    
    NSInteger numOfRooms = 0;
    NSInteger numOfFreeRooms = 0;
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger len = [intervals count];
    
    while (i < len) { //
        if(starts[i].integerValue < ends[j].integerValue) { //任意开始时间 小于结束时间，需要会议室
            if(numOfFreeRooms > 0){  // 有空余的
                numOfFreeRooms--;
            } else {
                numOfRooms++;
            }
            i++;  //找出所有必当前end 小的 start，统计出所有的会议室
        } else {
            numOfFreeRooms++; //当结束时间小于此时的开始时间，说明会议结束了。空闲的就加1
            j++; //继续递增J
        }
    }
    return numOfRooms;
}
// 使用最小堆的办法

//public int minMeetingRooms(Interval[] intervals) {
//    if (intervals == null || intervals.length == 0)
//        return 0;
//    
//    // Sort the intervals by start time
//    Arrays.sort(intervals, new Comparator<Interval>() {
//        public int compare(Interval a, Interval b) { return a.start - b.start; }
//    });
//    
//    // Use a min heap to track the minimum end time of merged intervals
//    PriorityQueue<Interval> heap = new PriorityQueue<Interval>(intervals.length, new Comparator<Interval>() {
//        public int compare(Interval a, Interval b) { return a.end - b.end; }
//    });
//    
//    // start with the first meeting, put it to a meeting room
//    heap.offer(intervals[0]);
//    
//    for (int i = 1; i < intervals.length; i++) {
//        // get the meeting room that finishes earliest
//        Interval interval = heap.poll();
//        
//        if (intervals[i].start >= interval.end) {
//            // if the current meeting starts right after
//            // there's no need for a new room, merge the interval
//            interval.end = intervals[i].end;
//        } else {
//            // otherwise, this meeting needs a new room
//            heap.offer(intervals[i]);
//        }
//        
//        // don't forget to put the meeting room back
//        heap.offer(interval);
//    }
//    
//    return heap.size();
//}

//- (NSArray *)mergeKSortedArray:(NSArray *)array
//{
//    
//}

// All elements before the slow pointer (lastNonZeroFoundAt) are non-zeroes.
// All elements between the current and slow pointer are zeroes

//    1 , 0, 3,
//    n 
//   cur

//       n
//      curr
//       3 0
//         curr
//        n 
// 另一种情况 0 , 1 
//

- (void)moveZeros:(NSMutableArray<NSNumber *> *)nums
{    
    if([nums count] <= 1){
        return;
    }
    NSInteger curr = 0;
    NSInteger nonZeroIndex = 0;
    while(curr < nums.count){
        if(nums[curr].integerValue != 0){
            [nums exchangeObjectAtIndex:curr withObjectAtIndex:nonZeroIndex];
            nonZeroIndex++;
        } 
        curr++;
    }
}

- (void)moveZeros_no_order:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1){
        return;
    }
    NSInteger left = 0;
    NSInteger right = nums.count - 1;
    while(left < right){
        while(left < right && nums[right].integerValue == 0){
            right--;
        }// use right to track the right most no zero element
        while(left < right && nums[left].integerValue != 0){
            left++;
        }
        if(left < right){
            [nums exchangeObjectAtIndex:left withObjectAtIndex:right];
        }
    }
}

#pragma mark - cool down

- (NSArray *)cooldown:(NSInteger)cooldown withTask:(NSArray *)tasks
{
    NSMutableArray *result = [NSMutableArray array];
    NSInteger j = 0;
    
    NSMutableDictionary<NSNumber *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    
    for(NSInteger i = 0; i < tasks.count; i++) {
        while(dic[tasks[i]] && dic[tasks[i]].integerValue + cooldown >= j){
            [result addObject:@"_"];
            j++;
        }
        [result addObject:tasks[i]];
        dic[tasks[i]] = @(j);
        j++;
    }
    return [result copy];
}

//191. Number of 1 Bits

// 这里还有个更佳简介的 直接和 & 1 相yu

- (NSInteger)hammingWeight:(NSInteger)n
{
    NSInteger count = 0;
    NSInteger b = 0;
    while (n != 0) {
        b = n >> 1;
        if(n != b << 1){
            count++;
        }
        n = b;
    }
    return count;
}

- (double)power:(NSInteger)n k:(NSInteger)k
{
    if(n < 0){
        return 1.0 / [self _power:-n k:k];
    } else {
        return [self power:n k:k];
    }
}

- (double)_power:(NSInteger)n k:(NSInteger)k
{
    if(n == 0){
        return 1;
    }
    double v = [self _power:n / 2 k:k];
    if(n % 2 == 0){
        return v * v;
    } else {
        return v * v * k;
    }
}

- (NSInteger)vector:(NSArray<NSNumber *> *)vector dotVector:(NSArray<NSNumber *> *)vector2
{
    NSAssert([vector count] == [vector2 count], @"");
    NSInteger result = 0;
    for(NSInteger i = 0; i < vector.count; i++){
        result += vector[i].integerValue * vector2[i].integerValue;
    }
    return result;
}

//Fellow up
//   input A=[[1, a1], [300, a300], [5000, a5000]]
//         B=[[100, b100], [300, b300], [1000, b1000]]

- (NSInteger)sparseVector:(NSArray<NSArray<NSNumber *> *> *)vector dotVector:(NSArray<NSArray<NSNumber *> *> *)vector2
{
    //假设vector <<< vector2
    NSInteger result = 0;
    for(NSInteger i = 0; i < vector.count; i++){
        NSUInteger index = [vector2 indexOfObject:vector[i]
                                    inSortedRange:NSMakeRange(0, vector2.count - 1)
                                          options:NSBinarySearchingFirstEqual
                                  usingComparator:^NSComparisonResult(NSArray *a, NSArray *b){
                                           return [[a firstObject] compare:[b firstObject]]; 
                                       }];
        
        if(index < vector2.count){
            result += [vector[i] lastObject].integerValue * [vector2[index] lastObject].integerValue;
        }                               
    }
    return result;
}

//public String frequencySort(String s) {
//    Map<Character, Integer> map = new HashMap<>();
//    for (char c : s.toCharArray()) {
//        if (map.containsKey(c)) {
//            map.put(c, map.get(c) + 1);
//        } else {
//            map.put(c, 1);
//        }
//    }
//    List<Character> [] bucket = new List[s.length() + 1];
//    for (char key : map.keySet()) {
//        int frequency = map.get(key);
//        if (bucket[frequency] == null) {
//            bucket[frequency] = new ArrayList<>();
//        }
//        bucket[frequency].add(key);
//    }
//    StringBuilder sb = new StringBuilder();
//    for (int pos = bucket.length - 1; pos >=0; pos--) {
//        if (bucket[pos] != null) {
//            for (char num : bucket[pos]) {
//                for (int i = 0; i < map.get(num); i++) {
//                    sb.append(num);
//                }
//            }
//        }
//    }
//    return sb.toString();
//}

// 堆的办法

//public String frequencySort(String s) {
//    Map<Character, Integer> map = new HashMap<>();
//    for (char c : s.toCharArray()) {
//        if (map.containsKey(c)) {
//            map.put(c, map.get(c) + 1);
//        } else {
//            map.put(c, 1);
//        }
//    }
//    PriorityQueue<Map.Entry<Character, Integer>> pq = new PriorityQueue<>(
//                                                                          new Comparator<Map.Entry<Character, Integer>>() {
//                                                                              @Override
//                                                                              public int compare(Map.Entry<Character, Integer> a, Map.Entry<Character, Integer> b) {
//                                                                                  return b.getValue() - a.getValue();
//                                                                              }
//                                                                          }
//                                                                          );
//    pq.addAll(map.entrySet());
//    StringBuilder sb = new StringBuilder();
//    while (!pq.isEmpty()) {
//        Map.Entry e = pq.poll();
//        for (int i = 0; i < (int)e.getValue(); i++) {
//            sb.append(e.getKey());
//        }
//    }
//    return sb.toString();
//}

// 首先想到的办法是 二分法
// worst : O(N)。 网上的解法是 对upbounds 再掉用一次 二分搜索，
// 这里可以试情况而定，如果重复的比率很高那么使用第二次二分查找。
// 但是如果只是频率低，就用我这里给的解法

- (NSArray<NSNumber *> *)searchRange:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSMutableArray *range = [NSMutableArray arrayWithArray:@[@(-1), @(-1)]];
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;

    while(left <= right){
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue == target){
            NSInteger start = mid;
            NSInteger end = mid;
            while(start >= 0 && nums[start].integerValue == target){
                start--;
            }
            while(end <= [nums count] - 1 && nums[end].integerValue == target){
                end++;
            }
            range[0] = @(start + 1);
            range[1] = @(end - 1);
            break;
        } else if(nums[mid].integerValue > target){
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return range;
}

//method 2
//step 1: 找到第一个等于target
//step 2: 找到 >= target + 1

- (NSArray<NSNumber *> *)searchRangeMethod2:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSMutableArray *range = [NSMutableArray arrayWithArray:@[@(-1), @(-1)]];
    NSInteger right = [nums count] - 1;
    
    NSInteger left = [self _searchRange:nums target:target left:0 right:nums.count];// 这里传的不是 nums.count - 1
    if(left == nums.count || nums[left].integerValue != target){ // 没有找到
        return range;
    }
    range[0] = @(left);
    
    right = [self _searchRange:nums target:target + 1 left:left + 1 right:nums.count];
    range[1] = right == -1 ? @(left) : @(right - 1);
    
    return range;
}

- (NSInteger)_searchRange:(NSArray<NSNumber *> *)nums target:(NSInteger)target left:(NSInteger)left right:(NSInteger)right;
{
    NSInteger l = left;
    NSInteger r = right;
    
    while(l < r){
        NSInteger mid = (r - l) / 2 + l;
        if(nums[mid].integerValue < target){
            l = mid + 1;
        } else {
            r = mid;
        }
    }
    return l;
}

// 35. Search Insert Position
// *** 这个题目和搜索返回的那个道题目一个意思. 这里用到了同一个技巧！！！！

- (NSInteger)searchInsert:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSInteger left = 0;
    NSInteger right = nums.count;
    
    while (left < right) {
        NSInteger mid = (right - left) / 2 + left;
        
        if(nums[mid].integerValue < target){
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}

// 很难想
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

//方法二 Two pointers
// https://discuss.leetcode.com/topic/3016/share-my-short-solution
// 这种方法不太好想，需要对照着图，大脑演示一遍.
// Search from left to right and maintain a max height of left and right separately, which is like a one-side wall of partial container. Fix the higher one and flow water from the lower part. For example, if current height of left is lower, we fill water in the left bin. Until left meets right, we filled the whole container.

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

// 54. Spiral Matrix
// 四个方向的遍历，还有一个关键是去除重复，因为头有重叠,以及什么终止
// 还有一个需要注意的是两种corner case 就是 1 * n 和 n * 1 数组，需要在第3个和第四个循环中 添加检测
// [1,2] 和
// [[1],
// [2]]

- (NSArray<NSNumber *> *)spiralOrder:(NSArray<NSArray<NSNumber *> *> *)nums
{
    NSMutableArray *result = [NSMutableArray array];
    NSInteger m = nums.count;
    NSInteger n = nums.firstObject.count;
    if(m == 0 || n == 0){
        return result;
    }
    //traversal from left to right
    NSInteger left = 0;
    NSInteger right = m - 1;
    NSInteger bottom = n - 1;
    NSInteger top = 0;
    
    while(left <= right && top >= bottom){
        for(NSInteger i = left; i <= right; i++){
            [result addObject:nums[top][i]];
        }
        top++;
        
        for(NSInteger i = top; i <= bottom; i++){
            [result addObject:nums[i][right]];
        }
        right--;
        
        if(top <= bottom){  // 过滤只剩下一行
            for(NSInteger i = right; i >= left; i--){ //这里是 >=
                [result addObject:nums[bottom][i]];
            }
            bottom--;
        }
        if(left <= right){
            for(NSInteger i = bottom; i >= top; i--){
                [result addObject:nums[i][left]];
            }
            left++;
        }
    }
    
    return result;
}

//class Solution {
//public:
//    vector<int> spiralOrder(vector<vector<int>>& matrix) {
//        if (matrix.empty()) return {};
//        int m = matrix.size(), n = matrix[0].size();
//        vector<int> spiral(m * n);
//        int u = 0, d = m - 1, l = 0, r = n - 1, k = 0;
//        while (true) {
//            // up
//            for (int col = l; col <= r; col++) spiral[k++] = matrix[u][col];
//            if (++u > d) break;
//            // right
//            for (int row = u; row <= d; row++) spiral[k++] = matrix[row][r];
//            if (--r < l) break;
//            // down
//            for (int col = r; col >= l; col--) spiral[k++] = matrix[d][col];
//            if (--d < u) break;
//            // left
//            for (int row = d; row >= u; row--) spiral[k++] = matrix[row][l];
//            if (++l > r) break;
//        }
//        return spiral;
//    }
//};

// 也可以使用排序的办法
- (BOOL)containsDuplicate:(NSArray<NSNumber *> *)nums
{
    if(nums.count == 0){
        return YES;
    }

    NSSet *set = [NSSet setWithArray:nums];
    return set.count != nums.count;
}

//使用dic保存index

// - (BOOL)containsDuplicate2:(NSArray<NSNumber *> *)nums
// {

// }

// 很多种方法
// brute force

- (BOOL)know:(NSObject *)a with:(NSObject *)b
{
    return YES;
}

// 这个brute force 是不对的,没有记录 outdgree, outdegree should be zero

- (NSInteger)findCelebrityBruteForce:(NSArray *)nums
{
    NSAssert([nums count] > 1, @"");
    
    for(NSInteger idx = 0; idx < nums.count; idx++){
        NSInteger result = 0;
        for(NSInteger j = 0; j < nums.count; j++){
            if(j == idx){
                continue;
            }
            if([self know:nums[idx] with:nums[j]]){
                result++;
            }
        }
        if(result == nums.count -1){
            return idx;
        }
    }
    return -1;
}

//public int findCelebrity(int n) {
//    if (n <= 1) {
//        return -1;
//    }
//    
//    int[] inDegree = new int[n];
//    int[] outDegree = new int[n];
//    
//    for (int i = 0; i < n; i++) {
//        for (int j = 0; j < n; j++) {
//            if (i != j && knows(i, j)) {
//                outDegree[i]++;
//                inDegree[j]++;
//            }
//        }
//    }
//    
//    for (int i = 0; i < n; i++) {
//        if (inDegree[i] == n - 1 && outDegree[i] == 0) {
//            return i;
//        }
//    }
//    
//    return -1;
//}

//Two pointers
//
//   1---->2    3--->4
//        /^       /^
//       /        /
//      3        5
// 这道题 主要有两部分构成 、
// 1. loop through the array 找出candidate
// 2. 验证 candidate ,注意两个条件
// http://www.geeksforgeeks.org/the-celebrity-problem/

- (NSInteger)findCelebrity1:(NSArray *)nums
{
    NSAssert([nums count] > 1, @"");
    // other --> celebrity, celebrity has no directed path to b
    
    NSNumber *candidate = [nums firstObject];
    for(NSInteger idx = 1; idx < nums.count; idx++){
        if(![self know:nums[idx] with:candidate]) {
            candidate = nums[idx];  //如果a not knows b, b 肯定不是, a可能是。 如果a knows b, skip a, beacuse a is not celebrity
        }
    } //note 但是仅仅这样检查完是不行的，可能出现的情况是 上图，也就是这个图不是联通的，2 与 3 相互不认识，此时会更新成 3，但是3 不是整个graph的celebirty
    
    NSInteger count = 0;
    for (NSInteger i = 0; i < nums.count; i++) {
        if(candidate == nums[i]){
            continue;
        } //充分条件
        if([self know:nums[i] with:candidate] && ![self know:candidate with:nums[i]]){ //所有的都是指向candidate，不能通过验证它不指向其他所有
            count++;
        }
    }
    return count == nums.count - 1 ? candidate.integerValue : -1;
    //获取到candidate
}

- (NSInteger)findCelebrityCorrect:(NSArray *)nums
{
    NSAssert([nums count] > 1, @"");
    
    // other --> celebrity, celebrity has no directed path to b
    NSNumber *candidate = [nums firstObject];
    for(NSInteger idx = 1; idx < nums.count; idx++){
        if(![self know:nums[idx] with:candidate]) {
            candidate = nums[idx];  //如果a not knows b, b 肯定不是, a可能是。 如果a knows b, skip a, beacuse a is not celebrity
        }
    } //note 但是仅仅这样检查完是不行的，可能出现的情况是上图，也就是这个图不是联通的，2与3 相互不认识，此时会更新成 3，但是3 不是整个graph的celebirty
    
    for (NSInteger i = 0; i < nums.count; i++) {
        if(candidate == nums[i]){
            continue;
        }
        if(![self know:nums[i] with:candidate] || [self know:candidate with:nums[i]]){
            return -1;
        }
    }
    return candidate.integerValue;
}

#pragma mark - wiggle sort

// 280 wiggle sort
// 元素不能重复

- (void)wiggleSort:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1){
        return;
    }
    for (NSInteger idx = 0; idx < nums.count - 1; idx++) { // 倒数第二个停止
        if(idx % 2 == 0){
            if(nums[idx].integerValue < nums[idx+1].integerValue){
                [nums exchangeObjectAtIndex:idx withObjectAtIndex:idx + 1];
            }
        } else {
            if(nums[idx].integerValue > nums[idx+1].integerValue){
                [nums exchangeObjectAtIndex:idx withObjectAtIndex:idx + 1];
            }
        }
    }
}

// 如果有重复元素咋办？
// Can you do it in O(n) time and/or in-place with O(1) extra space?

// HARD
#pragma mark - Fellow up
//https://discuss.leetcode.com/topic/32929/o-n-o-1-after-median-virtual-indexing
//https://discuss.leetcode.com/topic/41464/step-by-step-explanation-of-index-mapping-in-java

//- (void)wiggleSortII:(NSMutableArray<NSNumber *> *)nums
//{
//
//}

- (BOOL)searchMatrix:(NSMutableArray< NSMutableArray<NSNumber *> *> *)nums target:(NSInteger)target;
{
    NSInteger left = 0;
    NSInteger right = nums.count * nums.firstObject.count - 1;

    while(left <= right){
        NSInteger mid = (right - left) / 2 + left;
        NSInteger i = mid / nums.firstObject.count; // 这里不能除 nums.count
        NSInteger j = mid % nums.firstObject.count;

        if(nums[i][j].integerValue == target){
            return YES;
        } else if(nums[i][j].integerValue < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return NO;
}

// 没有顺序 no order

// sum 
- (NSInteger)missingNumber:(NSArray<NSNumber *> *)nums
{
    NSInteger sum = nums.count;
    for(NSInteger i = 0; i < nums.count; i++){
        sum += i - nums[i].integerValue;
    }
    return sum;
}

// XOR 技巧 a^b^b = a 

- (NSInteger)missingNumber_xor:(NSArray<NSNumber *> *)nums
{
    NSInteger sum = nums.count;
    for(NSInteger i = 0; i < nums.count; i++){
        sum = sum^i;
        sum = sum^nums[i].integerValue;
    }
    return sum; 
}

// 二分法
- (NSInteger)missingNumber_bs:(NSArray<NSNumber *> *)nums
{
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    NSInteger left = 0;
    NSInteger right = nums.count; //结果有可能是 nums.length

    while(left < right){    
        NSInteger mid = (right - left) / 2 + left;
        if(sortedNums[mid].integerValue > mid) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}

// A = [2,3,1,1,4], return true.
// A = [3,2,1,0,4], return false.

// 第一次想这个问题，想偏了，试图用dp去解决这个问题，死活没想明白
// greedy alogrithm

- (BOOL)canJump:(NSArray<NSNumber *> *)nums
{
    NSInteger reachIndex = 0;
    for(NSInteger i = 0; i < nums.count; i++){
        if(i > reachIndex || reachIndex >= nums.count - 1) break;// 前面是到不了 i 的，后面是已经到终点的，都可以终止循环
        reachIndex = MAX(reachIndex, i + nums[i].integerValue);
    }
    return reachIndex >= nums.count - 1;
}

// 最少需要多少步
// Given array A = [2,3,1,1,4]
// 背后有一个BFS模式
// 这种型用到的方法，之前没有见到过，
// greedy 算法的有效性？

// start end  masEnd
//   0   0      2
//   1   2      MAX(4,3)

- (NSInteger)jump:(NSArray<NSNumber *> *)nums
{
    NSInteger minSteps = 0;
    NSInteger start = 0;
    NSInteger end = 0;
    NSInteger n = nums.count;
    
    NSInteger maxEnd = 0;
    while(end < n - 1){
        minSteps++;
        for(NSInteger i = start; i <= end; i++){
            if(i + nums[i].integerValue >= n - 1) 
                return minSteps;
            maxEnd = MAX(maxEnd, i + nums[i].integerValue); //每一次最远 
        }
        start = end + 1; //注意这里假设了没有0
        end = maxEnd;
    }
    return minSteps;
}

// 下面这种算法需要调研下

//  int jump(int A[], int n) {
// 	 if(n<2)return 0;
// 	 int level=0,currentMax=0,i=0,nextMax=0;

// 	 while(currentMax-i+1>0){		//nodes count of current level>0
// 		 level++;
// 		 for(;i<=currentMax;i++){	//traverse current level , and update the max reach of next level
// 			nextMax=max(nextMax,A[i]+i);
// 			if(nextMax>=n-1)return level;   // if last element is in level+1,  then the min jump=level 
// 		 }
// 		 currentMax=nextMax;
// 	 }
// 	 return 0;
//  }



@end

@interface NumArray()
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sum;
@end

@implementation NumArray

- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 1, @"");
    if(self = [super init]){
        _sum = [NSMutableArray array];
        [_sum addObject:[nums firstObject]];

        for(NSInteger idx = 1; idx < nums.count; idx++){
            [_sum addObject:@(nums[idx].integerValue + [_sum lastObject].integerValue)];
        }
    }
    return self;
}

- (NSInteger)sumRange:(NSInteger)l r:(NSInteger)r
{
    NSAssert(l <= r && r < self.sum.count && r >= 0 && l >= 0, @"");
    if(l == 0) {
        return self.sum[r].integerValue;
    }
    return self.sum[r].integerValue - self.sum[l - 1].integerValue;
}

@end

@interface NumMatrix()
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber *> *> *sum;

@end

@implementation NumMatrix

- (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    NSAssert([matrix count] >= 1 && [matrix firstObject].count >= 1, @"");
    if(self = [super init]){
        _sum = [NSMutableArray array];
        //这里需要初始化一下
        //这里在初始化的时候全部初始化为0 and size m * n ---> m + 1 * n + 1 . inorder to process base case more conveniently 
        for(NSInteger i = 1; i <= matrix.count; i++){
            for(NSInteger j = 1; j <= [matrix firstObject].count; j++){
                self.sum[i][j] = @(matrix[i-1][j-1].integerValue + self.sum[i-1][j].integerValue + self.sum[i][j-1].integerValue - self.sum[i-1][j-1].integerValue);
            }
        }
    }
    return self;
}

- (NSInteger)sumRange:(NSInteger)l1 r:(NSInteger)r1 l2:(NSInteger)l2 r:(NSInteger)r2
{
    return self.sum[l2 + 1][r2 + 1].integerValue - self.sum[l1 + 1][r2 + 1].integerValue - self.sum[l2 + 1][r1 + 1].integerValue + self.sum[l1 + 1][r2 + 1].integerValue;
}

@end

@interface NumArray2()
@property (nonatomic, strong) SegmentTreeNode *root;

@end

@implementation NumArray2

- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 1, @"");
    if(self = [super init]){
        _root = [self buildTree:nums l:0 r: nums.count - 1];
    }
    return self;  
}

// O(n)
// 这里面有另外一种构造segement tree 的方法

// https://leetcode.com/articles/range-sum-query-mutable/#approach-3-segment-tree-accepted

- (SegmentTreeNode *)buildTree:(NSArray<NSNumber *> *)nums l:(NSInteger)l r:(NSInteger)r
{   
    if(l > r){
        return nil;
    }
    
    SegmentTreeNode *node = [[SegmentTreeNode alloc] init];
    node.start = l;
    node.end = r;
    
    if(l == r){
        node.sum = nums[l].integerValue;
    } else {
        NSInteger mid = (r - l) / 2 + l;
        node.left = [self buildTree:nums l:l r:mid];
        node.right = [self buildTree:nums l:mid+1 r:r];
        node.sum = node.left.sum + node.right.sum;
    }

    return node;
}

- (void)update:(NSInteger)idx val:(NSInteger)val
{
    [self update:self.root index:idx val:@(val)];
}

//find the left node with bianry search TreeNode update leaft node

- (void)update:(SegmentTreeNode *)node index:(NSInteger)idx val:(NSNumber *)val
{
    if(node.start == node.end){
        node.sum = val.integerValue;
    } else {
        NSInteger mid = (node.end - node.start) / 2 + node.start;
        if(idx <= mid){
            [self update:node.left index:idx val:val];
        } else {
            [self update:node.right index:idx val:val];
        }
        node.sum = node.left.sum + node.right.sum;
    }
}

- (NSInteger)sumRange:(NSInteger)l r:(NSInteger)r
{
    return [self sumRange:self.root left:l right:r];
}

- (NSInteger)sumRange:(SegmentTreeNode *)node left:(NSInteger)left right:(NSInteger)right
{
    if(node.start == left && node.end == right){
        return node.sum;
    } else {
        NSInteger mid = (node.end - node.start) / 2 + node.start;
        if(right <= mid){
            return [self sumRange:node.left left:left right:mid];
        } else if(left >= mid + 1){
            return [self sumRange:node.right left:mid + 1 right:right];
        } else {
            return [self sumRange:node.left left:left right:mid] + [self sumRange:node.right left:mid+1 right:right];
        }
    }
}

@end

@implementation RandomPickIndex
{
    NSMutableDictionary<NSNumber *, NSMutableArray *> *_dic;
}

// 首先发问数组是否已经排好序
// 首先想到的办法是 存入hash 表中

- (instancetype)initWithNums:(NSArray<NSNumber *> *)nums
{
    if(self = [super init]){
        _dic = [NSMutableDictionary dictionary];
        for(NSInteger i = 0; i < nums.count; i++){
            if(_dic[nums[i]]){
                [_dic[nums[i]] addObject:@(i)];
            } else {
                _dic[nums[i]] = [@[@(i)] mutableCopy];
            }
        }
    }
    return self;
}

- (NSInteger)pick:(NSInteger)target
{
    NSArray<NSNumber *> *indexes = _dic[@(target)];
    // if(!index){
    //     return -1;
    // }
    NSInteger randomIdex = arc4random_uniform((uint32)indexes.count);// 32位 = 32GB
    return indexes[randomIdex].integerValue;
}

//另外一种实现 O(n)

//int pick(int target)
//{
//    int count = 0, res = -1;
//    for (int i = 0; i < n.size(); ++i)
//    {
//        if(n[i] != target) continue;
//        if(++count == 1) res = i;
//        else
//            if(!(rand()%count)) res = i;
//    }
//    return res;
//}

@end

// @implementation Vector2D
// {
//     NSMutableArray *_array;
//     NSInteger _currentIndex;
// }
// //最简单的办法是初始化转成1维度数组

// - (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix
// {
//     if(self = [super init]){
//         _array = [NSMutableArray array];
//         for (NSInteger i = 0; i < matrix.count; i++) {
//             [_array addObjectsFromArray:matrix[i]];
//         }
//         _currentIndex = 0;
//     }
//     return self;
// }

// - (NSNumber *)next
// {
//     //如果越界需要特殊处理
//     NSAssert([self hasNext], @"out of range");
//     return _array[_currentIndex++];
// }

// - (BOOL)hasNext
// {
//     return _currentIndex <= [_array count] - 1;
// }

// @end

@implementation Vector2D
{
    NSEnumerator *_enumerator;
    NSEnumerator *_subEnumerator;
}

- (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    NSAssert([matrix count], @"should not be emtpy");
    
    if(self = [super init]){
        _enumerator = [matrix objectEnumerator];
        _subEnumerator = [[_enumerator nextObject] objectEnumerator];
    }
    return self;
}

- (NSNumber *)next
{
    if(![self hasNext]){
        return nil;
    }
    if([_subEnumerator nextObject] == nil){
        _subEnumerator = [[_enumerator nextObject] objectEnumerator];
    }
    return [_subEnumerator nextObject];
}

- (BOOL)hasNext
{
    return [_enumerator nextObject] == nil && [_subEnumerator nextObject] == nil;
}

@end
