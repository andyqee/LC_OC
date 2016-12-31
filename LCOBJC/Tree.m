//
//  Tree.m
//  LCOBJC
//
//  Created by ethon_qi on 22/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Tree.h"

@implementation Solution (Tree)

//对题目的意思
// Space = O(nlgn)
// TODO: 这个问题的时间复杂度的分析 T =
// my solution
// 这里需要注意的 “->” 写的顺序
// 这种枚举的题目,也可以用 backtracking 的方法

- (NSArray<NSString *> *)binaryTreePaths:(TreeNode *)node
{
    if(node == nil) {
        return nil; // 这里是直接返回 nil，还是空数组，需要确认下
    }
    NSMutableArray *rest = [NSMutableArray array];
    
    if(node.left != nil) {
        NSArray *leftSubRes = [self binaryTreePaths:node.left];
        for (NSString *subRes in leftSubRes) {
            [rest addObject: [NSString stringWithFormat:@"%ld->%@", (long)node.val, subRes]];
        }
    }
    if(node.right != nil) {
        NSArray *rightSubRes = [self binaryTreePaths:node.right];
        for (NSString *subRes in rightSubRes) {
            [rest addObject: [NSString stringWithFormat:@"%ld->%@", (long)node.val, subRes]];
        }
    }
    if(node.right == nil && node.left == nil) {
        [rest addObject: [NSString stringWithFormat:@"%ld", (long)node.val]];
    }
    return rest;
}

// From web
- (NSArray<NSString *> *)binaryTreePaths_LJSolution:(TreeNode *)node
{
    if(!node) {
        return nil;
    }
    NSMutableArray *rest = [NSMutableArray array];
    [self binaryTreePath:node prefixStr:[@"" mutableCopy] array:rest];
    return rest;
}

//T = O(n) 多少种情况

- (void)binaryTreePath:(TreeNode *)node prefixStr:(NSMutableString *)prefixStr array:(NSMutableArray *)array
{
    if(!node.left && !node.right) { // 1: backtracking 枚举的终止条件
        [prefixStr appendString:[NSString stringWithFormat:@"%ld", (long)node.val]];
        [array addObject:prefixStr];
    }
    if(node.left) {
        NSMutableString *temp = [prefixStr mutableCopy]; //option 1: 这里可以优化成
        [temp appendString:[NSString stringWithFormat:@"%ld->", (long)node.val]];
        [self binaryTreePath:node.left prefixStr:temp array:array];
    }
    if(node.right) {
        NSMutableString *temp = [prefixStr mutableCopy]; //option 2:
        [temp appendString:[NSString stringWithFormat:@"%ld->", (long)node.val]];
        [self binaryTreePath:node.right prefixStr:temp array:array];
    }
}

//103. Binary Tree Zigzag Level Order Traversal   QuestionEditorial Solution  My Submissions
//Difficulty: Medium
//Given a binary tree, return the zigzag level order traversal of its nodes' values. (ie, from left to right, then right to left for the next level and alternate between).
//
//For example:
//Given binary tree [3,9,20,null,null,15,7],
//   3
//  / \
// 9  20
//   /  \
//  15   7
//return its zigzag level order traversal as:
//[
// [3],
// [20,9],
// [15,7]
// ]

// 解法1，level order traversal with an state to indicate if need reverse current sub array
// 注意 if／ while 判断条件 是否有低级错误
// while 的区域是不是有低级错误

- (NSArray<NSArray<NSNumber *> *> *)zigzagLevelOrder:(TreeNode *)treeNode
{
    if(treeNode == nil) {
        return nil;
    }
    
    NSMutableArray<TreeNode *> *queue = [NSMutableArray array];
    NSMutableArray *res = [NSMutableArray array];
    [queue addObject:treeNode];
    
    BOOL needReverse = false;
    while ([queue count] > 0) {
        NSUInteger count = queue.count;
        NSMutableArray *subArray = [NSMutableArray array];
        
        for(NSUInteger idx = 0; idx < count; idx++) {
            TreeNode *node = [queue firstObject];
            [queue removeObjectAtIndex:0];
            [subArray addObject:@(node.val)];
            
            if(node.left != nil) {
                [queue addObject:node.left];
            }
            if(node.right != nil) {
                [queue addObject:node.right];
            }
        }
        if(needReverse) {
            [res addObject:[subArray reverseObjectEnumerator].allObjects];//数组倒叙
        } else {
            [res addObject:[subArray copy]];
        }
        needReverse = !needReverse;
    }
    return [res copy];
}

