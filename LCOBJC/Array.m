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

#pragma mark - 128 Longest Consecutive Sequence

//methon1: 排序后再遍历，但是比较慢
//是否有重复的元素

//methos2: 技巧性很强, 遇到数组，如果O（n）的算法复杂度要求，思考下hashtable的作用
//Fellow up 如果数组很大，dic 放不下怎么办？

// 九章的版本，
// 技巧: 1. build set 2. 左右traversal

- (NSInteger)longestConsecutive:(NSArray<NSNumber *> *)nums
{
    NSInteger res = 0;
    NSMutableSet *set = [NSMutableSet setWithArray:nums]; // step 1: build set from array

    for(NSInteger i = 0; i < nums.count; i++){
        NSNumber *down = @(nums[i].integerValue - 1); //这里的关键点先剪 后判断，这题很巧妙的地方就在于这个！！！！
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

// method 1. 用 product of all elements dived by each element
// method 2.
// first scan form right to left calculate the product of all elements in the left side of a[i] excluding a[i]

// scan form left to right
// assum integer can hold

- (NSArray<NSNumber *> *)productExceptSelf:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *> *product = [NSMutableArray array];
    NSInteger preProduct = 1;
    for(NSInteger i = 0; i < [nums count]; i++) {
        [product addObject: @(preProduct)]; //关键: 技巧就是 1.preproduct = 1 然后先添加到结果数组里面，然后进行multiply
        preProduct *= nums[i].integerValue;
    }
    
    preProduct = 1;
    for(NSInteger i = [nums count] - 1; i >= 0; i--){
        product[i] = @(product[i].integerValue * preProduct);
        preProduct *= nums[i].integerValue;
    }
    return product;
}

// k the max number 题型。
// 有相同值的情况咋办
// 1. sort
// 2. heap
// 3  ...... 上面两种不满足 O(n) 的复杂度要求
// 这道题目和triple sequence 很像

- (NSInteger)thirdMax:(NSArray<NSNumber *> *)nums
{
    NSInteger max1 = NSIntegerMin; //3rd largest
    NSInteger max2 = NSIntegerMin; //second largeets
    NSInteger max3 = NSIntegerMin; //largest 
    
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
// explain: if current is bad version, so the bad verion must in the left of current Position and inclue current Position 
// if current is not bad version so the bad version must in the right side of current exclude current 
// end condition left == right. 这里应该return left 或者right 应该没什么差别

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

// - (NSInteger)searchInRotatedArray_R:(NSArray<NSNumber *> *)nums target:(NSInteger)target
// {
//     return [self searchInRotatedArray_R:nums target:target left:0 right:nums.count - 1];
// }

// - (NSInteger)searchInRotatedArray_R:(NSArray<NSNumber *> *)nums target:(NSInteger)target left:(NSInteger)left right:(NSInteger)right
// {
//     if(left > right){
//         return -1;
//     }
//     NSInteger mid = (right - left) / 2 + left;
//     if([nums[mid] isEqualToNumber:@(target)])
//         return mid;
//     if([nums[mid] compare:nums[left]] != NSOrderedAscending){
//         if([nums[left] compare:@(target)] == )
//     } else {
    
//     }
// }

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

#pragma mark - intersection Of Two Array

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

// Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2, 2].

- (NSArray<NSNumber *> *)intersectionOfTwoArray:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    //这里可以对小的进行scane 让后放到内存中，这样空间复杂度小一些。
    
    NSMutableDictionary<NSNumber *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSNumber *num in array) {
        dic[num] = @(dic[num].integerValue + 1);
    }
    
    // filter the result
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *item in array2) {
        if(dic[item].integerValue > 0){
            [result addObject:item];
            dic[item] = @(dic[item].integerValue - 1);
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
        if([sArray[i] isEqualToNumber: sArray2[j]]) {
            if(i == 0 || ![result.lastObject isEqualToNumber:sArray[i]]){ //注意去重复
                [result addObject: array[i]];
            }
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

#pragma mark - Top K

//Find the median of an unsorted array.
//Have to do better than O(nlogn) time.
//e.g.
//Given [2, 6, 1] return 2
//Given [2, 6, 1, 4] return 3 which is sum of the two elements in middle over 2

//这道题目也可以用top K 的方法， 需要判断下奇偶数字

// 1. sort return [n-k]
// 2. priority queue . oc 没有原生的
// 3. quick select
// https://discuss.leetcode.com/topic/15256/4-c-solutions-using-partition-max-heap-priority_queue-and-multiset-respectively/2
// https://discuss.leetcode.com/topic/14597/solution-explained/2

//

- (NSNumber *)findKthLargest:(NSInteger)k inArray:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    NSInteger p = 0;
    NSMutableArray *mutableNums = [NSMutableArray arrayWithArray:nums];
    while(left <= right) { //FIXME: 这里是可以想等的
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
        if(nums[j].integerValue <= pivot){ //这里需要包括等于
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

#pragma mark - kth closest point

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
        if([nums[i] fbiCompare:pivot] != NSOrderedDescending){
            i++;
        }
        if([nums[j] fbiCompare:pivot] != NSOrderedAscending){
            j--;
        }
    }   //最后j会退到比pivot大的元素上。所以需要exchage一下
    [nums exchangeObjectAtIndex:left withObjectAtIndex:j];
    return j;
}

// index 的转移规律
// step1; 找到index转移关系
// step2: travesal 可以想象成 n/2 环，旋转这 n/2个环形.
// 举例子 4 * 4  3 * 3 这里需要注意的是 4 需要处理两环 那么 i < n/2 没有等于

// O(n * n) each element in the matrix will be write only once
// 另外一种解法 https://discuss.leetcode.com/topic/6796/a-common-method-to-rotate-the-image
// 这是一道非常容易出错的题目，各种index, 判断条件很多，要写对不容易啊

- (void)rotate:(NSMutableArray<NSMutableArray *> *)matrix
{
    if(!matrix || matrix.count <= 1 || matrix.firstObject.count <= 1){
        return;
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
        }
    }
}

// 注意over flow 高频
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

#pragma mark - Merge Interval

//有可能是这种时间结构的 ["Apr 2010 - Dec 2010", "Aug 2010 - Dec 2010", "Jan 2011 - Mar 2011"]
//写解析函数

- (NSArray<NSDateInterval *> *)mergeIntervals:(NSArray<NSDateInterval *> *)intervals
{
    //sort interval O(nlog(n))
    if([intervals count] < 2) {
        return intervals;
    }
    
    //step 1: sort the interval
    NSArray *sortedIntervals = [intervals sortedArrayUsingSelector:@selector(compare:)];    // step 2 : compare cur.start inter with next
    // if > merge  else insert to array
    NSMutableArray *result = [NSMutableArray array];
    NSDateInterval *cur = sortedIntervals[0];
    for(NSInteger idx = 1; idx < [sortedIntervals count]; idx ++){
        NSDateInterval *next = sortedIntervals[idx];
        if([cur.endDate compare:next.startDate] == NSOrderedAscending){
            [result addObject:cur];
            cur = next;
        } else {
            NSDate *laterDate = ([cur.endDate compare:next.endDate] == NSOrderedAscending) ? next.endDate : cur.endDate;
            NSDateInterval *merged = [[NSDateInterval alloc] initWithStartDate:cur.startDate endDate:laterDate];
            cur = merged;
        }
    }
    [result addObject:cur]; //添加last value
    return result;
}

// no overlap intervals

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
        newInterval.start = MIN(intervals[k].start, newInterval.start); //start 挑选小的合并
        newInterval.end = MAX(intervals[k].end, newInterval.end); //end 挑选小的合并
        k++;
    }
    [result addObject:newInterval]; // step3 : insert right part 
    while(k < count){
        [result addObject:intervals[k]];
        k++;
    }
    return result;
}

