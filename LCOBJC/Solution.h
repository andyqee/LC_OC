//
//  Solution.h
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface Solution : NSObject

@end

@interface Solution (String)

//13. Roman to Integer
//Difficulty: Easy
//Contributors: Admin
//Given a roman numeral, convert it to an integer.
//
//Input is guaranteed to be within the range from 1 to 3999.

- (NSInteger)romanToInt:(NSString *)str;

//165. Compare Version Numbers

//Difficulty: Easy
//Contributors: Admin
//Compare two version numbers version1 and version2.
//If version1 > version2 return 1, if version1 < version2 return -1, otherwise return 0.
//
//You may assume that the version strings are non-empty and contain only digits and the . character.
//The . character does not represent a decimal point and is used to separate number sequences.
//For instance, 2.5 is not "two and a half" or "half way to version three", it is the fifth second-level revision of the second first-level revision.
//
//Here is an example of version numbers ordering:
//
//0.1 < 1.1 < 1.2 < 13.37

- (NSInteger)compareVersion:(NSString *)str1 str:(NSString *)str2;

// Read N Characters Given Read4

//The API: int read4(char *buf) reads 4 characters at a time from a file.
//
//The return value is the actual number of characters read. For example, it returns 3 if there is only 3 characters left in the file.
//
//By using the read4 API, implement the function int read(char *buf, int n) that reads n characters from the file.
//
//Note:
//The read function will only be called once for each test case

//- (NSInteger)read

//71. Simplify Path
//Difficulty: Medium
//Given an absolute path for a file (Unix-style), simplify it.

//For example,
//path = "/home/", => "/home"
//path = "/a/./b/../../c/", => "/c"

//Did you consider the case where path = "/../"?
//In this case, you should return "/".
//Another corner case is the path might contain multiple slashes '/' together, such as "/home//foo/".
//In this case, you should ignore redundant slashes and return "/home/foo"

- (NSString *)simplifyPath:(NSString *)path;

// 151. Reverse Words in a String
// Difficulty: Medium  
// Given an input string, reverse the string word by word.
// For example,
// Given s = "the sky is blue",
// return "blue is sky the".
// 准确率很低

- (void)reverseWords:(NSMutableString *)str;

//394. Decode String
//Difficulty: Medium
//Contributors: Admin
//Given an encoded string, return it's decoded string.
//
//The encoding rule is: k[encoded_string], where the encoded_string inside the square brackets is being repeated exactly k times. Note that k is guaranteed to be a positive integer.
//
//You may assume that the input string is always valid; No extra white spaces, square brackets are well-formed, etc.
//
//Furthermore, you may assume that the original data does not contain any digits and that digits are only for those repeat numbers, k. For example, there won't be input like 3a or 2[4].
//
//Examples:
//
//s = "3[a]2[bc]", return "aaabcbc".
//s = "3[a2[c]]", return "accaccacc".
//s = "2[abc]3[cd]ef", return "abcabccdcdcdef".
//
//Show Tags

- (NSString *)decodeString:(NSString *)str;

//91. Decode Ways
//Difficulty: Medium
//Contributors: Admin
//A message containing letters from A-Z is being encoded to numbers using the following mapping:
//
//'A' -> 1
//'B' -> 2
//...
//'Z' -> 26
//Given an encoded message containing digits, determine the total number of ways to decode it.
//
//For example,
//Given encoded message "12", it could be decoded as "AB" (1 2) or "L" (12).
//The number of ways decoding "12" is 2.

- (NSInteger)numDecodings:(NSString *)s;
- (NSInteger)numDecodings_optimizeSpace:(NSString *)s;
- (NSInteger)numDecodingsMethod2:(NSString *)s;

// 43. Multiply Strings   
// Difficulty: Medium
// Given two numbers represented as strings, return multiplication of the numbers as a string.

// Note:
// The numbers can be arbitrarily large and are non-negative.
// Converting the input string to integer is NOT allowed.
// You should NOT use internal library such as BigInteger.

- (NSString *)multiplyStr:(NSString *)str1 andStr:(NSString *)str2;

// Given two binary strings, return their sum (also a binary string).
// For example,
// a = "11"
// b = "1"
// Return "100".

- (NSString *)addBinary:(NSString *)str1 andStr:(NSString *)str2;

// 336. Palindrome Pairs   
// Contributors: Admin
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

// 28. Implement strStr()
// Returns the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle;

// 125. Valid Palindrome   
// Difficulty: Easy
// Contributors: Admin
// Given a string, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.

// For example,
// "A man, a plan, a canal: Panama" is a palindrome.
// "race a car" is not a palindrome.

// Note:
// Have you consider that the string might be empty? This is a good question to ask during an interview.

// For the purpose of this problem, we define empty string as valid palindrome.