//99. Recover Binary Search Tree
//Difficulty: Hard

//Two elements of a binary search tree (BST) are swapped by mistake.
//Recover the tree without changing its structure.
//A solution using O(n) space is pretty straight forward. Could you devise a constant space solution?
// 只是值发生变化 inorder traversal

// - (void)recoverTree:(TreeNode *)treeNode
// {
//     [self traversal:treeNode];
//     swap(firstNode, secondNode);
// }

// - (void)traversal:(TreeNode *)treeNode
// {
//     if(!treeNode){
//         return;
//     }
//     [self traversal:treeNode.left];
//     if(prevNode && firstNode == nil && prevNode.val >= treeNode.val){
//         firstNode = prevNode.val;
//     }
//     if(prevNode && firstNode && prevNode.val >= treeNode.val){
//         secondNode = treeNode.val;
//     }
//     prevNode = treeNode;
//     [self traversal:treeNode.right];
// }
// pre order traversal

- (void)flattenBSTWithNode:(TreeNode *)node
{
    if (node == nil) {
        return;
    }
    [self doFlattenBSTWithNode:node];
}
//swift 版跑过

- (TreeNode *)doFlattenBSTWithNode:(TreeNode *)node
{
    //4 cases
    if(node.left == nil && node.right == nil) {
        return node;
    }
    if (node.left && node.right) {
        TreeNode *leftSubTreeEndeNode = [self doFlattenBSTWithNode:node.left];
        TreeNode *rightSubTreeEndeNode = [self doFlattenBSTWithNode:node.right];
        leftSubTreeEndeNode.right = node.right;
        node.right = node.left;
        node.left = nil;
        
        return rightSubTreeEndeNode;
    }
    
    if (node.left) {
        node.right = node.left;
        node.left = nil;
    }
    return [self doFlattenBSTWithNode:node.right];
}

//- (TreeNode *)flattenBSTWithNode_I:(TreeNode *)node
//{
//    while (node) {
//        if (node.left && node.right) {
//        
//        }
//    }
//    
//}
// 这种写法算法的复杂度比较高 nlogn
//var flatten = function(root) {
//    while (root) {
//        if (root.left && root.right) {
//            var t = root.left;
//            while (t.right) {
//                t = t.right;
//            }
//            t.right = root.right;
//        }
//        
//        if (root.left) {
//            root.right = root.left;
//            root.left = null;
//        }
//        root = root.right;
//    }
//};

// 这也是一种实现 https://discuss.leetcode.com/topic/5783/accepted-simple-java-solution-iterative

// inorder traversal

//public void flatten(TreeNode root) {
//    if (root == null) return;
//    Stack<TreeNode> stk = new Stack<TreeNode>();
//    stk.push(root);
//    while (!stk.isEmpty()){
//        TreeNode curr = stk.pop();
//        if (curr.right!=null)
//            stk.push(curr.right);
//        if (curr.left!=null)
//            stk.push(curr.left);
//        if (!stk.isEmpty())
//            curr.right = stk.peek();
//        curr.left = null;  // dont forget this!!
//    }
//}

- (TreeNode *)sortedListToBST:(ListNode *)listNode
{
    if(listNode == nil) {
        return nil;
    }
    return [self doSortedListToBST:listNode andTailNode:nil];
}

// S: log(n) T : nlong(n)
// dived and conquer

