//
//  Palindrome.h
//  LCOBJC
//
//  Created by ethon_qi on 7/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

//求任意string里有多少个palindromic substring，这个string可以包含任意字符，单个的char也算合理的palindromic substring
//这题和longest palindromic 有啥区别

@interface Palindrome : NSObject

// palindrome linked list , 也是容易出错的题目

//5. Longest Palindromic Substring

//Given a string s, find the longest palindromic substring in s. You may assume that the maximum length of s is 1000.
//Example:
//Input: "babad"
//Output: "bab"
//
//Note: "aba" is also a valid answer.
//Example:
//
//Input: "cbbd"
//
//Output: "bb"

- (NSString *)longestPalindrome:(NSString *)str;

//409. Longest Palindrome
//Difficulty: Easy
//Given a string which consists of lowercase or uppercase letters, find the length of the longest palindromes that can be built with those letters.
//
//This is case sensitive, for example "Aa" is not considered a palindrome here.
//Note:
//Assume the length of given string will not exceed 1,010.
//Example:
//
//Input:
//"abccccdd"
//
//Output:
//7
//
//Explanation:
//One longest palindrome that can be built is "dccaccd", whose length is 7.

- (NSInteger)lengthOfLongestPalindrome:(NSString *)str;

//214. Shortest Palindrome [H]

//Difficulty: Hard
//Contributors: Admin
//Given a string S, you are allowed to convert it to a palindrome by adding characters in front of it. Find and return the shortest palindrome you can find by performing this transformation.
//
//For example:
//
//Given "aacecaaa", return "aaacecaaa".
//
//Given "abcd", return "dcbabcd".'

- (NSString *)shortestPalindrome:(NSString *)str;

// 336. Palindrome Pairs

// Given a list of unique words, find all pairs of distinct indices (i, j) in the given list, so that the concatenation of the two words, i.e. words[i] + words[j] is a palindrome.

// Example 1:
// Given words = ["bat", "tab", "cat"]
// Return [[0, 1], [1, 0]]
// The palindromes are ["battab", "tabbat"]
// Example 2:
// Given words = ["abcd", "dcba", "lls", "s", "sssll"]
// Return [[0, 1], [1, 0], [3, 2], [2, 4]]
// The palindromes are ["dcbaabcd", "abcddcba", "slls", "llssssll"]

- (NSArray<NSNumber *> *)palindromePairs:(NSArray<NSString *> *)strs;

//266. Palindrome Permutation (II)

//Given a string, determine if a permutation of the string could form a palindrome.
//
//For example,
//"code" -> False, "aab" -> True, "carerac" -> True.
//
//Hint:
//
//Consider the palindromes of odd vs even length. What difference do you notice?
//Count the frequency of each character.
//If each character occurs even number of times, then it must be a palindrome. How about character which occurs odd number of times?

// 思路: 只需要生成前半段，因为如果是回文的话,后半段是一样的。注意 基数和偶数
//

//9. Palindrome Number
//Determine whether an integer is a palindrome. Do this without extra space.
//
//click to show spoilers.
//
//Some hints:
//Could negative integers be palindromes? (ie, -1)
//
//If you are thinking of converting the integer to string, note the restriction of using extra space.
//
//You could also try reversing an integer. However, if you have solved the problem "Reverse Integer", you know that the reversed integer might overflow. How would you handle such case?
//
//There is a more generic way of solving this problem.


@end
