//
//  Tree.m
//  LCOBJC
//
//  Created by ethon_qi on 22/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Tree.h"

@interface Wrapper : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSNumber *c;

- (instancetype)initWithIndex:(NSInteger)index c:(NSNumber *)c;

@end

@implementation Wrapper

- (instancetype)initWithIndex:(NSInteger)index c:(NSNumber *)c
{
    if(self = [super init]){
        _index = index;
        _c = c;
    }
    return self;
}

@end

@implementation Solution (Tree)

//103. Binary Tree Zigzag Level Order Traversal
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

// inorder traversal
// FIXME: 这题的关键是:
// 1. double pointer
// 2. 在更新firstNode 的时候需要添加firstNode 为空的检查，如果忘记添加，那么secondNode 那个case 也会跑到这里
// 3. second case 的时候添加对first的检查, 只有firstObejct 找到了，才能找second

//Two elements of a binary search tree (BST) are swapped by mistake.
//Recover the tree without changing its structure.
//A solution using O(n) space is pretty straight forward. Could you devise a constant space solution?
// 只是值发生变化 inorder traversal

// - (void)recoverTree:(TreeNode *)treeNode
// {
//     [self traversal:treeNode];
//     swap(firstNode, secondNode);
// }

- (void)traversal:(TreeNode *)treeNode firstNode:(TreeNode **)firstNode secondNode:(TreeNode **)secondNode previousNode:(TreeNode **)previous
{
    if(!treeNode) return;
    [self traversal:treeNode.left firstNode:firstNode secondNode:secondNode previousNode:previous];
    
    if(*previous && *firstNode == nil && (*previous).val >= treeNode.val){// 注意这里要检 *firstNode == nil
        *firstNode = *previous;
    }
    if(*previous && *firstNode != nil && (*previous).val >= treeNode.val){ // 检查 *firstNnode ！= nil
        *secondNode = treeNode;
        //下面为优化的时候想到的, 虽然时间复杂度一样，但是减少不必要的计算
        NSInteger temp = (*firstNode).val;
        (*firstNode).val = (*secondNode).val;
        (*secondNode).val = temp;
        return; //terminate
    }
    *previous = treeNode;
    [self traversal:treeNode.right firstNode:firstNode secondNode:secondNode previousNode:previous];
}

#pragma mark - Flatten Binary Tree to Linked List

// preorder traversal
// If you notice carefully in the flattened tree, each node's right child points to the next node of a pre-order traversal
//swift 版跑过

// divde && conquer
// 这种写法算法的复杂度比较高 nlogn

//- (TreeNode *)doFlattenBTWithNodeDeprecated:(TreeNode *)node
//{   //4 cases
//    if(node.left == nil && node.right == nil) {
//        return node;
//    }
//    if (node.left && node.right) {
//        TreeNode *leftSubTreeEndeNode = [self doFlattenBTWithNodeDeprecated:node.left];
//        TreeNode *rightSubTreeEndeNode = [self doFlattenBTWithNodeDeprecated:node.right];
//        leftSubTreeEndeNode.right = node.right;
//        node.right = node.left;
//        node.left = nil;
//        
//        return rightSubTreeEndeNode;
//    }
//    
//    if (node.left) {
//        node.right = node.left;
//        node.left = nil;
//    }
//    return [self doFlattenBTWithNodeDeprecated:node.right];
//}

// 这也是一种实现 https://discuss.leetcode.com/topic/5783/accepted-simple-java-solution-iterative

//preorder traversal
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

// 思路: use prev to track to prevous node in preorder, when we traversal , we set the previous node.right with curr node
// 上面的办发更好

- (void)flattenBTWithNodeMethod2:(TreeNode *)node
{
    if (!node) {
        return;
    }
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    [stack addObject:node];
    TreeNode *prev = nil;
    while ([stack count]) {
        TreeNode *curr = [stack lastObject];
        [stack removeLastObject];
        
        if(curr.right){
            [stack addObject:curr.right];
        }
        if(curr.left){
            [stack addObject:curr.left];
        }
        if(prev){
            prev.right = curr;
            prev.left = nil;
        }
        prev = curr;
    }
}

//FIXME: 方法2递归
// 关键:1. 递归，将preorder 序列中的prev 用二级指针track, 从而起到改变他的目的
// 2. 需要将node.right 保存在一个变量里, 要不然就覆盖掉了

- (void)flattenBTWithNode:(TreeNode *)node
{
    TreeNode *prev = nil;
    [self doflattenBTWithNode:node prev:&prev];
}

- (void)doflattenBTWithNode:(TreeNode *)node prev:(TreeNode **)prev
{
    if(!node){
        return;
    }
    if(*prev){
        (*prev).right = node;
        (*prev).left = nil;
    }
    *prev = node;
    TreeNode *right = node.right; //需要把right 存起来, 要不然在下一个递归的时候，此时的node.right 下次递归stack上的prev, 在设置prev的时候，就覆盖掉了
    if(node.left){
        [self doflattenBTWithNode:node.left prev:prev];
    }
    if(right){
        [self doflattenBTWithNode:right prev:prev];
    }
}