- (TreeNode *)doSortedListToBST:(ListNode *)prev andTailNode:(ListNode *)tailNode
{
    if(prev == tailNode) {
        return nil;
    }
    
    ListNode *slow = prev;
    ListNode *fast = prev;
    
    while (fast.next && fast.next.next) {
        slow = slow.next;
        fast = fast.next.next;
    }
    
    TreeNode *left = [self doSortedListToBST:prev andTailNode:slow];
    TreeNode *right = [self doSortedListToBST:slow.next andTailNode:tailNode];
    
    TreeNode *root = [TreeNode new];
    root.left = left;
    root.right = right;
    
    return root;
}

- (TreeNode *)sortedArrayToBST:(NSArray *)nodes
{
    if(nodes == nil) {
        return nil;
    }
    return [self sortedArrayToBST:nodes withLeftIndex:0 andRightIndex:[nodes count] - 1];
}

- (TreeNode *)sortedArrayToBST:(NSArray<NSNumber *> *)nodes withLeftIndex:(NSUInteger)leftIdx andRightIndex:(NSUInteger)rightIdx
{
    if (leftIdx > rightIdx) {
        return nil;
    }
    
    NSUInteger mid = (rightIdx - leftIdx) / 2 + leftIdx;
    
    TreeNode *node = [[TreeNode alloc] init];
    node.val = nodes[mid].integerValue;
    node.left = [self sortedArrayToBST:nodes withLeftIndex:leftIdx andRightIndex:mid - 1]; // 注意下标
    node.right = [self sortedArrayToBST:nodes withLeftIndex:mid + 1 andRightIndex:rightIdx];
    
    return node;
}

- (TreeNode *)sortedArrayToBST_i:(NSArray<NSNumber *> *)nodes
{
    if (!nodes.count) {
        return nil;
    }
    //需要额外信息的可以用多个stack
    TreeNode *node = [TreeNode new];
    
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    [stack addObject:node];
    
    NSMutableArray<NSNumber *> *leftIndexStack = [NSMutableArray array];
    [leftIndexStack addObject:@0];
    
    NSMutableArray<NSNumber *> *rightIndexStack = [NSMutableArray array];
    [rightIndexStack addObject:@(nodes.count -1)];
    
    while ([stack count]> 0) {
        TreeNode *node = [stack lastObject];
        [stack removeLastObject];
        
        NSInteger left = [leftIndexStack lastObject].integerValue;
        [leftIndexStack removeLastObject];
        NSInteger right = [rightIndexStack lastObject].integerValue;
        [rightIndexStack removeLastObject];
        
        NSInteger mid = (right - left) / 2 + left;
        node.val = nodes[mid].integerValue;

        if(left <= mid - 1){
            node.left = [TreeNode new];
            [stack addObject:node.left];
            [leftIndexStack addObject:@(left)];
            [leftIndexStack addObject:@(mid - 1)];
        }
        if(right >= mid + 1){
            node.right = [TreeNode new];
            [stack addObject:node.right];
            [leftIndexStack addObject:@(mid + 1)];
            [leftIndexStack addObject:@(right)];
        }
    }
    return node;
}

//第一次
- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal:(TreeNode *)treeNode
{
    NSMutableArray *result = [NSMutableArray array];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger minV = 0;
    [self doDFSOrderTraversal:treeNode degree:0 withDic:dic andMin:&minV];

    while(dic[@(minV)]) {
        [result addObject: dic[@(minV)]];
        minV += 1;
    }
    return result;
}

//DFS 
- (void)doDFSOrderTraversal:(TreeNode *)rootNode degree:(NSInteger)degree withDic:(NSMutableDictionary<NSNumber *, NSMutableArray *> *)dic andMin:(NSInteger *)minV;
{
    if (!dic[@(degree)]) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@(rootNode.val)];  // 这里不能直接加到 dictionary 里面，因为这个方法返回为nil，不要烦这种低级错误
        dic[@(degree)] = array;
    } else {
        [dic[@(degree)] addObject:@(rootNode.val)];
    }

    if (rootNode.left) {
        *minV = MIN(*minV, degree - 1);
        [self doDFSOrderTraversal:rootNode.left degree:degree - 1 withDic:dic andMin:minV];
    }
    if (rootNode.right) {
        [self doDFSOrderTraversal:rootNode.right degree:degree + 1 withDic:dic andMin:minV];
    }
}

