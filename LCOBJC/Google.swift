//
//  Google.swift
//  LCOBJC
//
//  Created by ethon_qi on 31/3/2017.
//  Copyright © 2017 andy. All rights reserved.
//

import Cocoa

class Google: NSObject {

//532. K-diff Pairs in an Array
//    Given an array of integers and an integer k, you need to find the number of unique k-diff pairs in the array. Here a k-diff pair is defined as an integer pair (i, j), where i and j are both numbers in the array and their absolute difference is k.
//    
//    Example 1:
//    Input: [3, 1, 4, 1, 5], k = 2
//    Output: 2
//    Explanation: There are two 2-diff pairs in the array, (1, 3) and (3, 5).
//    Although we have two 1s in the input, we should only return the number of unique pairs.
//    Example 2:
//    Input:[1, 2, 3, 4, 5], k = 1
//    Output: 4
//    Explanation: There are four 1-diff pairs in the array, (1, 2), (2, 3), (3, 4) and (4, 5).
//    Example 3:
//    Input: [1, 3, 1, 5, 4], k = 0
//    Output: 1
//    Explanation: There is one 0-diff pair in the array, (1, 1).
//    Note:
//    The pairs (i, j) and (j, i) count as the same pair.
//    The length of the array won't exceed 10,000.
//    All the integers in the given input belong to the range: [-1e7, 1e7].
    
    static func findPairs(_ nums: [Int], _ k: Int) -> Int {
        var count = 0
        var sortedNums = nums.sorted()
        
        for i in 0..<sortedNums.count - 1 {
            if(i != 0 && sortedNums[i] == sortedNums[i - 1]){
                continue;
            }
            let k = i + 1
            for j in k...sortedNums.count - 1 {
                if(sortedNums[i] == sortedNums[j] - k){
                    count += 1;
                    break;
                }
            }
        }
        return count
    }
    
}