- (BOOL)isPalindrome:(NSString *)str;

// 68. Text Justification   // Difficulty: Hard
// Given an array of words and a length L, format the text such that each line has exactly L characters and is fully (left and right) justified.
// You should pack your words in a greedy approach; that is, pack as many words as you can in each line. Pad extra spaces ' ' 
// when necessary so that each line has exactly L characters.
// Extra spaces between words should be distributed as evenly as possible. 
// If the number of spaces on a line do not divide evenly between words, the empty slots on the left will be assigned more spaces than the slots on the right.
// For the last line of text, it should be left justified and no extra space is inserted between words.

// For example,
// words: ["This", "is", "an", "example", "of", "text", "justification."]
// L: 16.

// Return the formatted lines as:
// [
//    "This    is    an",
//    "example  of text",
//    "justification.  "
// ]
// Note: Each word is guaranteed not to exceed L in length.

- (NSArray<NSString *> *)fullJustify:(NSArray<NSString *> *)str;

// The count-and-say sequence is the sequence of integers beginning as follows:
// 1, 11, 21, 1211, 111221, ...

// 1 is read off as "one 1" or 11.
// 11 is read off as "two 1s" or 21.
// 21 is read off as "one 2, then one 1" or 1211.
// Given an integer n, generate the nth sequence.

// Note: The sequence of integers will be represented as a string.
// 递归 iterate 两种方式
- (NSString *)countAndSay_recursive:(NSInteger)n;
- (NSString *)countAndSay_iterative:(NSInteger)n;

// 49. Group Anagrams 
// Difficulty: Medium
// Given an array of strings, group anagrams together.

// For example, given: ["eat", "tea", "tan", "ate", "nat", "bat"], 
// Return:

// [
//   ["ate", "eat","tea"],
//   ["nat","tan"],
//   ["bat"]
// ]
// Note: All inputs will be in lower-case.

- (NSArray<NSString *> *)groupAnagrams:(NSArray<NSString *> *)strs;

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

// 273. Integer to English Words   Add to List QuestionEditorial Solution  My Submissions
// Difficulty: Hard
// Convert a non-negative integer to its english words representation. Given input is guaranteed to be less than 231 - 1.

// For example,
// 123 -> "One Hundred Twenty Three"
// 12345 -> "Twelve Thousand Three Hundred Forty Five"
// 1234567 -> "One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven"

- (NSString *)numberToWords:(NSInteger)num;

//127. Word Ladder
//Given two words (beginWord and endWord), and a dictionary's word list, find the length of shortest transformation sequence from beginWord to endWord, such that:
//
//Only one letter can be changed at a time
//Each intermediate word must exist in the word list
//For example,
//
//Given:
//beginWord = "hit"
//endWord = "cog"
//wordList = ["hot","dot","dog","lot","log"]
//As one shortest transformation is "hit" -> "hot" -> "dot" -> "dog" -> "cog",
//return its length 5.
//
//Note:
//Return 0 if there is no such transformation sequence.
//All words have the same length.
//All words contain only lowercase alphabetic characters.

- (NSInteger)ladderLength:(NSString *)beginWord endWord:(NSString *)endWord set:(NSSet<NSString *> *)wordList;

// 126. Word Ladder II 
// Difficulty: Hard
// Contributors: Admin
// Given two words (beginWord and endWord), and a dictionary's word list, find all shortest transformation sequence(s) from beginWord to endWord, such that:

- (NSArray<NSArray<NSString *> *> *)ladderLength2:(NSString *)beginWord endWord:(NSString *)endWord set:(NSSet<NSString *> *)wordList;

@end

@interface Solution (Array)

//274. H-Index QuestionEditorial Solution  My Submissions

//Difficulty: Medium
//Given an array of citations (each citation is a non-negative integer) of a researcher, write a function to compute the researcher's h-index.
//
//According to the definition of h-index on Wikipedia: "A scientist has index h if h of his/her N papers have at least h citations each, and the other N − h papers have no more than h citations each."
//
// For example, given citations = [3, 0, 6, 1, 5], which means the researcher has 5 papers in total and each of them had received 3, 0, 6, 1, 5 citations respectively. 
// Since the researcher has 3 papers with at least 3 citations each and the remaining two with no more than 3 citations each, his h-index is 3.
//
//Note: If there are several possible values for h, the maximum one is taken as the h-index.

- (NSInteger)hIndex:(NSArray<NSNumber *> *)citations;

@end

//Moving Average from Data Stream
//Given a stream of integers and a window size, calculate the moving average of all integers in the sliding window.
//
//For example,
//MovingAverage m = new MovingAverage(3);
//m.next(1) = 1
//m.next(10) = (1 + 10) / 2
//m.next(3) = (1 + 10 + 3) / 3
//m.next(5) = (10 + 3 + 5) / 3