//BFS
- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal_BFS:(TreeNode *)treeNode
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger minV = 0;
    
    [self doBFSOrderTraversal:treeNode degree:0 withDic:dic andMin:&minV];
    
    while(dic[@(minV)]) {
        [result addObject: dic[@(minV)]];
        minV += 1;
    }
    return result;
}

- (void)doBFSOrderTraversal:(TreeNode *)rootNode degree:(NSInteger)degree withDic:(NSMutableDictionary<NSNumber *, NSMutableArray *> *)dic andMin:(NSInteger *)minV;
{
    if (rootNode == nil) {
        return;
    }

    NSMutableArray *queue = [NSMutableArray array];
    NSMutableArray<NSNumber *> *degreeQueue = [NSMutableArray array];

    [queue addObject:rootNode];
    [degreeQueue addObject:@(degree)];  //在traversal 的过程中,如果需要额外的信息，可以再建立一个queue。来存同步的数据，或者可以用一个wapper class 来封装一下

    while([queue count] > 0){
        TreeNode *rootNode = [queue firstObject];
        [queue removeObjectAtIndex:0];

        NSInteger currentDegree = [degreeQueue firstObject].integerValue;
        [degreeQueue removeObjectAtIndex:0];

        if(!dic[@(currentDegree)]) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@(rootNode.val)];  // 这里不能直接加到 dictionary 里面，因为这个方法返回为nil，不要烦这种低级错误
            dic[@(currentDegree)] = array;
        } else {
            [dic[@(currentDegree)] addObject:@(rootNode.val)];
        }
        
        if(rootNode.left) {
            [queue addObject:rootNode.left];
            [degreeQueue addObject:@(currentDegree - 1)];
            *minV = MIN(*minV, currentDegree - 1);
        }
        if(rootNode.right) {
            [queue addObject:rootNode.right];
            [degreeQueue addObject:@(currentDegree + 1)];
        }
    }
}

//开始用的逐个遍历的办法 不好，比较慢

- (TreeNode *)inorderSuccessor:(TreeNode *)root withTargetNode:(TreeNode *)targetNode
{
    if(root == nil || targetNode == nil) {
        return nil;
    }
    
    if (root.val <= targetNode.val) {
        return [self inorderSuccessor:root.right withTargetNode:targetNode];
    } else {
        TreeNode *node = [self inorderSuccessor:root.left withTargetNode:targetNode];
        return node ?: root; // 这个方法真的太巧妙了。
    }
}

- (TreeNode *)inorderSuccessor_I:(TreeNode *)root withTargetNode:(TreeNode *)targetNode
{
    TreeNode *succ;
    while(root != nil) {
        if(targetNode.val < root.val) {
            succ = root;
            root = root.left;
        } else {
            root = root.right;
        }
    }
    return succ;
}

// 我用的这种解决方法是 BFS iterate 的方法

- (NSString *)serialize:(TreeNode *)treeNode
{
    if(treeNode == nil) {
        return nil;
    }
    NSMutableString *mStr = [NSMutableString string];
    //level order traversal use ",",inorder to split the string later
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject: treeNode];

    while([queue count]) {
        TreeNode *treeNode = [queue firstObject];
        [queue removeObjectAtIndex:0];

        if([treeNode isEqual:[NSNull null]]) {
            [mStr appendString:@"*,"];
            continue;
        } else {
            [mStr appendString: [@(treeNode.val) description]];
            [mStr appendString: @","];
        }

        if(treeNode.left) {
            [queue addObject:treeNode.left];
        } else {
            [queue addObject:[NSNull null]];
        }
        if(treeNode.right) {
            [queue addObject:treeNode.right];
        } else {
            [queue addObject:[NSNull null]];
        }
    }
    [mStr deleteCharactersInRange:NSMakeRange(mStr.length - 1, 1)]; // delete the last ','

    return mStr;
}

