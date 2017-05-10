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
#import "Array.h"
#import "math.h"
#import "DP.h"
#import "Graph.h"
#import "TwoPointers.h"
#import "SlideWindow.h"

void testTree();
void testString();
void testArray();
void testBackTracking();
void testMath();

void testList();
void testSumRange();
void testGraph();
void testTwoPointer();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *ch = @"acbd";
        const char *cs = [ch cStringUsingEncoding:NSASCIIStringEncoding];
        while (*cs) {
            printf("%c", *cs);
            cs++;
        }
        if ([[NSUUID UUID] isEqual:[NSUUID UUID]]) {
            NSLog(@"YES");
        }
        NSInteger a = NSNotFound;
        NSUInteger aa = NSUIntegerMax;
        a = aa;
        
//        NSInteger abc = [@"a" hash] ^ [@"b" hash] ^ [@"c" hash];
//        NSInteger ba = [@"c" hash] ^ [@"b" hash] ^ [@"a" hash];
//        
//        NSString *sb = @"中国hhh";
//        NSString *ab = [@"adfd" substringToIndex:4];
//        
//        for (NSInteger i = 0 ; i < sb.length; i++) {
//            NSLog(@"%@", [sb substringWithRange:NSMakeRange(i, 1)]);
//            NSLog(@"%hu", [sb characterAtIndex:i]);
//        }
//        testTree();
//        testString();
        testArray();
        testBackTracking();
//        testList();
//        testMath();
//        testSumRange();
//        testGraph();
        
        NSMutableSet *set = [NSMutableSet setWithObject:@[@1, @2]];
        [set addObject:@[@1, @2]];

        testTwoPointer();
    }
    return 0;
}

void testTwoPointer()
{
//    TwoPointers *t = [TwoPointers new];
//    [t ]
    SlideWindow *sl = [SlideWindow new];
//    NSInteger s1 = [sl removeDuplicates: [@[@1,@1,@1,@2,@2,@2,@3,@3,@4] mutableCopy]];
//
//    NSInteger s = [sl removeDuplicates2: [@[@1,@1,@1,@2,@2,@2,@3,@3,@4] mutableCopy]];
    
    NSInteger s = [sl longestSubstring:@"eceba" k:2];
    BOOL ss =  [sl containsDuplicate:@[@"A", @"B", @"c",@"B",@"B"] windowSize:2];
    
}

void testGraph()
{
    Graph *g = [Graph new];
    BOOL canfinish = [g canFinish:@[@[@1, @0]] count:2];
    
    NSString *str = [g alienDictionary:@[@"wrt", @"wrf", @"er", @"ett", @"rftt"]];
    
}

void testSumRange()
{
    NSArray *num = @[@(2),@(3),@(-2),@(1),@(6)];
    NumArray2 *segement = [[NumArray2 alloc] initWithNums:num];
    NSInteger aa = [segement sumRange:1 r:2];
    
    [segement update:2 val:2];
    NSInteger a = [segement sumRange:1 r:2];

}

void testMath()
{
    math *m = [math new];
    double res = [m divide:25 divisor:-5];
    double ress = [m divideMethod2:25 divisor:-5];
    
    NSString *s = [m convertToTitle:26];
    
    NSString *ns = [m multiplyStr:@"98009" andStr:@"19809"];
    NSString *ns2 = [m multiplyStr3:@"98009" andStr:@"19809"];
    
    NSInteger ab = [m calculate:@"(1+(4+5+2)-3)+(6+8)"];
    
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
    
    f2.val = 5;
    f2.next = f3;
    
    f3.val = 2;
    f3.next = f4;
    
    f4.val = 1;
    
    ListNode *new = [list deleteDuplicates:f0];
//    NSMutableArray *listArray = [NSMutableArray array];
//    [listArray addObject:f0];
//    [listArray addObject:f2];
    
//    ListNode *hea = [list mergeKList:listArray];
////    [list reorderList:f0];
//    
//    ListNode *head = [list mergeList:f0 withList:f2];
//    BOOL isPalindrome = [list isPalindrome:f0];
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
    
//    NSString *str = [s minWindow:@"ADOBECODEBANC" t:@"AB"];
//    NSArray *words =  @[@"hot", @"dot", @"dog", @"lot", @"log"];
//    for (NSInteger i = 0; i < 5; i++) {
//       NSString *item = [[words objectEnumerator] nextObject];
//        NSLog(@"%@", item);
//    }
//    NSSet *wordList = [NSMutableSet setWithArray: @[@"hot", @"dot", @"dog", @"lot", @"log"]];
//    NSInteger steps = [s ladderLength:@"hit" endWord:@"cog" set:wordList];
//    __unused NSArray *path = [s ladderLength2:@"hit" endWord:@"cog" set:wordList];
//
//    __unused NSInteger steps = [s ladderLength:@"hit" endWord:@"cog" set:wordList];
//    
//    __unused NSInteger hidx = [s hIndex:@[@3, @0, @6, @1, @5]];
    
//    TreeNode *dll = [s convertBT:node];
//    NSString *abc = [s longestPalindrome:@"abcdku0839abvvba"];
    // NSArray *p = [s binaryTreePaths:node];
    // NSArray *q = [s binaryTreePaths_LJSolution:node];
    // NSArray *m = [s zigzagLevelOrder:node];
    
//     [s flattenBTWithNode:node];
    [s flattenBTWithNodeMethod2:node];
    TreeNode *track = node;
    
    while (track) {
        NSLog(@"%ld", (long)track.val);
        track = track.right;
    }
    
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
    
//  
//    NestedListNode *list1 = [NestedListNode new];
//    NestedListNode *list2 = [NestedListNode new];
//    list2.data = @(2);
//    list1.data = @(1);
//    list1.next = list2;
//    
//    NestedListNode *list = [NestedListNode new];
//    list.data = list1;
//    
//    NestedListNode *list3 = [NestedListNode new];
//    list3.data = @(3);
//    list.next = list3;
//    
//    NestedIterator *iter = [[NestedIterator alloc] initWithListNode:list];
//    
//    while ([iter hasNext]) {
//        NSInteger ab = [iter next];
//        NSLog(@"%@", @(ab));
//    }
    
    FlattenArrayIterator *t = [[FlattenArrayIterator alloc] initWithListNode:@[@0, @[@1,@2], @[@3,@4]]];
    while ([t hasNext]) {
        NSNumber *ab = [t next];
        NSLog(@"%@", ab);
    }
}

