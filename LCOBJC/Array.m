//
//  Array.m
//  LCOBJC
//
//  Created by ethon_qi on 25/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Array.h"

@implementation Array

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
    NSMutableSet *set = [NSMutableSet set];
    for(NSInteger i = 0; i < nums.count; i++){
        [set addObject:nums[i]];
    }
    for(NSInteger i = 0; i < nums.count; i++){
        if([set count] == 0){ //判断set是否是空
            break;
        }
        NSNumber *down = @(nums[i].integerValue - 1);
        if([set containsObject:down]){
            [set removeObject:down]; //避免重复
            down = @(down.integerValue - 1);
        }
        NSNumber *up = @(nums[i].integerValue + 1);
        if([set containsObject:up]){
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

// 1. sort return [n-k]
// 2. priority queue . oc 没有原生的
// 3. quick select
// https://discuss.leetcode.com/topic/15256/4-c-solutions-using-partition-max-heap-priority_queue-and-multiset-respectively/2
// https://discuss.leetcode.com/topic/14597/solution-explained/2

- (NSNumber *)findKthLargest:(NSInteger)k inArray:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = [nums count]-1;
    
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

- (NSInteger)partition:(NSMutableArray<NSNumber *> *)nums left:(NSInteger)left right:(NSInteger)right
{
    NSInteger pivot = nums[left].integerValue;
    NSInteger i = left + 1;
    NSInteger j = right;
    while(i <= j) {
        if(nums[j].integerValue > pivot && nums[i].integerValue < pivot) {
            [nums exchangeObjectAtIndex:i withObjectAtIndex:j];
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

// MIT open class has video. 这里面用的双指针法，可以解决 “一道把排好序的数组每个element平方，输出还是排好序的”。 head tail 进行比较
- (NSArray<NSArray *> *)threeSum:(NSArray *)nums // 3sum
{
    //sort array
    NSAssert([nums count] >= 3 , @"");
    
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < [nums count] - 2 ; i++) {
        if(i == 0 || (i > 0 && sortedNums[i].integerValue != sortedNums[i-1].integerValue)) { //注意去除重复，这里可以提取出来，写成continue 的形式，或者while 的形式
            NSUInteger left = i + 1;
            NSUInteger right = [nums count] - 1;
            NSInteger sum = 0 - sortedNums[i].integerValue;
            
            while (left < right) {
                if(sortedNums[left].integerValue + sortedNums[right].integerValue == sum) {
                    [result addObject: @[sortedNums[left], sortedNums[right], sortedNums[i]]];
                    while(left < right && sortedNums[left].integerValue == sortedNums[left + 1].integerValue) { //注意去除重复
                        left += 1;
                    }
                    while (left < right && sortedNums[right].integerValue == sortedNums[right - 1].integerValue) { //注意去除重复
                        right -= 1;
                    }
                    left++;
                    right--;
                } else if (sortedNums[left].integerValue + sortedNums[right].integerValue < sum) {
                    left ++;
                } else {
                    right--;
                }
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

// - (NSInteger)threeSumClosest
// {
//
// }

// - (NSInteger)3sumSmaller
// {

// }

- (NSArray *)Twosum:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    // can we assume the length of nums larger than 1
    if(nums.count < 2) {
        return @[];
    }
    
    NSMutableDictionary<NSNumber *, NSNumber *> *map = [NSMutableDictionary dictionary];
    for(NSUInteger idx = 0; idx < nums.count; idx++) {
        NSNumber *prevIdx = map[@(target - nums[idx].integerValue)];
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

// - (NSInteger)4sum
// {
//
// }

// k the max number 题型。
// top k 问题
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

//BST 过程中 idx 如何更新
// index 处理的需要注意 数组中是否有相等的元素。
// 在遇到 case [3, 1] targe = 1 的时候 错了. 是因为 在判断排好序的左边那一行 写成 > 正确的应该是 >=

- (NSInteger)searchInRotatedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSUInteger left = 0;
    NSUInteger right = [nums count] - 1;
    // eg 67012345
    // eg 34567012
    while(left <= right) {
        NSUInteger mid = (right - left) / 2 + left;
        //两种结构情况
        if(nums[mid].integerValue == target) {
            return mid;
        }
        // 排好序的在左边
        if(nums[mid] >= nums[left]) {
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

// eg 67012345
// eg 34567012

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

// 如果数组很大怎么办
// assum array not emtpy
// 難題目

// - (float)findMedianInSortedArrays:(NSArray<NSNumber *> *)arr1 anotherArray:(NSArray<NSNumber *> *)arr2
// {
//     //two special case
//     //step 1 odd
//     NSInteger m = [arr1 count];
//     NSInteger n = [arr2 count];
//     NSInteger mid = (m + n) / 2;
//     if((m + n0) % 2) {
//         return (float)[self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid + 1];
//     } else {
//         NSInteger first = [self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid];
//         NSInteger second = [self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid];
//         return double (first + second) * 0.5;
//     }
// }

// - (NSInteger)findKthNumInArray:(NSArray<NSNumber *> *)arr1 idx:(NSInteger)i otherArray:(NSArray<NSNumber *> *)arr2 idx:(NSInteger)j kth:(NSInteger)k
// {
//     if(i >= [arr1 count]) {
//         return arr2[j + k - 1];
//     }
//     if(j >= [arr2 count]) {

//     }


// }

//- (NSArray<interval *> *)mergeIntervals:(NSArray<interval *> *)intervals
//{
//  //sort interval O(nlog(n))
//  if([intervals count] < 2) {
//      return intervals;
//  }
//  NSArray *sortedIntervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(interval *first, interval *second ) {
//      if(first.start < second.start) {
//          return NSOrderedAscending;
//      } else if(first.start == second.start) {
//          return NSOrderedSame;
//      } else {
//          return NSOrderedDescending;
//      }
//  }];
//
//  NSMutableArray *result;
//  interval *cur = sortedIntervals[0];
//  interval *next;
//  for(NSInteger idx = 1; idx < [sortedIntervals count]; idx ++){
//      *next = sortedIntervals[idx];
//      if(cur.end >= next.start) {
//          cur.end = MAX(cur.end, next.end); //注意这里需要和第二个的end进行比较
//      } else {
//          [result addObject:cur];
//          cur = next;
//      }
//  }
//  [result addObject:cur]; //添加last value
//  return result;
//}

// Solution A: scane it , build an dictionary
// which nums is larger , does it has some impact the alogrithm we choose ?
// 数组里面是整数吗？／／ 这个要确定
// Two hash table 我对于这到题目的理解，和网上的不太一样，区别在于 数组的中元素的重复个数是不是一定要相同
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
- (NSArray<NSNumber *> *)intersectionOfTwoArray_TwoPointer:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    //nums1.size() is large
    //corner case
    
    // sorted the two array
    // NSArray<NSNumber *> *sortedNums = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
    //     if( obj1.integerValue < obj2.integerValue ) {
    //         return NSOrderedAscending;
    //     } else if(obj2.integerValue == obj1.integerValue) {
    //         return NSOrderedSame;
    //     } else {
    //         return NSOrderedDescending;
    //     }
    // }];
    
    if([array lastObject] < [array2 firstObject] || [array firstObject] > [array2 lastObject]) {
        return @[];
    }
    
    NSInteger i = 0; // scan array
    NSInteger j = 0;
    NSMutableArray *result = [NSMutableArray array];
    while(i < [array count] && j < [array count]) {  // 这里的问题是如果数组很长，但是另外一个数组很小，可以通过二分查找先快速定位
        if(array[i].integerValue == array2[j].integerValue) {
            [result addObject: array[i]];
            i++;
            j++;
        } else if(array[i].integerValue < array2[j].integerValue) {
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

//统计个数0 1 2，然后rewrite 的array。 Two pass algorithm

// 没有实现

// - (void)sortedColors:(NSMutableArray *)nums
// {
//     NSInteger i = 0;
//     NSInteger j = [nums count] - 1;

//     while(i < j) {
//         while(i < j && nums[i].integerValue == 0) {
//             i++;
//         }
//         while(i < j && nums[j].integerValue == 2) {
//             j--;
//         }
//         if(nums[i].integerValue > nums[i].integerValue) {

//         }

//     }
//     return nums;
// }

// 记住这几个 index 的位置 九章算法版本
// 0......0   1......1  x1 x2 .... xm   2.....2
//        |             |           |
//       left          cur         right

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
            cur++;
            left++;
        } else if(nums[cur].integerValue == 1) {
            cur++;
        } else {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:right];
            right--;
        }
    }
}

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
- (NSNumber *)findMin_my:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");
    
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        //not rotate case
        if(nums[left] < nums[right]) {
            return nums[left];
        }
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue > nums[left].integerValue) {
            left = mid + 1;
        } else if(nums[mid].integerValue > nums[left].integerValue) {
            right = mid;
        }
    }
    return nums[left];
}

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

// https://discuss.leetcode.com/topic/17063/4ms-o-n-8ms-o-nlogn-c
// Binary Search 的实现有些复杂 Olg(n). TODO： 可以自己实现下

- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray<NSNumber *> *)nums
{
    NSInteger start = 0;
    NSInteger minSize = NSIntegerMax;
    NSInteger sum = 0;
    
    for(NSInteger i = 0; i < [nums count]; i++) {
        sum += nums[i].integerValue;
        while(sum >= s) {
            minSize = MIN(minSize, i - start + 1);
            sum = sum - nums[start].integerValue;
            start++;
        }
    }
    return minSize == NSIntegerMax ? 0 : minSize;
}

// 注意over flow
// O(n * n) brute force 假设不会溢出
// 没想到 one pass 的方法
// DP
//

- (NSInteger)maxProduct:(NSArray<NSNumber *> *)nums
{
    NSInteger count = [nums count];
    NSMutableArray<NSNumber *> *maxProduct = [NSMutableArray array];
    NSMutableArray<NSNumber *> *minProduct = [NSMutableArray array];
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

- (NSInteger)minMeetingRooms:(NSArray<Interval *> *)intervals
{
    NSMutableArray<NSNumber *> *starts = [NSMutableArray array];
    NSMutableArray<NSNumber *> *ends = [NSMutableArray array];
    for(Interval *it in intervals){
        [starts addObject:@(it.start)];
        [ends addObject:@(it.end)];
    }
    
    [starts sortUsingSelector:@selector(compare:)]; // nlog(n)
    [ends sortUsingSelector:@selector(compare:)];
    
    NSInteger numOfRooms = 0;
    NSInteger numOfFreeRooms = 0;
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSInteger len = [intervals count];
    
    while (i < len) { //为什么这里i < len 之后就不用判断了呢？
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

@end