- (TreeNode *)deserialize:(NSString *)string
{
    if([string length] == 0) {
        return nil;
    }
    
    NSArray *treeArray = [string componentsSeparatedByString:@","];
    NSMutableArray *queue = [NSMutableArray array];

    NSUInteger idx = 0;
    TreeNode *treeNode = [[TreeNode alloc] init];
    treeNode.val = ((NSNumber *)treeArray[idx]).integerValue;

    [queue addObject:treeNode];

    while(idx < [treeArray count] && [queue count] != 0) {
        TreeNode *treeNode = [queue firstObject];
        [queue removeObjectAtIndex:0];

        idx += 1;
        NSString *leftItem = treeArray[idx];

        if(![leftItem isEqualToString:@"*"]) {
            TreeNode *leftNode = [TreeNode new];
            leftNode.val = leftItem.integerValue;
            treeNode.left = leftNode;
            [queue addObject:leftNode];
        }

        idx += 1;
        NSString *rightItem = treeArray[idx]; // 这里要注意 idx 变了得获取idx 下标对应的新的值
        if(![rightItem isEqualToString:@"*"]) {
            TreeNode *rightNode = [TreeNode new];
            rightNode.val = rightItem.integerValue;
            treeNode.right = rightNode;
            [queue addObject:rightNode];
        }
    }
    return treeNode;
}

- (NSString *)serialize_R:(TreeNode *)treeNode
{
    if(treeNode == nil) {
        return nil;
    }
    NSMutableString *str = [NSMutableString string];
    [self doSerialize:treeNode str:str];
    return [str copy];
}

// we can pass in mutableString for avoiding alot of string allocations

//version on 

// - (NSString *)doSerialize:(TreeNode *)treeNode
// {
//     NSMutableString *mStr = [NSMutableString string];
//     [mStr appendString: [@(treeNode.val) description];

//     if(treeNode.left) {
//         [mStr appendString:@","];
//         [mStr appendString:[self doSerialize:treeNode.left]];
//     } else {
//         [mStr appendString:@","];
//         [mStr appendString:@"*"];
//     }

//     if(treeNode.right) {
//         [mStr appendString:@","];
//         [mStr appendString:[self doSerialize:treeNode.right]];
//     } else {
//         [mStr appendString:@","];
//         [mStr appendString:@"*"];
//     }
//     return mStr;
// }

// 这个实现和C++ 不同，C++ 可以把nil 放到array 里面

- (void)doSerialize:(TreeNode *)treeNode str:(NSMutableString *)mStr
{
    if(treeNode == nil) {
        [mStr appendString:@"*,"];
    } else {
        [mStr appendString:[@(treeNode.val) description]];
        [mStr appendString:@","];
        [self doSerialize:treeNode.left str:mStr];
        [self doSerialize:treeNode.right str:mStr];
    }
}

- (TreeNode *)deserialize_I:(NSString *)string
{
    if ([string length] == 0)
    {
        return nil;
    }

    NSArray *treeArray = [string componentsSeparatedByString:@","];
    
    NSUInteger idx = 0;
    return [self doDeSerialize:treeArray idx:&idx];
}

- (TreeNode *)doDeSerialize:(NSArray *)strArray idx:(NSUInteger *)idx
{
    NSString *item = strArray[*idx];
    *idx = *idx + 1;
    if([item isEqualToString:@"*"]) 
    {
        return nil;
    }

    TreeNode *node = [TreeNode new];
    node.val = item.integerValue;
    node.left = [self doDeSerialize:strArray idx:idx];
    node.right = [self doDeSerialize:strArray idx:idx]; //这里的index 不对 不是 + 2 ,因为这里是dfs，等走到right 这个地方的 偏移已经很大了.所以改成reference
    return node;
}

// 注意这里不是BST 。如果是BST 会简单很多
// worst case O(n)

