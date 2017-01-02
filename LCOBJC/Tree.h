//
//  Tree.h
//  LCOBJC
//
//  Created by ethon_qi on 22/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"
#import "Solution.h"

@interface Solution (Tree)

- (NSArray<NSArray<NSNumber *> *> *)zigzagLevelOrder:(TreeNode *)treeNode;

//Flatten Binary Tree to Linked List
//Difficulty: Medium
//Contributors: Admin
//Given a binary tree, flatten it to a linked list in-place.
//If you notice carefully in the flattened tree, each node's right child points to the next node of a pre-order traversal
//For example,
//Given
//
//    1
//   / \
//  2   5
// / \   \
//3   4   6
//The flattened tree should look like:
//1
// \
//  2
//   \
//    3
//     \
//      4
//       \
//        5
//         \
//          6

- (void)flattenBSTWithNode:(TreeNode *)node;

//109. Convert Sorted List to Binary Search Tree
//Given a singly linked list where elements are sorted in ascending order, convert it to a height balanced BST.

- (TreeNode *)sortedListToBST:(ListNode *)listNode;

//108. Convert Sorted Array to Binary Search Tree
//Given an array where elements are sorted in ascending order, convert it to a height balanced BST.

- (TreeNode *)sortedArrayToBST:(NSArray *)nodes;

- (TreeNode *)inorderSuccessor:(TreeNode *)root withTargetNode:(TreeNode *)targetNode;

//Given a binary tree, return the vertical order traversal of its nodes' values. (ie, from top to bottom, column by column).
//If two nodes are in the same row and column, the order should be from left to right.
// Examples:
// Given binary tree [3,9,20,null,null,15,7],
//     3
//    / \
//   9  20
//     /  \
//    15   7
// return its vertical order traversal as:
// [
//   [9],
//   [3,15],
//   [20],
//   [7]
// ]
// Given binary tree [3,9,20,4,5,2,7],
//     _3_
//    /   \
//   9    20
//  / \   / \
// 4   5 2   7
// return its vertical order traversal as:
// [
//   [4],
//   [9],
//   [3,5,2],
//   [20],
//   [7]
// ]

- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal:(TreeNode *)treeNode;
- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal_BFS:(TreeNode *)treeNode;


// 297. Serialize and Deserialize Binary Tree
// Difficulty: Hard
// Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

// Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

// For example, you may serialize the following tree

// 1
// / \
// 2   3
// / \
// 4   5
// as "[1,2,3,null,null,4,5]", just the same as how LeetCode OJ serializes a binary tree. You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.
// Note: Do not use class member/global/static variables to store states. Your serialize and deserialize algorithms should be stateless.

- (NSString *)serialize:(TreeNode *)treeNode;

- (TreeNode *)deserialize:(NSString *)string;

- (NSString *)serialize_R:(TreeNode *)treeNode;

- (TreeNode *)deserialize_I:(NSString *)string;

// 236. Lowest Common Ancestor of a Binary Tree
// Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree.
// According to the definition of LCA on Wikipedia: “The lowest common ancestor is defined between two nodes v and w as the lowest node in T that has both v and w as descendants (where we allow a node to be a descendant of itself).”

//         _______3______
//        /              \
//     ___5__          ___1__
//    /      \        /      \
//    6      _2       0       8
//          /  \
//          7   4
// For example, the lowest common ancestor (LCA) of nodes 5 and 1 is 3. Another example is LCA of nodes 5 and 4 is 5, since a node can be a descendant of itself according to the LCA definition.

- (TreeNode *)lowestCommonAncestor:(TreeNode *)root left:(TreeNode *)p right:(TreeNode *)q;

// 111. Minimum Depth of Binary Tree
// Difficulty: Easy
// Contributors: Admin
// Given a binary tree, find its minimum depth.

// The minimum depth is the number of nodes along the shortest path from the root node down to the nearest leaf node
- (NSInteger)minDepth:(TreeNode *)root;

//104. Maximum Depth of Binary Tree   QuestionEditorial Solution  My Submissions

//Difficulty: Easy
//Contributors: Admin
//Given a binary tree, find its maximum depth.
//
//The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

- (NSInteger)maxDepth:(TreeNode *)root;

// 230. Kth Smallest Element in a BST
// Difficulty: Medium
// Contributors: Admin
// Given a binary search tree, write a function kthSmallest to find the kth smallest element in it.

