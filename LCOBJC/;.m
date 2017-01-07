//
//  Tree.m
//  LCOBJC
//
//  Created by ethon_qi on 22/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Tree.h"

@implementation Solution (Tree)

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

// 关键： tailNode 刚开始传 nil
- (TreeNode *)sortedListToBST:(ListNode *)listNode
{
    // if(listNode == nil) {  // 这个corner case 可以忽略
    //     return nil;
    // }
    return [self doSortedListToBST:listNode andTailNode:nil]; 
}

// S: log(n) T : nlong(n)
// dived and conquer, 快慢指针

- (TreeNode *)doSortedListToBST:(ListNode *)prev andTailNode:(ListNode *)tailNode
{
    if(prev == tailNode) {
        return nil;
    }
    
    ListNode *slow = prev;
    ListNode *fast = prev.next;
    
    while (fast && fast.next) {
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

#pragma mark - sortedArrayToBST

- (TreeNode *)sortedArrayToBST:(NSArray *)nodes
{
    if(nodes == nil) {
        return nil;
    }
    return [self sortedArrayToBST:nodes withLeftIndex:0 andRightIndex:[nodes count] - 1];
}

- (TreeNode *)sortedArrayToBST:(NSArray<NSNumber *> *)nodes withLeftIndex:(NSUInteger)leftIdx andRightIndex:(NSUInteger)rightIdx
{
    if (leftIdx > rightIdx) { //这里没有 =
        return nil;
    }
    
    NSUInteger mid = (rightIdx - leftIdx) / 2 + leftIdx;
    
    TreeNode *node = [[TreeNode alloc] init];
    node.val = nodes[mid].integerValue;
    node.left = [self sortedArrayToBST:nodes withLeftIndex:leftIdx andRightIndex:mid - 1]; // 注意下标
    node.right = [self sortedArrayToBST:nodes withLeftIndex:mid + 1 andRightIndex:rightIdx];
    
    return node;
}

#pragma mark - sortedArrayToBST [R]

//关键:使用额外的stack记录这个node所需要的array的index。需要学会这种技巧
//需要push to stack with left index and right index
//inorder过程中, 判断left mid - 1 以及 right 和 mid + 1 的关系，因为这个是新的sub 区间
//最小宽度是1

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
            [rightIndexStack addObject:@(mid - 1)];
        }
        if(right >= mid + 1){
            node.right = [TreeNode new];
            [stack addObject:node.right];
            [leftIndexStack addObject:@(mid + 1)];
            [rightIndexStack addObject:@(right)];
        }
    }
    return node;
}

#pragma mark - VerticalOrderTraversal [R]

//第一次
//最终vertical order 输出结果，并不意味着在 traversal 的过程中 是vertical，因为traversal 只有DFS 和BFS，所以还是用
//这两种方法，只是在traversal 的过程中 记录node位置信息、与值的对应关系
//关键：就是要找到最左边的 node，也就是要记住最小值
//根据输出的 每个vertical 的顺序 所以使用的是 inorder

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
            [array addObject:@(rootNode.val)];  // 这里不能直接加到 dictionary 里面，因为这个方法返回为nil，不要fan这种低级错误
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

#pragma mark - inorder successor [R]
//method 1: inorder traversal
//method 2: 利用BST 的性质

//开始用的逐个遍历的办法 不好，比较慢
//关键点：
// 1. edge case
// FIXME: 2. 第二种情况的处理，如果root.val > targetNode.val, 这是successor 要么是node，要么是在left sub

// TODO: Fellow up
// 如果是要求 predecessor 如何处理,
// root.val >= targetNode.val [self inorderSuccessor.root.left]
// else  [self inorderSuccessor:root.right ...] 此时如果返回空，说明此时的node 为predecessort

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

//TODO: 迭代版本！
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
//TODO: 如果不用占位符怎么弄？

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

// TODO:
// 106. Construct Binary Tree from Inorder and Postorder Traversal

//     2
//    / \
//   1   4
//  ／   / \
//  0   3   5

// inorder :  (0, 1), 2, (3, 4, 5)  然后 根据preorder 获得的root 推断出 2左边的是left subtree 2 右边的是right subtree
// 如何处理 3,4,5
// 是不是必须得有 inorder ?