- (BOOL)canAttendMeetings:(NSArray<NSDateInterval *> *)intervals
{
    //sort the intervals 这里需要确认的是 如果后面interva 的end == 前面start 的时间，算不算重叠
    if([intervals count] <= 1){
        return YES;
    }
    
    NSArray<NSDateInterval *> *sortedIntervals = [intervals sortedArrayUsingSelector:@selector(compare:)];
    
    for(NSInteger idx = 1; idx < [sortedIntervals count]; idx++){
        if([sortedIntervals[idx].startDate compare:sortedIntervals[idx - 1].endDate] == NSOrderedAscending){
            return NO;
        }
    }
    return YES;
}

#pragma mark - Meeting ROOM 2 [H]

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

// Fellow up: 给出重合最多的时间点，或者说有最多meeting的时间点
// 问了复杂度，然后一个跟踪问题， 返回每个房间 所有的会议 的开始时间和结束时间

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

// TODO: 第一个Follow up 给出重合最多的时间点，或者说有最多meeting的时间点

- (NSInteger)minMeetingRooms_MaxOverlap:(NSArray<Interval *> *)intervals
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
    
    NSInteger maxOverlap = 0;
    NSInteger count = 0;
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger len = [intervals count];
    
    while (i < len) { //
        if(starts[i].integerValue < ends[j].integerValue) { //任意开始时间 小于结束时间，需要会议室
            count++;
            i++;  //找出所有必当前end 小的 start，统计出所有的会议室
        } else {
            count--; //当结束时间小于此时的开始时间，说明会议结束了。空闲的就加1
            j++; //继续递增J
        }
        maxOverlap = MAX(maxOverlap, count);
    }
    return maxOverlap;
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

//merge two sorted array