- (TreeNode *)lowestCommonAncestor:(TreeNode *)root left:(TreeNode *)p right:(TreeNode *)q
{
    if(!root || p == root || q == root){
        return root;
    }

    TreeNode *leftNode = [self lowestCommonAncestor:root.left left:p right:q];
    TreeNode *rightNode = [self lowestCommonAncestor:root.right left:p right:q];
    if(leftNode && rightNode) return root;
    if(leftNode){  //下面这几行代码被最后一行给替换了
        return leftNode;
    }
    if(rightNode){
        return rightNode;
    }
    return nil;
//    return leftNode ? leftNode : rightNode;
}

- (NSInteger)minDepth:(TreeNode *)root
{
    if(root == nil){
        return 0;
    }
    if(root.left == nil) return [self minDepth:root.right] + 1; //注意这里需要检查其中一个为nil 的情况，是到叶子的距离
    if(root.right == nil) return [self minDepth:root.left] + 1;

    return 1 + MIN([self minDepth:root.left], [self minDepth:root.right]);
}

- (NSInteger)maxDepth:(TreeNode *)root
{
    if(root == nil){
        return 0;
    }
    return 1 + MAX([self maxDepth:root.left], [self maxDepth:root.right]);
}


//BST
//Fellow up:

- (NSInteger)kthSmallest:(NSInteger)k node:(TreeNode *)root 
{
    NSInteger res;
    [self _kthSmallest:k node:root result:&res];
    return res;
}

//1. inorder traversal 
//Fellow up:
// If the BST node's structure can be modified. We let each node maintain the number of nodes of its left subtree. 
// Therefore, for each node, we can compare k with the number of its subtree. //

- (void)_kthSmallest:(NSInteger)k node:(TreeNode *)root result:(NSInteger *)res
{
    if(root.left){
        [self _kthSmallest:k node:root.left result:res];
    }
    if(k == 1){
        *res = root.val;
        return;
    }
    k--;
    if(root.right){
        [self _kthSmallest:k node:root.right result:res];
    }
}


// iterate 版本

- (NSInteger)kthSmallest_i:(NSInteger)k node:(TreeNode *)root
{
    if(root == nil){
        return NO;
    }
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    TreeNode *p = root;
    // 1.push left 不要停
    while(p != nil){
        [stack addObject:p];
        p = p.left;
    }
    
    NSInteger count = 0;
    while ([stack count]) { //2.判断stack 是否为空
        p = [stack lastObject];
        [stack removeLastObject];

        count++; // task 部分
        if (count == k) {
            return p.val;
        }
        //3.右边处理是关键
        p = p.right; //
        while (p) {
            [stack addObject:p];//4.先push的后处理
            p = p.left;
        }
    }
    return YES;
}

//inorder
#pragma mark - inorder

- (BOOL)isValidBST:(TreeNode *)root
{
    if(root == nil){
        return YES;
    }
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    TreeNode *p = root;
    // 1.push left 不要停
    while(p != nil){
        [stack addObject:p];
        p = p.left;
    }
    
    TreeNode *prev = nil;
    while ([stack count]) { //2.判断stack 是否为空
        p = [stack lastObject];
        [stack removeLastObject];
        
        if(prev != nil && p.val <= prev.val){  //task部分
            return NO;
        }   
        prev = p; //update prev;
        //3.右边处理是关键
        p = p.right; //
        while (p) {
            [stack addObject:p];//4.先push的后处理
            p = p.left;
        }
    }
    return YES;
}

- (BOOL)isValidBST_r:(TreeNode *)root {
    return [self isValidBST_recursive:root];
}

static TreeNode *prev = nil;
- (BOOL)isValidBST_recursive:(TreeNode *)root
{
    if(root == nil){
        return YES;
    }
    if (![self isValidBST_recursive:root.left]) {
        return NO;
    }
    if(prev && root.val <= prev.val){
        return NO;
    }
    prev = root;
    if(![self isValidBST_recursive:root.right]){
        return NO;
    }
    return YES;
}

//116 
//traversal level by level

