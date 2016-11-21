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

@end
