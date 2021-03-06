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

- (void)flattenBTWithNode:(TreeNode *)node;
- (void)flattenBTWithNodeMethod2:(TreeNode *)node;


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

// 106. Construct Binary Tree from Inorder and Postorder Traversal
//Given inorder and postorder traversal of a tree, construct the binary tree.
//
//Note:
//You may assume that duplicates do not exist in the tree.

- (TreeNode *)buildTree:(NSArray<NSNumber *> *)inorder postorder:(NSArray<NSNumber *> *)postorder;

// 105. Construct Binary Tree from Preorder and Inorder Traversal

- (TreeNode *)buildTree:(NSArray<NSNumber *> *)preorder inorder:(NSArray<NSNumber *> *)inorder;

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

//TODO: check if a binary tree is mirrored，就是与根节点镜像对称

// symmetric tree

- (BOOL)isSymmetric:(TreeNode *)treeNode;

#pragma mark - 下面是非fb面筋 但是加锁的

// 366 Find Leaves of Binary Tree

- (NSArray<NSArray<NSNumber *> *> *)findLeaves:(TreeNode *)node;

//Given a binary tree, find the largest subtree which is a Binary Search Tree (BST), where largest means subtree with largest number of nodes in it.
//
//Note:
//A subtree must include all of its descendants.
//Here's an example:
//10
/// \
//5  15
/// \   \
//1   8   7
//The Largest BST Subtree in this case is the highlighted one.
//The return value is the subtree's size, which is 3.

- (NSInteger)largestBST:(TreeNode *)node;

// 298 Binary Tree Longest Consecutive Sequence

// Given a binary tree, find the length of the longest consecutive sequence path.
//
// The path refers to any sequence of nodes from some starting node to any node in the tree along the parent-child connections.
// The longest consecutive path need to be from parent to child (cannot be the reverse).
//
//For example,
//
//1
// \
//  3
// / \
//2   4
//     \
//      5
//Longest consecutive sequence path is 3-4-5, so return 3.
//
//     2
//      \
//       3
//      /
//     2
//    /
//   1
//Longest consecutive sequence path is 2-3,not3-2-1, so return 2.

- (NSInteger)longestConsecutive:(TreeNode *)treeNode;

// TODO: MJ
// 给出两棵树的前序遍历，寻找第一个值不同的叶节点

//Print first pair of mis-matching leaves (first pair as in in-order) given two pre-order traversal arrays of BSTs.
//
//e.g.
//
//
//For
//     5
//    4   8
//2  4    6  9
//Pre-order Sequence as [5,4,2,4,8,6,9]
//&
//5
//3     8
//2  4   7  9
//Pre-order Sequence2 as [5,3,2,4,8,7,9]
//Print “4, 3”. 如果是叶子结点这里就不是 4，3

// Are the trees of the same size?
// Are the trees is perfectly balanced?

- (NSArray *)firstMissPairLeafBetweenTreeSequence:(NSArray *)nums1 nums2:(NSArray *)nums2;

// behavior + convert string to double   -12.35e2 -> double

// 2 find root to leaf path sum to target, follow up, what if all node's value are positive

//还有一个相关题目：
//Given two (binary) trees, return the first pair of non-matching leaves
//Tree 1: A, B, C, D, E, null, null
//Tree 2: A, D, B
//Output: (E,B)

//Given two pre-order traversal arrays of two binary search tree respectively, find first pair of non-matching leaves.
//Follow Up: If they are general binary trees instead of BSTs, could you solve it? give out your reason.

//124 Binary Tree Maximum Path Sum

//Given a binary tree, find the maximum path sum.
//
//For this problem, a path is defined as any sequence of nodes from some starting node to any node in the tree along the parent-child connections. The path must contain at least one node and does not need to go through the root.
//
//For example:
//Given the below binary tree,
//
//   1
//  / \
// 2   3
//Return 6.

- (NSInteger)maxPathSum:(TreeNode *)treeNode;

// 给一个二叉树， 找出从一个叶节点到另一个叶节点最长的路径，返回路径的长度

- (NSInteger)diameterOfBinaryTree:(TreeNode *)treeNode;

//binary tree to double linked list, follow up, 刚刚产生的double linked list 转化成balanced binary search tree。我之前看面经看到过这道题，当时扫了一眼觉得好麻烦就没有看，结果当小哥说出这道题就傻眼了，好后悔之前没仔细看一眼。事后想好像写出来个bug，但是当时小哥也没看出来，说good enough。可是他拍照了呀。。。回去再看肯定就看出来了。估计要挂就挂在这里了。

- (BOOL)isBalanced:(TreeNode *)root;

@end

// Implement an iterator over a binary search tree (BST). Your iterator will be initialized with the root node of a BST.
// Calling next() will return the next smallest number in the BST.
// Note: next() and hasNext() should run in average O(1) time and uses O(h) memory, where h is the height of the tree.

@interface BSTIterator : NSObject

- (instancetype)initWithTreeNode:(TreeNode *)treeNode;

- (BOOL)hasNext;

- (NSInteger)next;

@end

//341. Flatten Nested List Iterator

//Difficulty: Medium
//Contributors: Admin
//Given a nested list of integers, implement an iterator to flatten it.
//
//Each element is either an integer, or a list -- whose elements may also be integers or other lists.
//
//Example 1:
//Given the list [[1,1],2,[1,1]],
//
//By calling next repeatedly until hasNext returns false, the order of elements returned by next should be: [1,1,2,1,1].
//
//Example 2:
//Given the list [1,[4,[6]]],
//
//By calling next repeatedly until hasNext returns false, the order of elements returned by next should be: [1,4,6].

//

@interface NestedIterator : NSObject

- (instancetype)initWithListNode:(NestedListNode *)treeNode;

- (BOOL)hasNext;

- (NSInteger)next;

@end

@interface FlattenArrayIterator : NSObject

- (instancetype)initWithListNode:(NSArray *)nums;

- (BOOL)hasNext;

- (NSNumber *)next;

@end
