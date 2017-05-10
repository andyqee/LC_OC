//
//  Graph.h
//  LCOBJC
//
//  Created by ethon_qi on 27/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"

@interface Graph : NSObject

- (UndirectedGraphNode *)cloneGraph:(UndirectedGraphNode *)node;

//Given n nodes labeled from 0 to n - 1 and a list of undirected edges (each edge is a pair of nodes), write a function to check whether these edges make up a valid tree.
//
//For example:
//
//Given n = 5 and edges = [[0, 1], [0, 2], [0, 3], [1, 4]], return true.
//
//Given n = 5 and edges = [[0, 1], [1, 2], [2, 3], [1, 3], [1, 4]], return false.
//
//Hint:
//
//Given n = 5 and edges = [[0, 1], [1, 2], [3, 4]], what should your return? Is this case a valid tree?
//According to the definition of tree on Wikipedia: “a tree is an undirected graph in which any two vertices are connected by exactly one path. In other words, any connected graph without simple cycles is a tree.”
//Note: you can assume that no duplicate edges will appear in edges. Since all edges are undirected, [0, 1] is the same as [1, 0] and thus will not appear together in edges.

- (BOOL)validTree:(NSArray<NSArray<NSNumber *> *> *)edges;

//207. Course Schedule

//Difficulty: Medium
//Contributors: Admin
//There are a total of n courses you have to take, labeled from 0 to n - 1.
//
//Some courses may have prerequisites, for example to take course 0 you have to first take course 1, which is expressed as a pair: [0,1]
//
//Given the total number of courses and a list of prerequisite pairs, is it possible for you to finish all courses?
//
//For example:
//
//2, [[1,0]]
//There are a total of 2 courses to take. To take course 1 you should have finished course 0. So it is possible.
//
//2, [[1,0],[0,1]]
//There are a total of 2 courses to take. To take course 1 you should have finished course 0, and to take course 0 you should also have finished course 1. So it is impossible.
//
//Note:
//The input    prerequisites is a graph represented by a list of edges, not adjacency matrices. Read more about how a graph is represented.

- (BOOL)canFinish:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses;

//210. Course Schedule II
- (NSArray *)findOrder:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses;

// 判断一个图是否是Bipartite

//TODO:
//Alien Dictionary

//  There is a new alien language which uses the latin alphabet. However, the order among letters are unknown to you. You receive a list of words from the dictionary, wherewords are sorted lexicographically by the rules of this new language. Derive the order of letters in this language.
//
//For example,
//Given the following words in dictionary,
//
//[
// "wrt",
// "wrf",
// "er",
// "ett",
// "rftt"
// ]
//The correct order is: "wertf".
//
//Note:
//
//You may assume all letters are in lowercase.
//If the order is invalid, return an empty string.
//There may be multiple valid order of letters, return any one of them is fine.

- (NSString *)alienDictionary:(NSArray<NSString *> *)words;

//329. Longest Increasing Path in a Matrix

//Difficulty: Hard
//Contributors: Admin
//Given an integer matrix, find the length of the longest increasing path.
//
//From each cell, you can either move to four directions: left, right, up or down. You may NOT move diagonally or move outside of the boundary (i.e. wrap-around is not allowed).
//
//Example 1:
//
//nums = [
//        [9,9,4],
//        [6,6,8],
//        [2,1,1]
//        ]
//Return 4
//The longest increasing path is [1, 2, 6, 9].
//
//Example 2:
//
//nums = [
//        [3,4,5],
//        [3,2,6],
//        [2,2,1]
//        ]
//Return 4
//The longest increasing path is [3, 4, 5, 6]. Moving diagonally is not allowed.

- (NSInteger)longestIncreasingPath:(NSArray<NSArray<NSNumber *> *> *)matrix;

@end