- (NSArray *)mergeTwoSortedArray:(NSArray *)array1 array:(NSArray *)array2
{
    if (!array1) {
        return array2;
    }
    if(!array2){
        return array1;
    }
    NSInteger i = 0;
    NSInteger j = 0;
    NSMutableArray *merged = [NSMutableArray arrayWithCapacity:[array1 count] + [array2 count]];
    
    while (i < [array1 count] && j < [array2 count]) {
        if(array1[i] < array2[j]){
            [merged addObject:array1[i]];
            i++;
        } else {
            [merged addObject:array2[j]];
            j++;
        }
    }
//    if (i < [array1 count]) {
//        [merged addObjectsFromArray:[array1 subarrayWithRange:NSMakeRange(i, [array1 count] - i)]];
//    }
    while (i < [array1 count]) {
        [merged addObject:array1[i]];
        i++;
    }
    while (j < [array2 count]) {
        [merged addObject:array2[j]];
        j++;
    }
    return [merged copy];
}

#pragma mark - mergeKSortedArray priority queue

// 这题目的方法上就思考错误了
// native 办法就是创建一个新的数组，然后排序，千万不要忘记暴力法
// needs clarify 1. is all the sub array have the same count
// 2. contains emtpy subArray
// need creat a wapper class

- (NSArray *)mergeKSortedArray:(NSArray<NSArray *> *)array
{
    if([array count] <= 1){
        return [array firstObject];
    }
    NSMutableArray *output = [NSMutableArray array];
    
    PriorityQueue *queue = [PriorityQueue new];
    for(NSInteger i = 0; i < [array count]; i++){
        PriorityNode *node = [[PriorityNode alloc] init];
        node.value = array[i].firstObject;
        node.row = i;
        node.index = 0;
        [queue addObject:node];//
    }
    
    while ([queue count]) {
        PriorityNode *wapper = [queue poll];
        [output addObject:wapper.value];
        
        if(wapper.index < array.firstObject.count - 1){
            [queue addObject:array[wapper.row][wapper.index + 1]];
        }
    }
    
    return [output copy];
}

- (NSArray *)mergeKSortedArray_divideConquer:(NSArray<NSArray *> *)array
{
    if(array.count == 0){
        return nil;
    }
    return [self mergeKSortedArray:array left:0 right:array.count - 1];
}

// T(n) = 2 * T(n / 2) + O(2m) =  mlog(n)  m is average length of sortedArray  

- (NSArray *)mergeKSortedArray:(NSArray<NSArray *> *)array left:(NSInteger)left right:(NSInteger)right
{
    if(left == right){
        return array[left];
    }

    NSInteger mid = (right - left) / 2 + left;
    NSArray *a = [self mergeKSortedArray:array left:left right:mid];
    NSArray *b = [self mergeKSortedArray:array left:mid + 1 right:right];

    return [self mergeTwoSortedArray:a array:b];
}

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

//TODO: 如果是 mini write 的话，就是首先和面试官讨论下0的数目的比率 选择算法的影响，
//      比如下面的算法如果前面有一个0后面全是1 就需要write n-1次啊.
// 需要一个index 来track 上面一个非0的数

// 只要不等于 0 就exhcange,so if there are great many zeros pick up this solution，那么就选择用这种算法。
// write times : 2 * (num of non-zero),

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

// if there are very few zeros, we picke up the below solution
// 写的次数是 T: O(n)

- (void)moveZeros_fewzero:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1){
        return;
    }
    NSInteger j = 0;
    for(NSInteger i = 0; i < nums.count; i++){
        if(![nums[i] isEqualToNumber:@0]){
            nums[j++] = nums[i];
        }
    }
    while (j < nums.count) {
        nums[j++] = @(0);
    }
}

// 双指针发，右边0的个数就是 num.count - 1 - right

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
            [nums exchangeObjectAtIndex:left++ withObjectAtIndex:right--]; //这里开始忘记了++
            //这里写两次，如果想最少次数写的话，可以使用 nums[left++] = nums[right--], 前提是不关心右边剩下来的位置是啥。
        }
    }
}

#pragma mark - schedule task with cooldown

// 双指针 + hashmap 的方法
// TODO：关键 : 如果仅仅用 i 和j 不行，因为在遇到 task[i] 的时候 需要知道 该元素对应的之前的index
//             所以需要用dic 将task 和index 的对应关系寸好

// 这里用不用j 也可以, 可以通过长度来判断

//给定任务AABCB, 冷却时间k（相同任务之间的最短距离时间），任务顺序不能变，问完成任务的总时间。
//例子：AABCB, k=2, A**ABC*B, 时间为8.
//解法：用hashtable保存上次的时间。
//Followup1：如果k很小，怎么优化？.
//解法：之前的hashtable的大小是unique task的大小，如果k很小，可以只维护k那么大的hashtable。
//ME: 如何控制hashtable 的size 呢？如何 k 很小，可以用一个k size array。但是查找相对较慢，因为k 很小所有 O(k) 的constant, 并且需要一个wapper class 把 task type 和index 寸起来

//Followup2: 如果可以改变任务的顺序，最短的任务时间是多少？
//例子：AABBC, K=2, AB*ABC, 时间为6.
//解法：根据每个任务出现的频率排序，优先处理频率高的。但是具体细节没有时间讨论。