//when the ith level node is connected ,we can use it to connnect the i+1 children
//traversal from left to right, we need to store the left most element in each level. 

- (void)connect:(TreeLinkNode *)root
{
    if(root == nil){
        return;
    }
    TreeLinkNode *prev = root;
    TreeLinkNode *curr = nil;

    while(prev.left){
        curr = prev; //1.scan level
        while(curr){
            curr.left.next = curr.right; // 2.left right 相连
            if(curr.next){ //3. 对点 2 进行举例子
                curr.right.next = curr.next.left;
            }
            curr = curr.next;
        }
        prev = prev.left;
    }
}

// 有点复杂了
- (void)connect_2:(TreeLinkNode *)root
{

}


//Verify Preorder Sequence in Binary Search Tree

//方法：
// scan
//https://discuss.leetcode.com/topic/21217/java-o-n-and-o-1-extra-space

//public boolean verifyPreorder(int[] preorder) {
//    int low = Integer.MIN_VALUE;
//    Stack<Integer> path = new Stack();
//    for (int p : preorder) {
//        if (p < low)
//            return false;
//        while (!path.empty() && p > path.peek())
//            low = path.pop();
//        path.push(p);
//    }
//    return true;
//}

//- (BOOL)verifyPreorder:(NSArray<NSNumber *> *)preorder
//{
//    NSInteger low = NSIntegerMin;
//    NSMutableArray<NSNumber *> *stack = [NSMutableArray array];
//    
//    for(NSNumber *item in preorder){
//        
//        while ([stack count] != 0 && [stack lastObject].integerValue > low) {
//            low =
//        }
//    }
    
//}

// 这个preorder,可以用来解决这个: Flatten Binary Tree to Linked List

- (NSArray *)preorder:(TreeNode *)treeNode
{
    NSMutableArray *preorder = [NSMutableArray array];
    if(treeNode){
        return preorder;
    }
    NSMutableArray *stack = [NSMutableArray array];
    [stack addObject:treeNode];
    
    while ([stack count]) {
        TreeNode *node = [stack lastObject];
        [preorder addObject: @(node.val)];
        [stack removeLastObject];
        
        if(node.right){ //先右边
            [stack addObject:node.right];
        }
        if (node.left) {
            [stack addObject:node.left];
        }
        //we can get prev node by call [stack lastObject]
    }
    return [preorder copy];
}
// Alternative Solution:
// You will think that it works magically, but in fact it is doing a reversed pre-order traversal. 前序遍历reversed版本
// That is, the order of traversal is a node, then its right child followed by its left child. This yields post-order traversal in reversed order. Using a second stack, we could reverse it back to the correct order.

- (NSArray *)postorderTwoStack:(TreeNode *)treeNode
{
    if(!treeNode){
        return nil;
    }
    NSMutableArray *stack = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray array];

    [stack addObject:treeNode];
    while ([stack count]) {
        TreeNode *node = [stack lastObject];
        [result addObject: @(node.val)];
        [stack removeLastObject];

        if (node.left) {
            [stack addObject:node.left];
        }
        if(node.right){ //先右边
            [stack addObject:node.right];
        }
        //we can get prev node by call [stack lastObject]
    }
    return [[result reverseObjectEnumerator] allObjects];
}

// 分三种情况讨论
// We use a prev variable to keep track of the previously-traversed node. Let’s assume curr is the current node that’s on top of the stack. When prev is curr‘s parent, we are traversing down the tree. In this case, we try to traverse to curr‘s left child if available (ie, push left child to the stack). If it is not available, we look at curr‘s right child. If both left and right child do not exist (ie, curr is a leaf node), we print curr‘s value and pop it off the stack.

// If prev is curr‘s left child, we are traversing up the tree from the left. 
// We look at curr‘s right child. If it is available, then traverse down the right child (ie, push right child to the stack), otherwise print curr‘s value and pop it off the stack.
// If prev is curr‘s right child, we are traversing up the tree from the right. In this case, we print curr‘s value and pop it off the stack.