void testString()
{
    Solution *s = [Solution new];
    TreeNode *test = [TreeNode new];
    [s testFuntionRef:test];
    [s testFuntionReff:&test];

//    NSInteger b = [s numDecodings:@"26782011"];
    NSInteger bo = [s numDecodings_optimizeSpace:@"26782011"];
    NSInteger bob = [s numDecodingsMethod2:@"26782011"];
    NSInteger bobb = [s numDecodingsMethod3:@"26782011"];

//    NSString *b = [s multiplyStr:@"123" andStr:@"123"];
//    NSInteger re = [s compareVersion:@"11." str:@"0.7"];
//    NSString *pp = [s simplifyPath:@"/"];
//    NSString *product = [s multiplyStr:@"0" andStr:@"75"];
//    NSString *sum = [s addBinary:@"111" andStr:@"1"];
//    
//    NSString *str = [s countAndSay_recursive:5];
//    NSString *str_ite = [s countAndSay_iterative:5];
//    NSString *f = [s groupAnagrams:@[@"eat", @"tea", @"tan", @"ate", @"nat", @"bat"]];
//    BOOL re = [s wordBreak:@"leetcccode" set:[NSSet setWithArray:@[@"leet", @"code", @"cc"]]];
//    NSString *res = [s wordBreakFollowup:@"leetcccode" set:[NSSet setWithArray:@[@"leet", @"code", @"cc"]]];

//    NSArray *res = [s wordBreak_2:@"catsanddog" set:[NSSet setWithArray:@[@"cat", @"cats", @"and", @"sand", @"dog"]]];
//    NSArray *ress = [s wordBreak_2:@"aaaa" set:[NSSet setWithArray:@[@"a", @"aa", @"aaa", @"aaaa"]]];
    
    
//    NSInteger i = [s strStr:@"fkdsfsdfskkkk" needle:@"kkk"];
    
//    NSInteger rs = [s maxKilledEnemies:@[@[@"0", @"E", @"0", @"0"], @[@"E", @"0", @"W", @"E"], @[@"0", @"E", @"0", @"0"]]];
    
//    NSInteger maxRetangel4 = [s maximalRectangle:@[@[@"1", @"0", @"1", @"0", @"0"], @[@"1", @"0", @"1", @"1", @"1"], @[@"1", @"1", @"1", @"1", @"1"],  @[@"1", @"0", @"0", @"1", @"0"]]];
//        NSInteger maxRetangel3 = [s maximalRectangle:@[ @[@"1", @"0", @"1", @"1", @"1"], @[@"1", @"1", @"1", @"1", @"1"],  @[@"1", @"0", @"0", @"1", @"0"]]];
//    
//       NSInteger maxRetangel2 = [s maximalRectangle:@[ @[@"1", @"1", @"1", @"1", @"1"],  @[@"1", @"0", @"0", @"1", @"0"]]];
//    __unused NSInteger minCost = [s minCost:@[@[@1, @2, @3], @[@1, @2, @3], @[@1, @2, @3]]];
//    
//    __unused NSInteger minCost2 = [s minCost2:@[@[@1, @2, @3], @[@1, @2, @3], @[@1, @2, @3]]];
////    NSInteger minCost22 = [s minCost2_optmize:@[@[@1, @2, @3], @[@1, @2, @3], @[@1, @2, @3]]];
//    __unused NSInteger minCost222 = [s minCost2_optmize2:@[@[@1, @2, @3], @[@1, @2, @3], @[@1, @2, @3]]];
//    
//    __unused NSInteger stock = [s maxProfitCooldown:@[@1, @2, @3, @0, @2]];
}