//http://www.1point3acres.com/bbs/forum.php?mod=viewthread&tid=179575&extra=page%3D12%26filter%3Dsortid%26sortid%3D311%26searchoption%5B3046%5D%5Bvalue%5D%3D2%26searchoption%5B3046%5D%5Btype%5D%3Dradio%26sortid%3D311

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
        j++; // 这里j不用也可以，直接用 length 或者count
    }
    return [result copy];
}

// idea: 1. iterate the tasks and , and save the task and index of coresponding index in the result into a dic
//       2. we need to check insert a task, we need to check if the current index - the pre_index storeed in the dic is large or equal to k
//    if not insert _ otherwise insert the task
// first here we need to ensure the input parameter is valid

- (NSString *)cooldown_3shuai:(NSInteger)cooldown withTask:(NSArray *)tasks
{
    NSParameterAssert([tasks count]);
    NSParameterAssert(cooldown >= 0);
    
    NSMutableString *rest = [NSMutableString string];
    NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    
    for(NSString *task in tasks){
        if(!dic[task]){
            [rest appendString: [task description]];
            dic[task] = @(rest.length);
        } else {
            NSInteger prevIndex = dic[task].integerValue;
            while (prevIndex + cooldown > rest.length) {// a k = 2
                [rest appendString:@"_"];
            }
            [rest appendString: [task description]];
            dic[task] = @(rest.length);
        }
    }
    return [rest copy];
}

// TODO: follow up：在这个基础上，已知cooldown会很小，可以视作constant，task的type会很多，让我减少空间复杂度。 我用了queue，queue的size和cooldown一样。
// 但是如果用queue的话，如何进行 search 呢？一个task 如何找到对应的index呢？从而确定cooldown

- (NSArray *)cooldownOptimizeSpace:(NSInteger)cooldown withTask:(NSArray<NSString *> *)tasks
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray<NSArray *> *queue = [NSMutableArray array];
    
    for(NSInteger i = 0; i < tasks.count; i++) {
        NSInteger idx = [queue indexOfObjectPassingTest:^BOOL(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.firstObject isEqualToString: tasks[i]];
        }];
        while (idx != NSNotFound && ((NSNumber *)queue[idx].lastObject).integerValue + cooldown >= result.count) {
            [result addObject:@"_"];
        }
        [result addObject:tasks[i]];
        if([queue count] == cooldown){
            [queue removeObjectAtIndex:0];
        }
        [queue addObject:@[tasks[i], @(result.count - 1)]];
    }
    return [result copy];
}

- (NSString *)cooldownOptimizeSpace_3shua:(NSInteger)cooldown withTask:(NSArray<NSString *> *)tasks
{
    if(tasks.count == 0){
        return @"";
    }
    if(cooldown == 0){
        return [tasks componentsJoinedByString:@""];
    }
    
    NSMutableString *str = [NSMutableString string];
    NSMutableArray *queue = [NSMutableArray array];
    for (NSInteger i = 0; i < cooldown; i++) { //这一步填充queue 非常重要，否则下面的while 通过K进行的拼接就是无效的
        [queue addObject:@""];
    }
    
    for (NSString *task in tasks) {
        NSInteger idx = [queue indexOfObject:task];
        if(idx != NSNotFound){
            NSInteger k = idx;
            while (k >= 0) {
                k--;
                [queue removeObjectAtIndex:0];
                [queue addObject:@"_"];
                [str appendString:@"_,"];
            }
        }
        [queue removeObjectAtIndex:0];
        [queue addObject:task];
        [str appendString:task];
    }
    return [str copy];
}

// rearragnge the task to get the shortest time
// eg. abcsaab k =3
// ab,c,s,a,b_,_
// aaabbcc  k = 3
// abc_abc_a =  2 * 4 + 1

// aaabbccffgg  k = 3
// abcfabcfa =  2 * 4 + 1,  total: 9, 后面的gg 可以直接插入在前面的里面

// 如果种类多的话，也就是说 种类 * cooldown >
// 这其实有两种情况:

// 1. 不需要插入任何 slot _. 此时的长度就是task 的长度
// 2. 插入 slot, 说明其他task不够用来替换slot。

// how to arrange the task?
// 公式: (maxFrequency - 1) * (cooldown + 1) + countOfMax
//

/**
 * Find the task that appears for the most time
 * Use a map to count the number of the times the task appears  then get the maximum count
 * the result is decided by the maximum count and the number of tasks with maximum count
 *
 * two conditions:
 * 1.  5 4 _ _ _ 5 4 _ _ _ 5 4 _ _ _ 5 4  the rest tasks cannot fill the empty slots
 *     5 4 3 2 _ 5 4 3 2 _ 5 4 _ _ _ 5 4
 *     the answer is (maxCount - 1) * (interval + 1) + CountOfMax
 * 1. 5 4 _ _ _ 5 4 _ _ _ 5 4 _ _ _ 5 4  the rest tasks cannot fill the empty slots
 *    5 4 3 2 1 6 5 4 3 2 1 6 5 4 6 _ _ 5 4
 *    the answer is the length of the nums
 *    the task which does not have max count first fills the empty slots and then just insert any valid place
 * */

