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
#import "BackTracking.h"
#import "List.h"
#import "Tree.h"

void testTree();
void testString();
void testArray();
void testBackTracking();

void testList();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testTree();
        testString();
        testArray();
        testBackTracking();
        testList();
        
//        NSComparisonResult rst = [@"中国" localizedCompare:@"武汉"];
//        NSComparisonResult rst1 = [@"武汉" localizedCompare:@"中国"];
//        NSComparisonResult rst2 = [@"武汉" localizedCompare:@"萝卜"];
//        NSComparisonResult rst3 = [@"萝卜" localizedCompare:@"哎啊"];

    }
    return 0;
}

void testList()
{
    List *list = [List new];
    ListNode *f0 = [ListNode new];
    ListNode *f1 = [ListNode new];
    ListNode *f2 = [ListNode new];
    ListNode *f3 = [ListNode new];
    ListNode *f4 = [ListNode new];
    
    f0.val = 1;
    f0.next = f1;
    
    f1.val = 2;
    f1.next = f2;
    
    f2.val = 2;
    f2.next = f3;
    
    f3.val = 5;
    f3.next = f4;
    
    f4.val = 5;
    
    ListNode *new = [list deleteDuplicates:f0];
//    NSMutableArray *listArray = [NSMutableArray array];
//    [listArray addObject:f0];
//    [listArray addObject:f2];
    
//    ListNode *hea = [list mergeKList:listArray];
////    [list reorderList:f0];
//    
//    ListNode *head = [list mergeList:f0 withList:f2];
    
}

void testTree() {
    
//     2
//    / \
//   1   4
//      / \
//     3   5
    
    TreeNode *left = [[TreeNode alloc] init];
    left.val = 1;

    TreeNode *rightRight = [[TreeNode alloc] init];
    rightRight.val = 5;
    
    TreeNode *rightLeft = [[TreeNode alloc] init];
    rightLeft.val = 3;
    
    TreeNode *right = [[TreeNode alloc] init];
    right.val = 4;
    right.right = rightRight;
    right.left = rightLeft;
    
    TreeNode *node = [[TreeNode alloc] init];
    node.val = 2;
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
//    BOOL r = [s isValidBST:node];
//    BOOL rr = [s isValidBST_r:node];

}

void testString()
{
    Solution *s = [Solution new];
//    NSInteger b = [s numDecodings:@"26782011"];
//    NSInteger bo = [s numDecodings_optimizeSpace:@"26782011"];
//    NSInteger bob = [s numDecodingsMethod2:@"26782011"];
//    NSString *b = [s multiplyStr:@"123" andStr:@"123"];
//    NSInteger re = [s compareVersion:@"11." str:@"0.7"];
//    NSString *pp = [s simplifyPath:@"/"];
//    NSString *product = [s multiplyStr:@"0" andStr:@"75"];
//    NSString *sum = [s addBinary:@"111" andStr:@"1"];
//    
//    NSString *str = [s countAndSay_recursive:5];
    NSString *str_ite = [s countAndSay_iterative:5];
//    NSString *f = [s groupAnagrams:@[@"eat", @"tea", @"tan", @"ate", @"nat", @"bat"]];
//    BOOL re = [s wordBreak:@"leetcccode" set:[NSSet setWithArray:@[@"leet", @"code", @"cc"]]];
//    NSArray *res = [s wordBreak_2:@"catsanddog" set:[NSSet setWithArray:@[@"cat", @"cats", @"and", @"sand", @"dog"]]];
//    NSArray *ress = [s wordBreak_2:@"aaaa" set:[NSSet setWithArray:@[@"a", @"aa", @"aaa", @"aaaa"]]];
    
    
    NSInteger i = [s strStr:@"fkdsfsdfskkkk" needle:@"kkk"];
}

void testArray()
{
    Solution *s = [Solution new];
//    NSInteger re = [s searchInRotatedArray:@[@(3), @(1)] target:1];
//    NSArray *res = [s threeSum:@[@(-1), @(0), @(1), @(2), @(-1), @(-4)]];
//    
//    NSArray *va = [s intersectionOfTwoArray:@[@(1), @(2),@(2),@(1)] andArray2:@[@(2),@(2)]];
//    NSArray *va2 = [s intersectionOfTwoArrayUnique:@[@(1), @(2),@(2),@(1)] andArray2:@[@(2),@(2)]];
    

//    NSInteger pro = [s maxProduct:@[@(2),@(3),@(-2),@(0),@(121212121.2)]];
//    NSInteger po = [s maxProduct_OptimizeSpace:@[@(2),@(3),@(-2),@(0),@(6)]];
//    NSInteger min = [s minimumSizeSubArraySum:6 nums:@[@(2),@(3),@(2),@(0),@(6)]];
//    NSInteger r = [s threeSumCloset:@[@(-2),@(4),@(-2),@(0),@(1)] target:3];
//    
//    NSArray *re = [s productExceptSelf:@[@(2), @(3), @(9), @(1)]];
//    NSNumber *kth = [s findKthLargest:2 inArray:@[@(2),@(3),@(5),@(0),@(6)]];
}

void testBackTracking()
{
    BackTracking *b = [BackTracking new];
    NSMutableArray *arry = [@[@(0), @(2)] mutableCopy];
    [arry insertObject:@(1) atIndex:2];
//    NSArray *tem =  [b combinationSum_3:16 count:3];

//    NSArray *res = [b permut:@[@(1), @(2), @(3)]];
//    NSArray *ress = [b permut_i:@[@(1), @(2), @(3)]];
    
//    NSArray *re2 = [b permut2:@[@(1), @(1), @(2)]];
//
//    NSArray *com = [b combineNumber:5 k:1];
//    NSArray *com2 = [b combineNumberMethod2:5 k:1];
//    NSArray *com3 = [b combineNumberMethod3:5 k:1];
    
    NSArray *tem = [b partition:@"aaab"];
    
//    NSArray *re = [b letterCombinations:@"12345"];
//    NSArray *re_r = [b letterCombinations_recursive:@"12345"];
    NSArray *r = [b combinationSum:@[@2,@3,@6,@7,@4] target:7];
    NSArray *r2 = [b combinationSum_2:@[@10, @1, @2, @7, @6, @1, @5] target:8];

    WordDictionary *dic = [WordDictionary new];
    [dic addWord:@"bad"];
    [dic addWord:@"dad"];
    [dic addWord:@"mad"];
    [dic search:@"pad"];
    [dic search:@"..d"];
//    BOOL a = [dic search:@"b.."];
    
//    NSArray *res = [b removeInvalidParentheses:@"()())()"];
//    
//    NSArray *subset = [b subSets:@[@(1), @(2), @(3), @(4), @(5)]];
//    NSArray *subSet_r = [b subSet_r:@[@(1), @(2), @(3), @(4), @(5)]];
//    
//    NSArray *subset_i = [b subSets_iterate:@[@(1), @(2), @(3), @(4), @(5)]];
//    NSArray *subsetD = [b subSetsWithDup:@[@(1), @(2), @(2)]];
//    NSArray *pa= [b generateParenthesis:3];
//    NSInteger bes = [b maxProfit:@[@(7), @(1), @(5), @(3), @(6), @(4)]];
//    
//    BOOL a = [b isOneEditDistance:@"a" withStr:@""];
//    BOOL bb = [b isOneEditDistance:@"a" withStr:@"b"];
//    BOOL c = [b isOneEditDistance:@"a" withStr:@"ac"];
//    BOOL d = [b isOneEditDistance:@"abc" withStr:@"ac"];
//    BOOL dd = [b isOneEditDistance:@"abcc" withStr:@"ac"];


}
