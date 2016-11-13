//
//  main.m
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Solution.h"
#import "TreeNode.h"

void testTree();
void testString();
void testArray();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testTree();
        testString();
        testArray();
        
        
    }
    return 0;
}

void testTree() {
    
//     1
//    / \
//   2   3
//      / \
//     5   4
    
    TreeNode *left = [[TreeNode alloc] init];
    left.val = 2;

    TreeNode *rightRight = [[TreeNode alloc] init];
    rightRight.val = 4;
    
    TreeNode *rightLeft = [[TreeNode alloc] init];
    rightLeft.val = 5;
    
    TreeNode *right = [[TreeNode alloc] init];
    right.val = 3;
    right.right = rightRight;
    right.left = rightLeft;
    
    TreeNode *node = [[TreeNode alloc] init];
    node.val = 1;
    node.left = left;
    node.right = right;
    
    Solution *s = [Solution new];
    // NSArray *p = [s binaryTreePaths:node];
    // NSArray *q = [s binaryTreePaths_LJSolution:node];
    // NSArray *m = [s zigzagLevelOrder:node];
    
    // [s flattenBSTWithNode:node];
    
//    NSArray *temp = [s binaryTreeVerticalOrderTraversal_BFS:node];
//    NSArray *b = [s binaryTreeVerticalOrderTraversal:node];
//    
//    NSString *seriaze = [s serialize:node];
//    TreeNode *deSeriaze = [s deserialize:seriaze];
//    
//    NSString *seriaze_r = [s serialize_R:node];
//    TreeNode *des_r = [s deserialize_I:seriaze_r];
}

void testString()
{
    Solution *s = [Solution new];
//    NSString *product = [s multiplyStr:@"0" andStr:@"75"];
//    NSString *sum = [s addBinary:@"111" andStr:@"1"];
//    
//    NSString *str = [s countAndSay_recursive:5];
//    NSString *str_ite = [s countAndSay_iterative:5];
    NSString *f = [s groupAnagrams:@[@"eat", @"tea", @"tan", @"ate", @"nat", @"bat"]];
}

void testArray()
{
    Solution *s = [Solution new];
//    NSInteger re = [s searchInRotatedArray:@[@(3), @(1)] target:1];
//    NSArray *res = [s threeSum:@[@(-1), @(0), @(1), @(2), @(-1), @(-4)]];
//    
//    NSArray *va = [s intersectionOfTwoArray:@[@(1), @(2),@(2),@(1)] andArray2:@[@(2),@(2)]];
//    NSArray *va2 = [s intersectionOfTwoArrayUnique:@[@(1), @(2),@(2),@(1)] andArray2:@[@(2),@(2)]];
    

    NSInteger pro = [s maxProduct:@[@(2),@(3),@(-2),@(0),@(121212121.2)]];
    NSInteger po = [s maxProduct_OptimizeSpace:@[@(2),@(3),@(-2),@(0),@(6)]];
    NSInteger min = [s minimumSizeSubArraySum:6 nums:@[@(2),@(3),@(2),@(0),@(6)]];
    
}