void testArray()
{
    Array *s = [Array new];
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
    NSNumber *kth = [s findKthLargest:1 inArray:@[@(1),@(3),@(5),@(0),@(6)]];
    
//    NSMutableArray *arr = [@[@2, @0, @1, @2, @0] mutableCopy];
//    [s sortedColors_bs:arr k:3];
    
//    [s moveZeros_no_order:arr];
//    
//    NSInteger b = [s hammingWeight:11];
    //   input A=[[1, a1], [300, a300], [5000, a5000]]
    //         B=[[100, b100], [300, b300], [1000, b1000]]
//    [s sparseVector:@[@[@(1), @1], @[@300, @300], @[@5000, @5000]] dotVector: @[@[@100, @100], @[@300, @300], @[@1000, @1000]]];
    
//    NSArray *range = [s searchRange:@[@5, @7, @7, @8, @8, @10] target:8];
//    
//    NSInteger d = [s trap:@[@0,@1,@0,@2,@1,@0,@1,@3,@2,@1,@2,@1]];
//    NSInteger dd = [s trap_TwoPointers:@[@0,@1,@0,@2,@1,@0,@1,@3,@2,@1,@2,@1]];
//    
//    NSArray *range2 = [s searchRangeMethod2:@[@5, @7, @7, @8, @8, @10] target:11];
    
    //[
    // [ 1, 2, 3 ],
    // [ 4, 5, 6 ],
    // [ 7, 8, 9 ]
    // ]
//    NSMutableArray *array = [NSMutableArray array];
//    
//    NSInteger a = [s searchInsert:@[@1,@3,@5,@6] target:2];
//    NSInteger b = [s searchInsert:@[@1,@3,@5,@6] target:7];
//    NSInteger c = [s searchInsert:@[@1,@3,@5,@6] target:0];
    
    
//    NSInteger a = [s maxSubArray:@[@-2,@1,@-3,@4,@-1,@2,@1,@-5,@4]];
//    NSInteger b = [s maxSubArrayM2:@[@-2,@1,@-3,@4,@-1,@2,@1,@-5,@4]];
//    RandomPickIndex *pick = [[RandomPickIndex alloc] initWithNums:@[@1,@2,@3,@3,@3]];
//    for (NSInteger i = 0; i < 10; i++) {
//        NSLog(@"%@", [NSString stringWithFormat:@"%ld",[pick pick:3]]);
//    }
    
//    __unused BOOL is = [s increasingTriplet:@[@-2,@1,@-3,@4,@-1,@2,@1,@-5,@4]];
//    __unused BOOL iss = [s increasing:@[@-2,@1,@-3,@4,@-1,@2,@1,@-5,@4] k:3];
    
    NSArray *tasks = [s cooldown:3 withTask:@[@"A",@"A",@"B",@"C",@"B"]];
    NSString *taskss = [[s cooldownOptimizeSpace:4 withTask:@[@"A",@"A",@"B",@"C",@"B"]] componentsJoinedByString:@","];
    NSString *tas = [s cooldownOptimizeSpace_3shua:1 withTask:@[@"A",@"A",@"B",@"C",@"B"]];
    
    NSArray *a = [s mergeKSortedArray_divideConquer:@[@[@1, @8, @9], @[@1, @3, @8, @99], @[@0, @3, @19]]];
    
}

void testBackTracking()
{
    BackTracking *b = [BackTracking new];
    NSMutableArray *sequence = [@[@4, @5, @6, @3, @2, @1] mutableCopy];
    [b nextPermutation: sequence];
    [b previousPermutation: sequence];
//    NSArray *tem =  [b combinationSum_3:16 count:3];

//    NSArray *res = [b permut:@[@(1), @(2), @(3)]];
//    NSArray *ress = [b permut_i:@[@(1), @(2), @(3)]];
    
//    NSArray *re2 = [b permut2:@[@(1), @(1), @(2)]];
//
//    NSArray *com = [b combineNumber:5 k:1];
//    NSArray *com2 = [b combineNumberMethod2:5 k:1];
//    NSArray *com3 = [b combineNumberMethod3:5 k:1];
    
//    NSArray *tem = [b partition:@"aaab"];
    
    NSArray *re = [b letterCombinations:@"12345"];
//    NSArray *re_r = [b letterCombinations_recursive:@"12345"];
//    NSArray *r = [b combinationSum:@[@2,@3,@6,@7,@4] target:7];
//    NSArray *r2 = [b combinationSum_2:@[@10, @1, @2, @7, @6, @1, @5] target:8];

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
    
    __unused BOOL is = [b isMatch:@"abc" withPatten:@"*abc"];
    
    __unused NSArray *res = [b solveNQueens:13];
    
}