- (NSInteger)cooldown3:(NSInteger)cooldown withTask:(NSArray *)tasks
{
    NSMutableDictionary<NSNumber *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSNumber *t in tasks){
        dic[t] = @(dic[t].integerValue + 1);
    }
    
    NSInteger maxFreq = 1;
    NSInteger count = 0;
    for (NSNumber *freq in dic.allValues) {
        if(freq.integerValue > maxFreq){
            maxFreq = freq.integerValue;
            count = 0;
        }
        if(maxFreq == freq.integerValue){
            count++;
        }
    }
    return MAX((maxFreq - 1) * (cooldown + 1) + count, tasks.count);
}

// 需要借助 heap 来实现 最大值的选取

- (NSString *)cooldown4:(NSInteger)cooldown withTask:(NSArray *)tasks
{
    NSMutableDictionary<NSString *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSString *t in tasks){
        dic[t] = @(dic[t].integerValue + 1);
    }
    
    PriorityQueue *queue = [PriorityQueue new];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [queue addObject:@[key, obj]]; //根据频率进行排序
    }];
    
    NSMutableString *str = [NSMutableString string];
    NSMutableArray *temp = [NSMutableArray array];
    
    while ([queue count]) {
        NSInteger i = 0;
        [temp removeAllObjects];//
        
        while (i <= cooldown && [queue count]) {
            NSArray *cur = [queue poll]; // [char, frequency]
            [str appendString:cur.firstObject];
            NSArray *newCur = @[cur.firstObject, @(((NSNumber *)cur.lastObject).integerValue - 1)];
            [temp addObject:newCur];
            i++;
        }
        
        while (i <= cooldown) { //如果没有足够的字符填充那个位置,用“_” 填充
            [str appendString:@"_"];
            i++;
        }
        
        for (NSArray *t in temp) { //将还没有放完的字符重新加入到heap 中
            if(((NSNumber *)t.lastObject).integerValue > 0 ){
                [queue addObject:t];
            }
        }
        
        //after concentation the string remove the last --
        for (NSInteger i = str.length - 1; i >= 0; i++) {
            NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
            if([ch isEqualToString:@"_"]){
                [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
            } else {
                break;
            }
        }
        
    }
    return [str copy];

}

#pragma mark - sparse matrix


- (NSInteger)vector:(NSArray<NSNumber *> *)vector dotVector:(NSArray<NSNumber *> *)vector2
{
    NSAssert([vector count] == [vector2 count], @"");
    NSInteger result = 0;
    for(NSInteger i = 0; i < vector.count; i++){
        result += vector[i].integerValue * vector2[i].integerValue;
    }
    return result;
}

//   Fellow up : 一大，一小 并且拍好序的
//   input A =[[1, a1], [300, a300], [5000, a5000]]
//         B =[[100, b100], [300, b300], [1000, b1000]]
// T: O * log(m)

// 面试官先问每个vector很大，不能在内存中存下怎么办，我说只需存下非零元素和他们的下标就行，然后问面试官是否可用预处理后的
// 这两个vector非零元素的index和value作为输入，面试官同意后写完O(M*N)的代码(输入未排序，只能一个个找)，MN分别是两个vector长度。

// 又问这两个输入如果是根据下标排序好的怎么办，是否可以同时利用两个输入都是排序好这一个特性，最后写出了O(M + N)的双指针方法，
// 每次移动pair里index0较小的指针，如果相等则进行计算，再移动两个指针。

// 又问如果一个向量比另一个长很多怎么办，我说可以遍历长度短的那一个，然后用二分搜索的方法在另一个vector中找index相同的那个元素，
// 相乘加入到结果中，这样的话复杂度就是O(M*logN)。

// 又问如果两个数组一样长，且一会sparse一会dense怎么办。他说你可以在two pointer的扫描中内置一个切换二分搜索的机制。
// 看差值我说过，设计个反馈我说过，他说不好。他期待的解答是，two pointers找到下个位置需要m次比较，而直接二分搜需要log(n)次比较。
// 那么在你用two pointers方法移动log(n)次以后，就可以果断切换成二分搜索模式了。

// Binary search如果找到了一个元素index，那就用这次的index作为下次binary search的开始。可以节约掉之前的东西，不用search了。
// 然后问，如果找不到呢，如何优化。说如果找不到，也返回上次search结束的index，然后下次接着search。
// 就是上一次找到了，就用这个index继续找这次的；如果找不到，也有一个ending index，就用那个index当starting index。
// 比如[1, 89，100]，去找90；如果不存在，那么binary search的ending index应该是89，所以下次就从那个index开始。
// 如果找不到，会返回要插入的位置index + 1，index是要插入的位置，我写的就是返回要插入的index的。
// 但是不管返回89还是100的index都无所谓，反正只差一个，对performance没有明显影响的。