// preorder : 2, (1, 0,) (4, 3, 5)  特点 是第一个点是 root
// postorder: (0, 1), (3, 5, 4,) 2  特点 最后一个点是 root，在找到一个root之后，改如何做呢？倒数第二个也是右子树的tree
// TODO: 关键: 如何拆分post tree？？。 关键就是通过 inorder可以得知道leftsubtree 的长度，用这个长度推算出postorder 的left tree 的区间
// TODO: 6个参数，

//root.left = myBuildTree(inorder, instart, position - 1,
//                        postorder, poststart, poststart + position - instart - 1);
//root.right = myBuildTree(inorder, position + 1, inend,
//                         postorder, poststart + position - instart, postend - 1);

// FIXME: Fellow up

//If we are given preorder and postorder traversal, can we construct the binary tree? Why or why not?
//FIXME: 不行， 也就是无法确定是左孩子还是右孩子，没有inorder，构建的树不唯一,

//Given preorder, inorder, and postorder traversal, how can you verify if these traversals are referring to the exact same binary tree?
// 有inorder 才行

//Remember from my earlier post: Serialization/Deserialization of a Binary Tree? It is trivial to see this as an alternative method to serialize/deserialize a binary tree. :)

- (TreeNode *)buildTree:(NSArray<NSNumber *> *)inorder postorder:(NSArray<NSNumber *> *)postorder
{
    return [self buildTree:inorder
                    inleft:0
                   inright:inorder.count - 1
                 postorder:postorder
                  postleft:0
                 postright:postorder.count - 1];
}

- (TreeNode *)buildTree:(NSArray<NSNumber *> *)inorder inleft:(NSInteger)inleft inright:(NSInteger)inright postorder:(NSArray<NSNumber *> *)postorder postleft:(NSInteger)postleft postright:(NSInteger)postright
{
    //when break;
    if(inleft > inright){
        return nil;
    }
    NSInteger val = postorder[postright].integerValue;
    NSInteger index = [inorder indexOfObject:@(val)];
    TreeNode *node = [TreeNode new];
    node.val = val;
    
    node.left = [self buildTree:inorder
                         inleft:inleft
                        inright:index - 1
                      postorder:postorder
                       postleft:postleft
                      postright:postleft + (index - 1 - inleft)];
    
    node.right = [self buildTree:inorder
                          inleft:index + 1
                         inright:inright
                       postorder:postorder
                        postleft:postleft + (index - inleft)
                       postright:postright - 1];
    
    return node;
}

// 105. Construct Binary Tree from Preorder and Inorder Traversal

// 区别在于index preorder 拆分的index 和前面这道题类似
//- (TreeNode *)buildTree:(NSArray<NSNumber *> *)preorder inorder:(NSArray<NSNumber *> *)inorder
//{
//    
//}

#pragma mark - 236. Lowest Common Ancestor of a Binary Tree [R]

// 注意这里不是BST 。如果是BST 会简单很多, 可以通过比较大小的办法

// worst case O(n)
// TODO: 思路:技巧性比较强, 首先分别验证root.left & root.right 递归调用，判断返回值是否都不为空，如果都找到说明root就是,
// 这个技术点不太好理解。画出三种情况的图就清晰了，这种方法技巧性还是太强
// A & B
// edge case : 三种情况,
// TODO: 关键: 如果 root.left 有通往p 的路径，并且 root.right 有通往另一个的路径，
// 就说明此时的root 是LCA, 这是需要把路径上的点 通过递归调用往上传

// FIXME: 如果是多个children 如何处理？

//Time Complexity: Time complexity of the above solution is O(n) as the method does a simple tree traversal in bottom up fashion.
//Note that the above method assumes that keys are present in Binary Tree. If one key is present and other is absent, then it returns the present key as LCA (Ideally should have returned NULL).
//We can extend this method to handle all cases by passing two boolean variables v1 and v2. v1 is set as true when n1 is present in tree and v2 is set as true if n2 is present in tree.

- (TreeNode *)lowestCommonAncestor:(TreeNode *)root left:(TreeNode *)p right:(TreeNode *)q
{
    // If either n1 or n2 matches with root's key, report
    // the presence by returning root (Note that if a key is
    // ancestor of other, then the ancestor key becomes LCA
    if(!root || p == root || q == root){
        return root;
    }
    // Look for keys in left and right subtrees
    TreeNode *leftNode = [self lowestCommonAncestor:root.left left:p right:q];
    TreeNode *rightNode = [self lowestCommonAncestor:root.right left:p right:q];
    
    // If both of the above calls return Non-NULL, then one key
    // is present in once subtree and other is present in other,
    // So this node is the LCA
    
    if(leftNode && rightNode) return root; // 中     
    if(leftNode){  //下面这几行代码被最后一行给替换了
        return leftNode;
    }
    if(rightNode){
        return rightNode;
    }
    return nil;
//    return leftNode ? leftNode : rightNode;
}