// Note: 
// You may assume k is always valid, 1 ≤ k ≤ BST's total elements.

// Follow up:
// What if the BST is modified (insert/delete operations) often and you need to find the kth smallest frequently?
//  How would you optimize the kthSmallest routine?

// Hint:

// Try to utilize the property of a BST.
// What if you could modify the BST node's structure?
// The optimal runtime complexity is O(height of BST).

- (NSInteger)kthSmallest:(TreeNode *)root;

// 116. Populating Next Right Pointers in Each Node   
// Difficulty: Medium
// Contributors: Admin
// Given a binary tree

//     struct TreeLinkNode {
//       TreeLinkNode *left;
//       TreeLinkNode *right;
//       TreeLinkNode *next;
//     }
// Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to NULL.

// Initially, all next pointers are set to NULL.

// Note:
// You may only use constant extra space.
// You may assume that it is a perfect binary tree (ie, all leaves are at the same level, and every parent has two children).
// For example,
// Given the following perfect binary tree,
//          1
//        /  \
//       2    3
//      / \  / \
//     4  5  6  7
// After calling your function, the tree should look like:
//          1 -> NULL
//        /  \
//       2 -> 3 -> NULL
//      / \  / \
//     4->5->6->7 -> NULL

- (void)connect:(TreeLinkNode *)root;

// 117. Populating Next Right Pointers in Each Node II

- (void)connect_2:(TreeLinkNode *)root;

// 98. Validate Binary Search Tree
// Difficulty: Medium
// Given a binary tree, determine if it is a valid binary search tree (BST).
// Assume a BST is defined as follows:

- (BOOL)isValidBST:(TreeNode *)root;
- (BOOL)isValidBST_r:(TreeNode *)root;

// Verify Preorder Sequence in Binary Search Tree 验证二叉搜索树的先序序列
//Given an array of numbers, verify whether it is the correct preorder traversal sequence of a binary search tree.
//
//You may assume each number in the sequence is unique.
//
//Follow up:
//Could you do it using only constant space complexity?

//    5
//   / \
//  2   6
// / \
//1   3

// {5, 2, 1, 3, 6}

- (BOOL)verifyPreorder:(NSArray<NSNumber *> *)preorder;

//Given a Binary Tree (Bt), convert it to a Doubly Linked List(DLL). 
//The left and right pointers in nodes are to be used as previous and next pointers respectively in converted DLL. 
//The order of nodes in DLL must be same as Inorder of the given Binary Tree. 
//The first node of Inorder traversal (left most node in BT) must be head node of the DLL.

- (TreeNode *)convertBT:(TreeNode *)node;

// Nested List Weight Sum 嵌套链表权重和
//Given a nested list of integers, return the sum of all integers in the list weighted by their depth.
//
//Each element is either an integer, or a list -- whose elements may also be integers or other lists.
//
//Example 1:
//Given the list [[1,1],2,[1,1]], return 10. (four 1's at depth 2, one 2 at depth 1)
//
//Example 2:
//Given the list [1,[4,[6]]], return 27. (one 1 at depth 1, one 4 at depth 2, and one 6 at depth 3; 1 + 4*2 + 6*3 = 27)

- (NSInteger)depthSum:(NSArray *)nestedList;

// Nested List Weight Sum II
 
// Given a nested list of integers, return the sum of all integers in the list weighted by their depth.

// Each element is either an integer, or a list -- whose elements may also be integers or other lists.

// Different from the previous question where weight is increasing from root to leaf, now the weight is defined from bottom up. i.e., the leaf level integers have weight 1, and the root level integers have the largest weight.

// Example 1:
// Given the list [[1,1],2,[1,1]], return 8. (four 1's at depth 1, one 2 at depth 2)

// Example 2:
// Given the list [1,[4,[6]]], return 17. (one 1 at depth 3, one 4 at depth 2, and one 6 at depth 1; 1*3 + 4*2 + 6*1 = 17)

- (NSInteger)depthSum2:(NSArray *)nestedList;

@end

// Implement an iterator over a binary search tree (BST). Your iterator will be initialized with the root node of a BST.
// Calling next() will return the next smallest number in the BST.
// Note: next() and hasNext() should run in average O(1) time and uses O(h) memory, where h is the height of the tree.

@interface BSTIterator : NSObject

- (BOOL)hasNext;

- (NSInteger)next;

@end

