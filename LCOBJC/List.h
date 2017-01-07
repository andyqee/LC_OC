//
//  List.h
//  LCOBJC
//
//  Created by andy on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface List : NSObject

// 143. Reorder List   
// Difficulty: Medium
// Contributors: Admin
// Given a singly linked list L: L0→L1→…→Ln-1→Ln,
// reorder it to: L0→Ln→L1→Ln-1→L2→Ln-2→…

// You must do this in-place without altering the nodes' values.

// For example,
// Given {1,2,3,4}, reorder it to {1,4,2,3}.

- (void)reorderList:(ListNode *)listNode;

// 23. Merge k Sorted Lists   

// Difficulty: Hard
// Contributors: Admin
// Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.

- (ListNode *)mergeKList:(NSArray<ListNode *> *)listNodeArray;

- (ListNode *)mergeList:(ListNode *)node1 withList:(ListNode *)node2;

//141. Linked List Cycle   QuestionEditorial Solution  My Submissions
//Difficulty: Easy
//Contributors: Admin
//Given a linked list, determine if it has a cycle in it.
//
//Follow up:
//Can you solve it without using extra space?

- (BOOL)hasCycle:(ListNode *)node;

//142. Linked List Cycle II   QuestionEditorial Solution  My Submissions

//Difficulty: Medium
//Given a linked list, return the node where the cycle begins. If there is no cycle, return null.
//
//Note: Do not modify the linked list.
//
//Follow up:
//Can you solve it without using extra space?

- (ListNode *)detectNode;

//83. Remove Duplicates from Sorted List   QuestionEditorial Solution  My Submissions
//Difficulty: Easy
//Contributors: Admin
//Given a sorted linked list, delete all duplicates such that each element appear only once.
//
//For example,
//Given 1->1->2, return 1->2.
//Given 1->1->2->3->3, return 1->2->3.

- (ListNode *)deleteDuplicates:(ListNode *)listNode;

// // 138. Copy List with Random Pointer   QuestionEditorial Solution  My Submissions

// // Difficulty: Hard
// // Contributors: Admin
// // A linked list is given such that each node contains an additional random pointer 
// // which could point to any node in the list or null.
// // Return a deep copy of the list.

 - (RandomListNode *)copyRandomList:(RandomListNode *)head;
// https://leetcode.com/discuss/questions/oj/copy-list-with-random-pointer

//234. Palindrome Linked List   
//Contributors: Admin
//Given a singly linked list, determine if it is a palindrome.
//
//Follow up:
//Could you do it in O(n) time and O(1) space?

- (BOOL)isPalindrome:(ListNode *)node;

//19. Remove Nth Node From End of List   Add to List QuestionEditorial Solution  My Submissions

//Difficulty: Easy
//Contributors: Admin
//Given a linked list, remove the nth node from the end of list and return its head.
//
//For example,
//
//Given linked list: 1->2->3->4->5, and n = 2.
//
//After removing the second node from the end, the linked list becomes 1->2->3->5.
//Note:
//Given n will always be valid.
//Try to do this in one pass.

- (ListNode *)removeNthFromEnd:(ListNode *)head n:(NSInteger)n;

@end