// 楼主:暴力双循环，skip 0.
// 面试官:不急着写，你想想有什么好办法存vector？
// 琢磨了好久，说要不我们用hashmap存value和index
// 面试官继续追问，hashmap会有空的空间，我们有memory限制，你怎么办
// 楼主:那用arraylist存pair？
// 面试官：这个还差不多，那你打算怎么求解？
// 楼主：排序，two pointer？
// 面试官：好，你写吧。写完后追问了时间复杂度

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

//TODO: Follow up 2 : 差不多大, if sorted base on index, and both of them size 差不多。

- (NSInteger)sparseVector2:(NSArray<NSArray<NSNumber *> *> *)vector dotVector:(NSArray<NSArray<NSNumber *> *> *)vector2
{
    NSInteger i = 0;
    NSInteger j = 0;
    
    NSInteger result = 0; // can we assume the integer can hold the result
    
    while(i < vector.count && j < vector2.count){
        if([vector[i].firstObject isEqualToNumber: vector2[i].firstObject]){
            result += vector[i].lastObject.integerValue * vector2[i].lastObject.integerValue;
            i++;
            j++;
        } else if(vector[i].firstObject.integerValue > vector2[i].firstObject.integerValue){
            j++;
        } else {
            i++;
        }
    }
    return result;
}

//TODO: Follow up two inputs are sorted by index0, have same size, sometimes dense, sometimes sparse; two pointes + binary search

- (NSInteger)sparseVector3:(NSArray<NSArray<NSNumber *> *> *)vector dotVector:(NSArray<NSArray<NSNumber *> *> *)vector2
{
    NSInteger i = 0;
    NSInteger j = 0;
    
    NSInteger result = 0; // can we assume the integer can hold the result
    
    NSInteger countA = 0;
    NSInteger countB = 0;

    while(i < vector.count && j < vector2.count){
        if([vector[i].firstObject isEqualToNumber: vector2[i].firstObject]){
            result += vector[i].lastObject.integerValue * vector2[i].lastObject.integerValue;
            i++;
            j++;
            countA++;
        } else if(vector[i].firstObject.integerValue > vector2[i].firstObject.integerValue){
            j++;
            //和下面的逻辑一样
        } else {
            i++;
            countA++;
            countB = 0;
            if(countA > log2(vector2.count)){
                NSInteger idx = [vector2 indexOfObject:vector[i]
                             inSortedRange:NSMakeRange(i, vector2.count - i - 1)
                                   options:NSBinarySearchingFirstEqual
                           usingComparator:^NSComparisonResult(NSArray<NSNumber *>  * _Nonnull obj1, NSArray<NSNumber *> * _Nonnull obj2) {
                               return [obj1.firstObject isEqualToValue: obj2.firstObject];
                           }];
                if(idx != NSNotFound){
                    i = idx;
                    countA = 0; // we need to set back
                }
            }
        }
    }
    return result;

}

#pragma mark - bucket sort

// sort frequcy. 这个桶排序的方法也可以用来解决 推荐top k 好友的问题
// 推荐好友，首先统计好友出现的频率。然后通过通排序的办法
// T = 2 * O(n) + the count of distinct char + o(n) = O(n)
// space = O(n)

- (NSString *)frequencySort:(NSString *)str
{
    NSParameterAssert(str);
    NSMutableDictionary<NSString *, NSNumber *> *map = [NSMutableDictionary dictionary];
    for(NSInteger i = 0; i < str.length; i++){ //space: distinct O(n)
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        map[ch] = @(map[ch].integerValue + 1); //
    }
    
    NSMutableArray<NSMutableArray *> *bucket = [NSMutableArray array];
    for(NSInteger i = 0; i < str.length + 1; i++){ //
        [bucket addObject:[NSMutableArray array]];
    }
    
    for (NSString *key in map.allKeys) { //
        NSInteger fre = map[key].integerValue;
        [bucket[fre] addObject:key];
    }
    
    //when we get the bucket, we out the result; //space: O(n)
    NSMutableString *mstr = [@"" mutableCopy];
    for(NSInteger i = bucket.count - 1; i >= 0; i--){
        if(bucket[i].count > 0){
            [mstr appendString:[bucket[i] componentsJoinedByString:@""]];
        }
    }
    return [mstr copy];
}

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

// 1. if target > a[mid] left = mid + 1
// 2. if target <= a[mid] right = mid
// and the range should be [0, n]

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

- (NSInteger)findCelebrity:(NSArray *)nums
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
// 思路: sum of [1, n] and the all the element in the array
// 技巧在于一次iteration

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

// 二分法, 第一比index 大的数字就是，其对应的index 就是 log（n）
// 这个其实和 firstBadVersion 完全一样的原理,因为在missing number 之后呢，其所有的数字比当前的index 要大。

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
// 贪心算法