// FIXME: consider two special case, left subtree and right subtree may be nil
// 画出两种情况的树结构图
// 复杂度 O(n)

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
    [self _kthSmallest:k node:root result:&res]; //这里用到了传递
    return res;
}

//1. inorder traversal 左中右

// Fellow up:
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
    while(p){
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
    return NSNotFound;
}

//inorder
#pragma mark - inorder 需要默写一遍

// 下面这个方法中包含的 两个while 循环可以合并成一个, 也就是如下结构isValidBSTMergedWhile

- (BOOL)isValidBST:(TreeNode *)root
{
    if(root == nil){
        return YES;
    }
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    TreeNode *p = root;
    // 1.push left 不要停
    while(p){
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

- (BOOL)isValidBSTMergeWhile:(TreeNode *)root
{
    if(root == nil){
        return YES;
    }
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    TreeNode *p = root;
    // 1.push left 不要停
    
    TreeNode *prev = nil;
    while ([stack count] || p) { //2.判断stack 是否为空
        while(p){
            [stack addObject:p];
            p = p.left;
        }
        
        p = [stack lastObject];
        [stack removeLastObject];
        
        if(prev != nil && p.val <= prev.val){  //task部分
            return NO;
        }
        prev = p; //update prev;
        //3.右边处理是关键
        p = p.right; //
    }
    return YES;
}

- (BOOL)isValidBST_r:(TreeNode *)root {
    return [self isValidBST_recursive:root];
}

//这里用到了静态全局变量, 还有一种方法是传递最小值和最大值来确定边界的，也是非常巧妙的

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

//116. Populating Next Right Pointers in Each Node, 很少在面筋中碰到
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

// TODO这个preorder,可以用来解决这个: Flatten Binary Tree to Linked List
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


// iterative
// 这道题也可以bfs ，也可以dfs
// 这里使用使用 fbs ，正好就可以 level 来计算权值，安层遍历的套路也可以用在这个地方
// 这道题目，需要注意的是 queue 的首次add 到queue 是把 nesteList还是将其元素压入， 对应的level 的初始值不同

- (NSInteger)depthSumI:(NSArray *)nestedList
{
    NSInteger sum = 0;
    NSMutableArray<NSArray *> *queue = [NSMutableArray array];
    NSInteger level = 0; //
    [queue addObject:nestedList];
    
    while([queue count]){
        NSInteger count = [queue count];
        level++;
        for(NSInteger i = 0; i < count; i++){
            NSArray *nList = [queue firstObject];
            [queue removeObjectAtIndex:0];
            
            for(NSArray *item in nList){ //网上还有另外一种形式的bfs，取决于首次add 到queueu里面的是啥
                if([item isKindOfClass:[NSNumber class]]){
                    sum += ((NSNumber *)item).integerValue * level;
                } else {
                    [queue addObject:item];
                }
            }
        }
    }
    
    return sum;
}

- (NSInteger)depthSumR:(NSArray *)nestedList depth:(NSInteger)depth
{
    NSInteger sum = 0;
    if([nestedList count] == 0){
        return sum;
    }
    for(NSArray *item in nestedList){
        if([item isKindOfClass:[NSNumber class]]){
            sum += ((NSNumber *)item).integerValue * depth;
        } else {
            sum += [self depthSumR:item depth:depth + 1];
        }
    }
    return sum;
}

- (NSInteger)height:(NSArray *)nestedList
{
    NSInteger height = 1;
    for(NSArray *item in nestedList){
        if([item isKindOfClass:[NSNumber class]]){

        } else {
            height = MAX(height, 1 + [self height:item]);
        }
    }
    return height;
}

// 解法：1. 获取总的深度，然后用解决上面第一题的方式，只是在算权重的时候 用height - level
// 解法：2. DFS，首先计算出高度，然后用第一题的方式，只是在传递weight 的时候 改成 weight - 1

//- (NSInteger)depthSum2:(NSArray *)nestedList
//{
//
//}

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