- (NSArray *)postorderOneStack:(TreeNode *)treeNode
{
    if(!treeNode){
        return nil;
    }
    NSMutableArray *stack = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray array];
    [stack addObject:treeNode];
    TreeNode *prevNode;

    while ([stack count]) {
        TreeNode *node = [stack lastObject]; // 这里先不pop        
        // we are traversing down the tree
        if(prevNode && (prevNode.left == node || prevNode.right == node)){
            if(node.left){
                [stack addObject:node.left];
            } else if(node.right){
                [stack addObject:node.right];
            } else {
                [stack removeLastObject]; // 这两行代码可以在三个if else 中，可以提取出来
                [result addObject:node];
            }
        } else if(node.left == prevNode){ // we are traversing up the tree from the left
            if(node.right){
                [stack addObject:node.right];
            } else {
                [result addObject:node];
                [stack removeLastObject];
            }
        } else if(node.right == prevNode){         // we are traversing up the tree from the right
                [result addObject:node];
                [stack removeLastObject]; 
        }    
        //we can get prev node by call [stack lastObject]
        prevNode = node;
    }
    return [result copy];
}

// 1. If left subtree exists, process the left subtree
// …..1.a) Recursively convert the left subtree to DLL.
// …..1.b) Then find inorder predecessor of root in left subtree (inorder predecessor is rightmost node in left subtree).
// …..1.c) Make inorder predecessor as previous of root and root as next of inorder predecessor.
// 2. If right subtree exists, process the right subtree (Below 3 steps are similar to left subtree).
// …..2.a) Recursively convert the right subtree to DLL.
// …..2.b) Then find inorder successor of root in right subtree (inorder successor is leftmost node in right subtree).
// …..2.c) Make inorder successor as next of root and root as previous of inorder successor.
// 3. Find the leftmost node and return it (the leftmost node is always head of converted DLL).

- (TreeNode *)convertBT:(TreeNode *)node
{
    if(!node){
        return nil;
    }
    TreeNode *newHead = node;
    if(node.left){
        newHead = [self convertBT:node.left];
        //find inorder predecessor of root
        TreeNode *rightMostOfLeftSubtree = [self rightMostNode:node.left];
        node.left = rightMostOfLeftSubtree;
        rightMostOfLeftSubtree.right = node;
    }
    if(node.right){
        TreeNode *rightHead = [self convertBT:node.right];
        node.right = rightHead;
        rightHead.left = node;
    }
    return newHead;
}

- (TreeNode *)rightMostNode:(TreeNode *)node
{
    if(!node){
        return nil;
    }
    if(node.right){
        return [self rightMostNode:node.right];
    }
    return node;
}

@end

@interface BSTIterator()
@property (nonatomic, strong) TreeNode *treeNode;
@property (nonatomic, strong) NSMutableArray<TreeNode *> *stack;

@end

@implementation BSTIterator 

//inorder traversal 
//我想到的时候traversal一遍，然后建立一个数组，然后遍历这个数组O(n)，但是空间不符合

- (instancetype)initWithTreeNode:(TreeNode *)treeNode
{
    if(self = [super init]){
        _treeNode = treeNode;
        _stack = [NSMutableArray array];
        [self pushNode:treeNode];
    }
    return self;
}

- (BOOL)hasNext
{
    return [self.stack count] == 0;
}

- (NSInteger)next
{
    TreeNode *node = [self.stack lastObject];
    [self.stack removeLastObject];
    NSInteger val = node.val;
    //push right
    [self pushNode:node.right];
    return val;
}

- (void)pushNode:(TreeNode *)node
{
    TreeNode *p = node;
    while(p){
        [self.stack addObject:p];
        p = p.left;
    }
}

- (NSInteger)preOrderNext
{
    TreeNode *node = [self.stack lastObject];
    [self.stack removeLastObject];
    NSInteger val = node.val;
    if(node.right){
        [self.stack addObject:node.right];
    }
    
    if(node.left){
        [self.stack addObject:node.left];
    }
    
    return val;
}

@end