- (BOOL)canJump:(NSArray<NSNumber *> *)nums
{
    NSInteger reachIndex = 0;
    for(NSInteger i = 0; i < nums.count; i++){
        if(i > reachIndex || reachIndex >= nums.count - 1) break; // 前面是到不了 i 的，后面是已经到终点的，都可以终止循环
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


//such that arr[i] < arr[j] < arr[k] given 0 ≤ i < j < k ≤ n-1 else return false.
//这种题目技巧性有点强, 看了答案

// [M]334. Increasing Triplet Subsequence
//1. 首先提到的是暴力法子 O(n^2)

- (BOOL)increasingTripletBF:(NSArray<NSNumber *> *)nums
{
    if(nums.count < 3){
        return NO;
    }
    for (NSInteger i = 0; i < nums.count - 2; i++) {
        NSInteger second = i + 1;
        NSInteger last = second + 1;
        while (second < nums.count - 1 && last < nums.count) {
            while(nums[second].integerValue <= nums[i].integerValue && second < nums.count - 1){
                second++;
            }
            last = second + 1;
            while (nums[last].integerValue <= nums[second].integerValue && last < nums.count) {
                last++;
            }
            if(last < nums.count || second < nums.count - 1){
                return YES;
            }
        }
    }
    return NO;
}

// This problem can be converted to be finding if there is a sequence such that
// the_smallest_so_far < the_second_smallest_so_far < current. We use x, y and z to denote the 3 number respectively.

// 和third3 max 模版很类似
// 如果tript 扩展到k 如何处理，
// 记录最小值和次小值法

//Given [1, 2, 3, 4, 5],

- (BOOL)increasingTriplet:(NSArray<NSNumber *> *)nums
{
    if(nums.count < 3){
        return NO;
    }
    NSInteger smallest = NSIntegerMax;
    NSInteger secondS = NSIntegerMax;
    for(NSNumber *num in nums){
        if(num.integerValue <= smallest){ //注意！！！这里容易出错的地方是 忘记写 =
            smallest = num.integerValue;
        } else if (num.integerValue <= secondS){
            secondS = num.integerValue;
        } else {
            return YES;
        }
    }
    return NO;
}

// 扩展到K 如何处理
// 讲if else 的顺序转成数组的顺序,
// 
- (BOOL)increasing:(NSArray<NSNumber *> *)nums k:(NSInteger)k
{
    if(nums.count < k){
        return NO;
    }
    
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:k];
    for (NSInteger j = 0; j < k; j++) {
        [dp addObject:@(NSIntegerMax)];
    }
    
    for(NSNumber *num in nums){  //O(n * k)
        for (NSInteger j = 0; j < k; j++) {
            if(num.integerValue <= dp[j].integerValue){
                dp[j] = num;
                if(j == k - 1){ //这个地方一开始没有写。
                    return YES;
                }
                break;
            }
            if(j == k - 1){
                return YES;
            }
        }
    }
    return NO;
}

// 457. Circular Array Loop

//- (BOOL)circularArrayLoop:(NSArray<NSNumber *> *)nums
//{
//
//}

#pragma mark - 73. Set Matrix Zeroes [R] 

- (void)setMatrixZero:(NSMutableArray<NSMutableArray<NSNumber *> *> *)matrix
{
    NSMutableSet<NSNumber *> *rows = [NSMutableSet set];//去除重复的行, 这里也可以用array
    NSMutableSet<NSNumber *> *cols = [NSMutableSet set];

    for(NSInteger i = 0; i < matrix.count; i++){
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            if(matrix[i][j].integerValue == 0){
                [rows addObject:@(i)];
                [cols addObject:@(j)];
            }
        }
    }
    //下面这种方式比上面这个两个循环的 性能优化的一倍
    for(NSInteger i = 0; i < matrix.count; i++){// we iterate the matrix and look up the row or col from set index set.
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            if([rows containsObject:@(i)] || [cols containsObject:@(j)]){
                matrix[i][j] = @(0);
            }
        }
    }
}

//扫描 遇到0 把这一行 一列 非0 的替换成 特殊字符，其他不变
//最后把 特殊字符换成 0
//TODO: constant space, 还是有一定的技巧性的
//关键: matrix[0][0] 这个位置需要特殊处理

- (void)setMatrixZeroOptimize:(NSMutableArray<NSMutableArray<NSNumber *> *> *)matrix
{
    NSInteger rows = matrix.count;
    NSInteger cols = matrix.firstObject.count;
    NSInteger col0 = 1;//FIXME:存储的 第一列的状态 为了避免和 martix[0][0] 重叠，matrix[0][0]存储的是第一行的

    for(NSInteger i = 0; i < rows; i++){
        if(matrix[i][0].integerValue == 0) {
            col0 = 0;
        }
        for(NSInteger j = 1; j < cols; j++){
            if(matrix[i][j].integerValue == 0){
                matrix[i][0] = @0;
                matrix[0][j] = @0;
            }
        }
    }
    //为了保存头部 和左边的信息，right--> left 以及 bottom -> up 按这个顺序scan
    for(NSInteger i = rows - 1; i >= 0; i--){
        for(NSInteger j = cols - 1; j >= 1; j--){
            if(matrix[i][0].integerValue == 0 || matrix[0][j].integerValue == 0){
                matrix[i][j] = @0;
            }
        }
        if(col0 == 0){
            matrix[i][0] = @0;
        }
    }    
}