//public void flatten(TreeNode root) {
//    flatten(root,null);
//}
//private TreeNode flatten(TreeNode root, TreeNode pre) {
//    if(root==null) return pre;
//    pre=flatten(root.right,pre);
//    pre=flatten(root.left,pre);
//    root.right=pre;
//    root.left=null;
//    pre=root;
//    return pre;
//}

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

#pragma mark - convert binary Search Tree to doubly linked list

#pragma mark - 117 Convert Sorted List to Binary Search Tree

// 关键： tailNode 刚开始传 nil
- (TreeNode *)sortedListToBST:(ListNode *)listNode
{
    return [self doSortedListToBST:listNode andTailNode:nil]; 
}
// S: log(n) T : nlong(n)
- (TreeNode *)doSortedListToBST:(ListNode *)prev andTailNode:(ListNode *)tailNode
{
    if(prev == tailNode) {
        return nil;
    }
    
    ListNode *slow = prev;
    ListNode *fast = prev.next;
    
//    while (fast && fast.next) { //FIXME:这里忽视了一个严重的问题，就是获取midle node 的时候，没有考虑到终点的问题。
//        slow = slow.next;
//        fast = fast.next.next;
//    }
    while (fast != tailNode && fast.next != tailNode) {
        slow = slow.next;
        fast = fast.next.next;
    }
    TreeNode *left = [self doSortedListToBST:prev andTailNode:slow];
    TreeNode *right = [self doSortedListToBST:slow.next andTailNode:tailNode];
    
    TreeNode *root = [TreeNode new];
    root.left = left;
    root.right = right;
    root.val = slow.val;
    
    return root;
}

#pragma mark - 117 Convert Sorted List to Binary Search Tree - bottom up

// 很难想！太巧妙了。
- (TreeNode *)sortedListToBST_bottomUP:(ListNode *)listNode
{
    NSInteger count = [self lengthOfList:listNode];
    ListNode *iterator = listNode;
    return [self sortedListToBST_bottomUP:&iterator count:count];
}

// 按照left root right的顺序,

- (TreeNode *)sortedListToBST_bottomUP:(ListNode **)currNode count:(NSInteger)count
{
    //什么时候终止？
    if(count <= 0){
        return nil;
    }
    
    TreeNode *left = [self sortedListToBST_bottomUP:currNode count:count / 2];
    
    TreeNode *node = [TreeNode new];
    node.val = (*currNode).val;
    *currNode = (*currNode).next; // when the left recursive call finish, the curr is in the center of list
    
    TreeNode *right = [self sortedListToBST_bottomUP:currNode count:count - count / 2 - 1];
    node.left = left;
    node.right = right;
    
    return node;
}