// 给一个数组，每个元素有一个概率，写一个函数按照每个元素的概率每次返回一个元素。比如1：0.2，2：0.3，3：0.5    返回1的概率是0.2，返回3的概率是0.5
// TODO: 思路: 求教一道题，给定一列元素，以及对应的概率，实现一个function，如何按照相应概率返回元素？
// 把每个数字对应的概率叠加变成 cdf，用hashmap存着，一个[0, 1]的float number，如果这个float number小于这个数字对应的cdf 概率，就返回这个数就可以了。
// [elementVal, ]

// 对于invalid input 的判断，如果概率为0, 以及概率为1， 概率> 1 的错误情况

- (NSInteger)randomPick:(NSArray<NSArray<NSNumber *> *> *)nums
{
    NSMutableArray<NSNumber *> *acum = [NSMutableArray arrayWithCapacity:nums.count];
    [acum addObject:[nums firstObject].lastObject];
    for(NSInteger i = 1; i < nums.count; i++){
        [acum addObject: @(nums[i].lastObject.floatValue + acum[i - 1].floatValue)];
    }
    float max = powf(2, 32);
    float r = (float)arc4random() / max;
    for(NSInteger i = 0; i < acum.count; i++){
        if(r < acum[i].floatValue){
            return nums[i].firstObject.integerValue;
        }
    }
    return NSNotFound;
}

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
    return self.sum[l2 + 1][r2 + 1].integerValue - self.sum[l1][r2].integerValue - self.sum[l2][r1].integerValue + self.sum[l1][r2].integerValue;
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

// T(n) = 2 * T(n / 2) + 1 = O(n)

- (SegmentTreeNode *)buildTree:(NSArray<NSNumber *> *)nums l:(NSInteger)l r:(NSInteger)r
{   
    if(l > r){
        return nil;
    }
    
    SegmentTreeNode *node = [[SegmentTreeNode alloc] init];
    node.start = l;
    node.end = r;
    
    if(l == r){ // we know that it's the leaf node
        node.sum = nums[l].integerValue;
    } else {
        NSInteger mid = (r - l) / 2 + l;
        node.left = [self buildTree:nums l:l r:mid];
        node.right = [self buildTree:nums l:mid + 1 r:r];
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
    if(node.start == node.end){ //we know it was leaf node
        node.sum = val.integerValue;
    } else {
        NSInteger mid = (node.end - node.start) / 2 + node.start;
        if(idx <= mid){
            [self update:node.left index:idx val:val];
        } else {
            [self update:node.right index:idx val:val];
        }
        node.sum = node.left.sum + node.right.sum; // when the left part or the right part is updated , we need to update the current node
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
            return [self sumRange:node.left left:left right:mid] + [self sumRange:node.right left:mid + 1 right:right];
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

 @implementation Vector2D
 {
     NSMutableArray *_array;
     NSInteger _currentIndex;
 }
 //最简单的办法是初始化转成1维度数组

 - (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix
 {
     if(self = [super init]){
         _array = [NSMutableArray array];
         for (NSInteger i = 0; i < matrix.count; i++) {
             [_array addObjectsFromArray:matrix[i]];
         }
         _currentIndex = 0;
     }
     return self;
 }

 - (NSNumber *)next
 {
     //如果越界需要特殊处理
     NSAssert([self hasNext], @"out of range");
     return _array[_currentIndex++];
 }

 - (BOOL)hasNext
 {
     return _currentIndex <= [_array count] - 1;
 }

 @end


//@implementation Vector2D
//{
//    NSEnumerator *_enumerator;
//    NSEnumerator *_subEnumerator;
//}
//
//- (instancetype)initWithMatrix:(NSArray<NSArray<NSNumber *> *> *)matrix
//{
//    NSAssert([matrix count], @"should not be emtpy");
//    
//    if(self = [super init]){
//        _enumerator = [matrix objectEnumerator];
//        _subEnumerator = [[_enumerator nextObject] objectEnumerator];
//    }
//    return self;
//}
//
//- (NSNumber *)next
//{
//    if(![self hasNext]){
//        return nil;
//    }
//    if([_subEnumerator nextObject] == nil){
//        _subEnumerator = [[_enumerator nextObject] objectEnumerator];
//    }
//    return [_subEnumerator nextObject];
//}
//
////这种实现是有问题的，因为调用一次 nextObject 之后，index 的位置就变了
//- (BOOL)hasNext
//{
//    return !([_enumerator nextObject] == nil && [_subEnumerator nextObject] == nil);
//}
//
//@end