- (NSInteger)lengthOfList:(ListNode *)node
{
    if(!node){
        return 0;
    }
    return 1 + [self lengthOfList:node.next];
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

        if(left <= mid - 1){ // 这里的判断条件是关键
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

// BFS
// FIXME: 关键:  1. 需要extra queue 来同步 save degree
//:             2. 需要pass reference 来记录最小值

- (NSArray<NSArray<NSNumber *> *> *)binaryTreeVerticalOrderTraversal_BFS:(TreeNode *)treeNode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSInteger minV = 0;
    [self doBFSOrderTraversal:treeNode degree:0 withDic:dic andMin:&minV];
    
    NSMutableArray *result = [NSMutableArray array];
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

        NSInteger currentDegree = [degreeQueue firstObject].integerValue;//这里使用了另外一个queue，我开始想的是用dic 来存，应该都可以
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
            *minV = MIN(*minV, currentDegree - 1); // 需要记录最小值
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

// Fellow up : 如果是predecessor ， 那么就是往右走的时候记录下。

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

// TODO: 迭代版本！
// 因此在 BST 里面，确定起来就很简单了，从 root 往下走，每次往左拐的时候，存一下，记录着最近一个看到的比 p.val 大的 node 就行了。

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

#pragma mark - 297. Serialize and Deserialize Binary Tree

// 我用的这种解决方法是 BFS iterate 的方法
// TODO: 如果不用占位符怎么弄？ 可以利用preorder 和 inorder 序列进行恢复
// 序列化之后的对象是否是字符串

// TODO: Fellow up 关于这题，leetcode 还有倒新题 449. Serialize and Deserialize BST，BST和BT在这地方有啥区别吗？
// 如何发挥binary search 的优势呢？https://discuss.leetcode.com/topic/66651/java-preorder-queue-solution
// 可以根据preorder 序列排序得到inorder 序列, 然后用construct tree from preorder and inorder 的办法。

// Fellow up : 如果是 serialize 是linkedList 如何处理？
// 回答: 在遍历的时候注意维护一个headNode 和一个tailNode，headNode 保持不变，然后iterateNode 或者tail node 随着创建的过程中
// 指向创建的那个，然后tailNode 向后走一个, 这里可以和interviewer 商量下，是否可以用double linked list

//
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

        if(treeNode.left) { //关键: 只负责加入queue里，serialize 在dequeue 的时候处理
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

- (ListNode *)serializeToList:(TreeNode *)treeNode
{
    if(treeNode == nil) {
        return nil;
    }
    NSMutableString *mStr = [NSMutableString string];
    //level order traversal use ",",inorder to split the string later
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject: treeNode];
    
    ListNode *head;
    ListNode *iterate;
    
    while([queue count]) {
        TreeNode *treeNode = [queue firstObject];
        [queue removeObjectAtIndex:0];
        
        ListNode *node = [ListNode new]; //we can not assgin the val. no need to
        if(!head){
            head = node;
            iterate = node;
        } else {
            iterate.next = node;
        }
        
        if([treeNode isEqual:[NSNull null]]) {
            continue;
        } else {
            node.val = treeNode.val;
        }
        iterate = node;
        
        if(treeNode.left) { //关键: 只负责加入queue里，serialize 在dequeue 的时候处理
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
    
    return head;
}

// 和serilize 一样都是按层遍历
// 时间复杂度 和空间复杂度都为 O(n)
// when construct the left child and rigt child we need asgin it to their parents and also enqueue

- (TreeNode *)deserialize:(NSString *)string
{
    if([string length] == 0) {
        return nil;
    }
    
    NSArray *treeArray = [string componentsSeparatedByString:@","];
    NSMutableArray *queue = [NSMutableArray array];

    NSUInteger idx = 0;
    TreeNode *root = [[TreeNode alloc] init];
    root.val = ((NSNumber *)treeArray[idx]).integerValue;

    [queue addObject:root];

    while(idx < [treeArray count] && [queue count] != 0) { //这里关于queue 的判断可以省了diao, 用链表也没啥问题
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
    return root;
}

# pragma mark -  序列化 递归版本 比较容易 preorder

// 因为在 deserialize_I 的时候要返回树的头， 所以用preorder,
// 那是不是用postorder 也可以？ 直接用返回最后一个序列化完成的那个treeNode；

- (NSString *)serialize_R:(TreeNode *)treeNode
{
    if(treeNode == nil) {
        return nil;
    }
    NSMutableString *str = [NSMutableString string];
    [self doSerialize:treeNode str:str];
    return [str copy];
}

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

#pragma mark - 序列话 基于链表的实现 需要传递二级指针 如果需要改值的话

- (ListNode *)serialize_RListNode:(TreeNode *)treeNode
{
    if(treeNode == nil){
        return nil;
    }
    ListNode *head = nil;
    ListNode *prev = nil;
    [self doSerialize:treeNode prevList:&prev head:&head];//
    return head;
}

// FIXME: 注意 这里需要更新prev 指向不同的对象，需要更新prev 指向当前便利到的node 的前一个，所以也需要用二级指针

- (void)doSerialize:(TreeNode *)treeNode prevList:(ListNode **)prev head:(ListNode **)head
{
    ListNode *node = [ListNode new];
    if(!head){
        *head = node;
    }
    (*prev).next = node;
    *prev = node; // use prev to track the prevoius node we have visited , so we need update the object the prev has point
    if(treeNode){ //如果为空就任由node的val为空。 然后在解析的时候，通过判断其是否为空
        node.val = treeNode.val;
        [self doSerialize:treeNode.left prevList:prev head:head]; //只有通过二级指针的办法才能使得 prev 里面的地址，也就是指向别的对象。
        [self doSerialize:treeNode.right prevList:prev head:head];
    }
}

#pragma mark - Deserialize / Serialize Recursive

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

// FIXME: 递归实现第一遍不是自己写的。还需要看下。需要注意 node.right 那个 idx 的在函数内部改动的，不是在传递参数的时候改的
// 关键是传递引用，需要记录访问到第几个元素，这样才可以在 array 中对应的值
// Bottom up + preorder

- (TreeNode *)doDeSerialize:(NSArray *)strArray idx:(NSUInteger *)idx
{
    NSString *item = strArray[*idx]; //这里也可以直接返回数组第一个，然后pop 掉，但是这样用数组来实现性能会比较差。 但是可以把input 数组。reverse 一样。然后就直接removelastObject 是不是就可以了。
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

#pragma mark - Deserialize / Serialize iterative

- (NSString *)serialize_preorder:(TreeNode *)treeNode
{
    NSMutableString *serialize = [NSMutableString string];
    if(!treeNode){
        return serialize;
    }
    NSMutableArray *stack = [NSMutableArray array];
    [stack addObject:treeNode];
    
    while ([stack count]) {
        TreeNode *node = [stack lastObject];
        [stack removeLastObject];
        
        if([node isKindOfClass:[NSNull class]]){
            [serialize appendString: @"*,"];
            continue;
        }
        [serialize appendString: [@(node.val) description]];
        [serialize appendString: @","];
        
        [stack addObject: node.right ?: [NSNull null]];
        [stack addObject: node.left ?: [NSNull null]];
        //we can get prev node by call [stack lastObject]
    }
    [serialize deleteCharactersInRange:NSMakeRange(serialize.length - 1, 1)];
    return [serialize copy];
}

// FIXME: 难点: preorder 反序列化有坑 没有实现

//关键点1：要存一个 boolean 记录下当前要填的点是不是左节点；
//关键点2：这个 boolean 的变化要看当前 boolean 值以及新填上的点是不是叶节点；
//关键点3：对于填充右节点的情况，链接完了就直接 pop()，有别于填充左子树时候用的 peek(). 因为 preorder 右子树结束之后 stack frame 就出栈了

- (TreeNode *)deserialize_preorder:(NSString *)treeString
{
    if(!treeString){
        return nil;
    }
    NSArray<NSString *> *deserialize = [treeString componentsSeparatedByString:@","];
    NSInteger idx = 0;
    NSMutableArray<TreeNode *> *stack = [NSMutableArray array];
    TreeNode *root = [TreeNode new];
    root.val = deserialize[idx].integerValue;
    [stack addObject:root];
    idx = 1;
    BOOL doLeft = YES;  //需要一个bool 去标记是否是left
    
    while (idx < [deserialize count]) {
        TreeNode *node = nil;
        if(![deserialize[idx] isEqualToString:@"*"]){
            node = [TreeNode new];
            node.val = deserialize[idx].integerValue;
        }
        idx++;
        if(doLeft){
            stack.lastObject.left = node;
            if(node == nil) //如果当前的node 为空 就不需要在下次访问left
                doLeft = NO;
        } else {
            stack.lastObject.right = node;
            [stack removeLastObject];
            if(node != nil)
                doLeft = YES;
        }
        if(!node){
            [stack addObject:node];
        }
    }
    
    return root;
}

// TODO: // 106. Construct Binary Tree from Inorder and Postorder Traversal
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

// TODO: LCA 还有一种变形是git commit 找公告commit

//第一题是说git version control的。
//           base
//        commit1. ,
//        commit2.
//   commit3    commit3'.
//   commit4    commit4'
//    ......
//

//有个commit class (我用的java)
//1. public class Commit {
//    2.      int id;
//    3.      Commit parent;
//    4. }

//
//然后给你两个commit，求出他们最近的一个共同的ancestor commit。
//举个例子，commit4和commit3'最近的一个ancestor是commit2
//
//接口很简单：. From 1point 3acres bbs
//public Commit findAncestor(Commit c1, Commit c2);

// 思路是 traverse from c1 back to it's ancestors . and record it with a set.
// then traverse another c2 . 这种方法的 T: o(h) S : O(h)
// 另外一种方法 是 space（1） T

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
// 如果要 返回前面 k 个，就直接传 array 进去

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
//    return [self isValidBST_recursive:root];
    TreeNode *prev = nil;
    return [self isValidBST_rdoublePointer:root prev:&prev];
}

//这里用到了静态全局变量, 还有一种方法是传递最小值和最大值来确定边界的，也是非常巧妙的
//!! 或者传递 prev 二级指针，来change it prev point to another object

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

- (BOOL)isValidBST_rdoublePointer:(TreeNode *)root prev:(TreeNode **)prev
{
    if(root == nil){
        return YES;
    }
    if (![self isValidBST_rdoublePointer:root.left prev:prev]) {
        return NO;
    }
    if(*prev && root.val <= (*prev).val){
        return NO;
    }
    *prev = root;
    if(![self isValidBST_rdoublePointer:root.right prev:prev]){
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

// TODO: 这个preorder,可以用来解决这个: Flatten Binary Tree to Linked List
// FIXME: preorder: 中左右， 也是最简单的 注意是先把node.right push stack

- (NSArray *)preorder:(TreeNode *)treeNode
{
    NSMutableArray *preorder = [NSMutableArray array];
    if(!treeNode){
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

// FIXME: first push node.left, preorder 的reverse 版本
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

        if (node.left) { //
            [stack addObject:node.left];
        }
        if(node.right){
            [stack addObject:node.right];
        }
        //we can get prev node by call [stack lastObject]
    }
    return [[result reverseObjectEnumerator] allObjects];
}

// FIXME: 已经遗忘 分三种情况讨论
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

// TODO: 高频 需要在搞一遍

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

// FIXME: 第一遍理解错了。
#pragma mark - isSymmetric / check if a tree is a mirror

// recursive way

- (BOOL)isSymmetric:(TreeNode *)treeNode
{
    if(treeNode == nil){
        return YES;
    }
    return [self isSymmetric:treeNode.left withNode:treeNode.right];
}

- (BOOL)isSymmetric:(TreeNode *)t1 withNode:(TreeNode *)t2
{
    if(t1 && t2){
        return (t1.val == t2.val) &&
        [self isSymmetric:t1.left withNode:t2.right] &&
        [self isSymmetric:t2.right withNode:t1.left];
    }
    return t1 == t2;
}

// 迭代版本，一种就是按层遍历，然后分析每一层的数组判断是否是sysmetric
// TODO: 另外一种方法 一次 pop 两次。

//public boolean isSymmetric(TreeNode root) {
//    Queue<TreeNode> q = new LinkedList<>();
//    q.add(root);
//    q.add(root);
//    while (!q.isEmpty()) {
//        TreeNode t1 = q.poll();
//        TreeNode t2 = q.poll();
//        if (t1 == null && t2 == null) continue;
//        if (t1 == null || t2 == null) return false;
//        if (t1.val != t2.val) return false;
//        q.add(t1.left);
//        q.add(t2.right);
//        q.add(t1.right);
//        q.add(t2.left);
//    }
//    return true;
//}

//- (BOOL)isSymmetricBFS:(TreeNode *)treeNode
//{
//    if(treeNode == nil){
//        return YES;
//    }
//    NSMutableArray *queue = [NSMutableArray array];
//    [queue addObject:treeNode];
//    [queue addObject:treeNode];
//
//    while ([queue count]) {
//        TreeNode *t1 = queue[0];
//    }
//}

#pragma mark - 下面是非fb面筋 但是加锁的

// 解法：1. 获取总的深度，然后用解决上面第一题的方式，只是在算权重的时候 用height - level
// 解法：2. DFS，首先计算出高度，然后用第一题的方式，只是在传递weight 的时候 改成 weight - 1

//- (NSInteger)depthSum2:(NSArray *)nestedList
//{
//
//}

// 366 Find Leaves of Binary Tree [M] 非面筋
// 思路: 找到当前点距离距离起subtree 的最远距离，就是其层级。 bottom up
// T & s 都是 O (n) ， each node visit once
// 英文说:  finding the index of the element in the result list.
//     2
//    / \
//   1   4
//      / \
//     3   5
// 那么 2 的层级就是 2, 4 就是 1 ， 135 就是 0
// 需要confirm 的时 In the actual interview, just confirm with the interviewer whether removal is required.

- (NSArray<NSArray<NSNumber *> *> *)findLeaves:(TreeNode *)node
{
    NSMutableArray *result = [NSMutableArray array];
    [self dfsFindLeaves:node result:result];
    return [result copy];
}

- (NSInteger)dfsFindLeaves:(TreeNode *)node result:(NSMutableArray *)result
{
    if(node == nil){
        return -1; // 这个是个技巧
    }
    //当前距离为子树的最大距离 + 1
    NSInteger level = MAX([self dfsFindLeaves:node.left result:result], [self dfsFindLeaves:node.right result:result]) + 1;
    if(level == result.count){
        [result addObject:[@[] mutableCopy]];
    }
    [result[level] addObject:@(node.val)];
    return level;
}

//- (NSInteger)largestBST:(TreeNode *)node
//{
//    
//}

//
// 1
//  \
//   3
//  / \
// 2   4
//      \
//       5
//Longest consecutive sequence path is 3-4-5, so return 3.

//
//     2
//      \
//       3
//      /
//     2
//    /
//   1

// 给出两棵树的前序遍历，寻找第一个值不同的叶节点
// 问题:如何判断叶子结点？
//public Wrapper findNext(int[] preorder, Stack<Integer> stack, int index) {
//    while(index < preorder.length) {
//        if (stack.isEmpty() || preorder[stack.peek()] > preorder[index]) {
//            stack.push(index);  //push the index
//            index++;
//        } else {
//            return new Wrapper(index ,stack.pop());
//        }
//    }
//    if(stack.isEmpty()) return new Wrapper(index, null);
//    return new Wrapper(index, stack.pop());
//}
//
//class Wrapper {
//    int index;  //index of currently traversed node in the array (as in pre-order)
//    Integer c;  //index of the next leave (as in in-order)
//    
//    Wrapper(int index, Integer c) {
//        this.index = index;
//        this.c = c;
//    }
//}
//
////compare the if the two leaves are equal
//public void firstNonMathcingLeaves(int[] o1, int[] o2) {
//    Stack<Integer> s1 = new Stack<>(), s2 = new Stack<>();
//    
//    Wrapper w1 = new Wrapper(0, 0), w2 = new Wrapper(0, 0);
//    while(w1.c != null && w2.c != null && o1[w1.c] == o2[w2.c]) {
//        w1 = findNext(o1, s1, w1.index);
//        w2 = findNext(o2, s2, w2.index);
//    }
//    
//    if(w1.c == null && w2.c == null) {
//        System.out.println("same"); return;
//    }
//    if(w1.c == null) {
//        System.out.println(w1.c + " " + o2[w2.c]); return;
//    }
//    if(w2.c == null) {
//        System.out.println(o1[w1.c] + " " + w2.c); return;
//    } else {
//        System.out.println(o1[w1.c] + " " + o2[w2.c]);
//    }
//}

//FIXME: 想了好久没有思路

//TODO: 思路 关键:通过preorder 单调递减 然后 递增找到leaf

- (Wrapper *)findNext:(NSArray<NSNumber *> *)nums stack:(NSMutableArray *)stack index:(NSInteger)index
{
    //如果是单调递减说明此时还没有到tree的叶子
    while (index < nums.count) {
        if(stack.count == 0 || [stack.lastObject compare:nums[index]] == NSOrderedDescending) {
            [stack addObject:nums[index]];
            index++;
        } else {
            //如果是单调递减说明此时还没有到tree的叶子
            NSNumber *leafIndex = stack.lastObject;
            [stack removeLastObject];
            return [[Wrapper alloc] initWithIndex:index c:leafIndex];
        }
    }
    if(stack.count){
        NSNumber *leafIndex = stack.lastObject;
        [stack removeLastObject];
        return [[Wrapper alloc] initWithIndex:index c:leafIndex];
    } else {
        return [[Wrapper alloc] initWithIndex:index c:nil];
    }
}

- (NSArray *)firstMissPairLeafBetweenTreeSequence:(NSArray<NSNumber *> *)nums1 nums2:(NSArray<NSNumber *> *)nums2
{
    NSMutableArray *s1 = [NSMutableArray array];
    NSMutableArray *s2 = [NSMutableArray array];
    
    Wrapper *w1 = [[Wrapper alloc] initWithIndex:0 c:0]; //index 的作用的为了下次调用的时候，可以接着上次traverse 的位置继续
    Wrapper *w2 = [[Wrapper alloc] initWithIndex:0 c:0];
    
    while (w1.c != nil &&
           w2.c != nil &&
           [nums1[w1.c.integerValue] isEqualToNumber: nums2[w2.c.integerValue]]) {
        w1 = [self findNext:nums1 stack:s1 index:w1.index];
        w2 = [self findNext:nums2 stack:s2 index:w2.index];
    }
    
    //如果是nil了,说明没有找到不等的
    if(!w1.c && !w2.c){ //
        //same
        return @[];
    } if(w1.c && w2.c){
        return @[w1.c, w2.c];
    } if(!w1.c) {
        return @[@(NSNotFound), w2.c];
    } else {
        return @[w1.c, @(NSNotFound)];
    }
}

# pragma mark - 298 Binary Tree Longest Consecutive Sequence
// http://www.jiuzhang.com/solutions/binary-tree-longest-consecutive-sequence/
// FIXME: 不是很好理解, 有些抽象 divide an conquer
- (NSInteger)longestConsecutive:(TreeNode *)treeNode
{
    return [self longestConsecutive:treeNode parentNode:nil res:0];
}

// 如果 3 = 2 + 1, 那么 res = res + 1,
// 而递归遍历写起来特别简单，下面这种解法是用到了递归版的先序遍历，我们对于每个遍历到的节点，我们看节点值是否比参数值(父节点值)大1，如果是则长度加1，否则长度重置为1，然后更新结果res，再递归调用左右子节点即可

- (NSInteger)longestConsecutive:(TreeNode *)treeNode parentNode:(TreeNode *)parent res:(NSInteger)res
{
    if(!treeNode){
        return res;
    }
    //option 1: 选择当前node
    res = (parent && parent.val == treeNode.val - 1) ? res + 1 : 1;
    //option 2: 没有选择
    NSInteger temp = MAX([self longestConsecutive:treeNode.left parentNode:treeNode res:res], [self longestConsecutive:treeNode.right parentNode:treeNode res:res]);
    return MAX(res, temp);
}

#pragma mark - 124 Binary Tree Maximum Path Sum 【H】

//FIXME: 还需要review, 不太好理解

// 我想到用分治的办法，但是在构建分治之后的关系的时候 没有想出来
// case 1: path left subtree 或者 right subtree ，进行递归调用, case
// case 2: 包含这个root 此时的结构是什么样子的呢？下面的方法通过pass refer解答出来了

//A path from start to end, goes up on the tree for 0 or more steps, then goes down for 0 or more steps. Once it goes down, it can't go up. Each path has a highest node, which is also the lowest common ancestor of all other nodes on the path.
//A recursive method maxPathDown(TreeNode node) (1) computes the maximum path sum with highest node is the input node, update maximum if necessary (2) returns the maximum sum of the path that can be extended to input node's parent.

// 方法: Bottom up
- (NSInteger)maxPathSum:(TreeNode *)treeNode
{
    NSInteger max = NSIntegerMin;
    [self maxPathSum:treeNode max:&max];
    return max;
}

// 比较难以理解

// The second maxValue contains the bigger between the left sub-tree and right sub-tree.
// if (left + right + node.val < maxValue ) then the result will not include the parent node which means the maximum path is in the left branch or right branch.
// 这特么太牛比了

- (NSInteger)maxPathSum:(TreeNode *)treeNode max:(NSInteger *)max
{
    if(!treeNode)
        return 0;
    
    NSInteger left = MAX([self maxPathSum:treeNode.left max:max], 0);
    NSInteger right = MAX([self maxPathSum:treeNode.right max:max], 0);// 获取到left 和 right 的max Value
    *max = MAX(*max, left + right + treeNode.val); //
    return MAX(left, right) + treeNode.val; //case 1: 取左右最大值 + 包含当前值
}

#pragma mark - Diameter of a Binary Tree [MJ]

//思路

//* the diameter of T’s left subtree
//* the diameter of T’s right subtree
//* the longest path between leaves that goes through the root of T (this can be computed from the heights of the subtrees of T)

// T(n) = T(n/2) + T(n/2) + n = nlogn. 但是geeksforgeeks 上写的 n^2
// 存在height 重复计算，如何optimzie 呢？

- (NSInteger)diameterOfBinaryTree:(TreeNode *)treeNode
{
    if(!treeNode){
        return 0;
    }
    NSInteger left = [self diameterOfBinaryTree:treeNode.left]; // case 1: diameter 在左边或者右边
    NSInteger right = [self diameterOfBinaryTree:treeNode.right];
    // case 2: accros left subtree and right subtree
    NSInteger pathIncludeRoot = [self heightOfBinaryTree:treeNode.left] + [self heightOfBinaryTree:treeNode.right] + 1;
    return MAX(MAX(left, right), pathIncludeRoot);
}

// the time complexity is O(n), beacuse it traverse the each node of tree only once
// T(n) = T(n/2) + T(n/2)

- (NSInteger)heightOfBinaryTree:(TreeNode *)treeNode
{
    if(!treeNode)
        return 0;
    
    return 1 + MAX([self heightOfBinaryTree:treeNode.left], [self heightOfBinaryTree:treeNode.right]);
}

// The implementation can be optimized by calculating the height in the same recursion
// T(n) = 2 * T(n/2) = O(n) 算法复杂度

- (NSInteger)diameterOfBinaryTree:(TreeNode *)treeNode height:(NSInteger *)height
{
    if(!treeNode){
        *height = 0;
        return 0;
    }
    
    NSInteger lHeight = 0;
    NSInteger rHeight = 0;

    NSInteger left = [self diameterOfBinaryTree:treeNode.left height:&lHeight]; // case 1: diameter 在左边或者右边
    NSInteger right = [self diameterOfBinaryTree:treeNode.right height:&rHeight];
    // case 2: accros left subtree and right subtree
    NSInteger pathIncludeRoot = lHeight+ rHeight + 1;
    *height = MAX(lHeight , rHeight) + 1; //update the height;
    
    return MAX(MAX(left, right), pathIncludeRoot);
}

#pragma mark -  110. Balanced Binary Tree 

// 思路1: 这道题目，反映了我对balance BT 的概念记忆错误
// 另外一种是利用递归的思路

// average case : T(n) =  2 * T(n/2) + O(n) = nlogn
// worset case : T(n) = T(n-1) + O(n)= n^2

// 方法1: Top down

- (BOOL)isBalanced:(TreeNode *)root
{
    if(!root)
        return YES;
    
    NSInteger lH = [self maxDepth:root.left];
    NSInteger rH = [self maxDepth:root.right];
    
    return ABS(lH - rH) <= 1 && [self isBalanced:root.left] && [self isBalanced:root.right];
}

// 方法2: bottom up
// if the tree is balance return the height of the tree , or return negative one
// 在递归的过程中把值传递上去, each node in tree visited only once ,
// T: O(n)

- (BOOL)isBalanced_bottomUp:(TreeNode *)root
{
    if(!root)
        return YES;
    return [self isBalanced_bottomUp_helper:root] != -1;
}

- (NSInteger)isBalanced_bottomUp_helper:(TreeNode *)root
{
    if(!root)
        return 0;
    NSInteger left = [self isBalanced_bottomUp_helper:root.left];
    NSInteger right = [self isBalanced_bottomUp_helper:root.left];
    
    if(left != -1 && right != -1 && ABS(left - right) <= 1){
        return 1 + MAX(left, right);
    } else {
        return -1;
    }
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
    return [self.stack count] != 0;
}

// TODO: Note: next() and hasNext() should run in average O(1) time and uses O(h) memory, where h is the height of the tree.

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

@implementation NestedIterator
{
    NSMutableArray *_stack;
}
// recursive dfs,处理链表问题就是首位

- (NestedListNode *)flatternNestedListNode:(NestedListNode *)listNode
{
    if(listNode == nil) return nil;
    return [self flatternNestedListNode:listNode];
}

- (NestedListNode *)flatternNestedListNode:(NestedListNode *)listNode nextNode:(NestedListNode *)nextListNode
{
    if(!listNode) return nil;
    NestedListNode *iter = listNode;
    
    while (iter) {
        NestedListNode *next = iter.next;
        if([iter.data isKindOfClass:[NestedListNode class]]){
            iter = [self flatternNestedListNode:iter.data nextNode:next];
        }
        iter = next;
    }
    iter = nextListNode;
    return listNode;
}

// FIXME: 一开始写错了 Nested iterator
// LC 定义的输入是个 List<NestedListNode> 是这种结构
// 这里定义
// 如果这里是个数组的话，那预处理的方式略有不同，因为其没有next 指针。

// 这个实现是 input 是List 的版本

//public class NestedIterator implements Iterator<Integer> {
//    Stack<NestedInteger> stack = new Stack<>();
//    public NestedIterator(List<NestedInteger> nestedList) {
//        for(int i = nestedList.size() - 1; i >= 0; i--) {
//            stack.push(nestedList.get(i));
//        }
//    }
//    
//    @Override
//    public Integer next() {
//        return stack.pop().getInteger();
//    }
//    
//    @Override
//    public boolean hasNext() {
//        while(!stack.isEmpty()) {
//            NestedInteger curr = stack.peek();
//            if(curr.isInteger()) {
//                return true;
//            }
//            stack.pop();
//            for(int i = curr.getList().size() - 1; i >= 0; i--) {
//                stack.push(curr.getList().get(i));
//            }
//        }
//        return false;
//    }
//}

- (instancetype)initWithListNode:(NestedListNode *)listNode
{
    if(self = [super init]){
        _stack = [NSMutableArray array];
        [self pushNode:listNode];
    }
    return self;
}

- (void)pushNode:(NestedListNode *)listNode
{
    NestedListNode *node = listNode;
    while (node) { // it will break, until it reach plain data which is NSNumber
        [_stack addObject:node];
        if(![node.data isKindOfClass:[NestedListNode class]]){
            break;
        }
        node = node.data;
    }
}

- (BOOL)hasNext
{
    while ([_stack count]) { //这里处理hasNext 稍微有点复杂！不能直接判断stack 是否为空，因为需要判断stack 里面的元素是data 是否有number 字段
        NestedListNode *node = [_stack lastObject];
        if([node.data isKindOfClass:[NSNumber class]]){
            return YES;
        }
        [_stack removeLastObject];
        [self pushNode:node.next];// FIXME: pay attention
    }
    return NO;
}

- (NSInteger)next
{
    NSAssert([self hasNext], @"");
    NestedListNode * node = [_stack lastObject];
    [_stack removeLastObject];
    [self pushNode:node.next]; // 把next add 到stack 中
    return ((NSNumber *)node.data).integerValue;
}

@end

//TODO: 注意如果是 2D Array 这种特殊情况，可以直接在initWithListNode 的时候，放到一维度的里面, 这种实现很简单粗暴

//FIXME: 这里非常容易出错的地方在于 hasNext 里面 在pushStack 之前，忘记掉用[_stack removeLastObject], 因为这里需要把二位降低成一维之后，要记得把stack 上的一维数组 remove 掉，要不然会有无限循环。

@implementation FlattenArrayIterator
{
    NSMutableArray *_stack;
}

- (instancetype)initWithListNode:(NSArray *)nums
{
    if(self = [super init]){
        _stack = [NSMutableArray array];
        [self pushStack:nums];//为了保证出站的时候 是正的顺序，这里用反的顺序
    }
    return self;
}

- (BOOL)hasNext
{
    while ([_stack count]) {
        id num = [_stack lastObject];
        if([num isKindOfClass:[NSNumber class]]){
            return YES;
        }
        [_stack removeLastObject];
        [self pushStack:num];
    }
    return NO;
}

- (void)pushStack:(NSArray *)nums
{
    if([nums count] == 0){
        return;
    }
    for(NSInteger i = nums.count - 1; i >= 0; i--){
        [_stack addObject:nums[i]];
    }
}

- (NSNumber *)next
{
    NSAssert([self hasNext], @"");
    NSNumber *num = [_stack lastObject];
    [_stack removeLastObject];
    
    return num;
}

@end
