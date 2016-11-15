//
//  Solution.m
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Solution.h"

@implementation Solution

@end

@implementation Solution (Tree)

//对题目的意思
// Space = O(nlgn)
// TODO: 这个问题的时间复杂度的分析 T =
// my solution
// 这里需要注意的 “->” 写的顺序

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

- (void)binaryTreePath:(TreeNode *)node prefixStr:(NSMutableString *)prefixStr array:(NSMutableArray *)array
{
    if(!node.left && !node.right) {
        [prefixStr appendString:[NSString stringWithFormat:@"%ld", (long)node.val]];
        [array addObject:prefixStr];
    }
    if(node.left) {
        NSMutableString *temp = [prefixStr mutableCopy];
        [temp appendString:[NSString stringWithFormat:@"%ld->", (long)node.val]];
        [self binaryTreePath:node.left prefixStr:temp array:array];
    }
    if(node.right) {
        NSMutableString *temp = [prefixStr mutableCopy];
        [temp appendString:[NSString stringWithFormat:@"%ld->", (long)node.val]];
        [self binaryTreePath:node.right prefixStr:temp array:array];
    }
}

//103. Binary Tree Zigzag Level Order Traversal   QuestionEditorial Solution  My Submissions
//Total Accepted: 77494
//Total Submissions: 247492
//Difficulty: Medium
//Contributors: Admin
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
            [res addObject:[subArray reverseObjectEnumerator].allObjects];
        } else {
            [res addObject:[subArray copy]];
        }
        needReverse = !needReverse;
    }
    return [res copy];
}

//99. Recover Binary Search Tree   QuestionEditorial Solution  My Submissions

//Difficulty: Hard
//Contributors: Admin
//Two elements of a binary search tree (BST) are swapped by mistake.
//
//Recover the tree without changing its structure.
//
//Note:
//A solution using O(n) space is pretty straight forward. Could you devise a constant space solution?

- (void)recoverTree:(TreeNode *)treeNode
{
    
}

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

// - (TreeNode *)sortedArrayToBST_I:(NSArray *)nodes
// {
//    if(nodes == nil) {
//        return nil;
//    }
    
//    NSUInteger left = 0;
//    NSUInteger right = nodes.count;
    
// }

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
        return node ?: root;
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

@end

@interface NSString (FBSort)

- (NSString *)sorted;
@end

@implementation Solution (String)

//Furthermore, you may assume that the original data does not contain any digits and that digits are only for those repeat numbers, k. For example, there won't be input like 3a or 2[4].
// 上面这句话是要问面试官的
// 异常case 1 “” 2 [] 等, 比如[] 结构是否对成，另外就是有没有 空格 里面有没有数字，考虑各种异常case的
// 1[] 应该返回什么？
// 1[a]

//- (NSString *)decodeString_i:(NSString *)str
//{
//    if(str.length < 4) {
//        return str;
//    }
//    
//}

// 在写这些问题的过程中，碰到要存储字符，用oc 的容器肯定不行

// 可以设计一个状态机
// 

//static NSDictionary *map = {"", }
//这背后除了状态机，和Tree 有没有什么关系
//lj 上有大神用两行 2 行正则表达式搞定了，靠！

// def decodeString(self, s):
// while '[' in s:
//      s = re.sub(r'(\d+)\[([a-z]*)\]', lambda m: int(m.group(1)) * m.group(2), s)
// return s

- (NSString *)decodeString:(NSString *)str
{
    if(str.length < 4) {
        return str;
    }
        
    NSMutableArray<NSNumber *> *numStack = [NSMutableArray array];
    NSMutableArray<NSString *> *strStack = [NSMutableArray array];
    NSMutableString *currStr = [NSMutableString string];

    NSInteger count = 0;
    for(NSUInteger idx = 0; idx < str.length; idx++) {
        NSString *sub = [str substringWithRange:NSMakeRange(idx, 1)];
        if(sub.integerValue != 0) {
            count = count * 10 + sub.integerValue;
        } else if ([sub isEqual:@"["]) {
            [numStack addObject:@(count)];
            [strStack addObject:[currStr copy]];
            currStr = [NSMutableString string];
            count = 0;
        } else if ([sub isEqual:@"]"]) {
            NSUInteger repeatingCount = [numStack lastObject].integerValue;
            [numStack removeObjectAtIndex:[numStack count] - 1];

            NSString *preStr = [strStack lastObject];
            [strStack removeObjectAtIndex:[numStack count]- 1];

            NSMutableString *repeatedString = [preStr mutableCopy];
            while(repeatingCount > 0) {
                [repeatedString appendString:currStr];
                repeatingCount--;
            }
            currStr = repeatedString;
        } else {
            [currStr appendString:sub];
        }
    }
    return [currStr copy];
}

// - (NSString *)decodeString_r:(NSString *)str
// {

// }

// - (NSInteger)numDecodings:(NSString *)s
// {

// }

//属于比较繁琐的问题，主要是耐心和细心

// - (NSString *)multiplyStr:(NSString *)str1 andStr:(NSString *)str2
// {
//     if (str1.length == 0 || str2.length == 0)
//     {
//         return nil;
//     }

//     NSMutableString *res = [NSMutableString string];
//     NSMutableArray<NSString *> *strArray = [NSMutableArray array];

//     for (NSInteger i = str1.length - 1; i >= 0; i--) 
//     {
//         NSString *m = [str1 substringWithRange:NSMakeRange(i, 1)];
//         NSInteger mInt = m.integerValue;

//         NSMutableString *tempRes = [NSMutableString string];
//         NSInteger tempCarry = 0;
//         for (NSInteger j = str2.length - 1; j >= 0; j--)
//         {
//             NSString *n = [str2 substringWithRange:NSMakeRange(j, 1)]];
//             NSInteger nInt = n.integerValue;

//             NSInteger mn = mInt * nInt + tempCarry;
//             NSInteger tailToken = mn % 10;
//             tempCarry = mn / 10;

//             [tempRes insertString:[NSString stringWithFormat:@"%(ld)", (long)tailToken] atIndex:0];
//         }
//         [strArray addObject:tempRes];
//     }

//     //process strArray
//     for (int i = 0; i < strArray.length; ++i)
//     {
        
//     }
// }

// https://discuss.leetcode.com/topic/30508/easiest-java-solution-with-graph-explanation/2

- (NSString *)multiplyStr:(NSString *)str1 andStr:(NSString *)str2
{
    if (str1.length == 0 || str2.length == 0)
    {
        return nil;
    }
    NSInteger m = str1.length;
    NSInteger n = str2.length;
    
    //even 99 * 99 < 10000, so maximaly 4 digitis
    NSMutableArray<NSNumber *> *res = [NSMutableArray arrayWithCapacity: m + n];
    NSInteger i = m + n;
    while (i > 0) {
        [res addObject:@(0)];
        i--;
    }
    
    NSInteger product = 0;

    for(NSInteger i = m - 1; i >= 0; i--) {
        NSString *m = [str1 substringWithRange:NSMakeRange(i, 1)];
        NSInteger mInt = m.integerValue;

        for(NSInteger j = n -1; j >= 0; j--) {
            NSString *n = [str2 substringWithRange:NSMakeRange(j, 1)];
            NSInteger nInt = n.integerValue;

            product = res[i + j + 1].integerValue + mInt * nInt; // 这里的index关系是解体的关键
            res[i + j + 1] = @(product % 10);
            res[i + j] = @(product / 10);
        }
    }

    NSMutableString *resStr = [@"" mutableCopy];
    for (NSInteger i = 0; i < [res count]; ++i)
    {
        //trime starting zeros
        if(!(resStr.length == 0 && res[i].integerValue == 0)) {
            [resStr appendString:[res[i]  description]];
        }
    }
    return (resStr.length == 0) ? @"0" : [resStr copy];
}

// 还有一种解法也非常巧妙

// public String multiply(String num1, String num2) {
//     num1 = new StringBuilder(num1).reverse().toString();
//     num2 = new StringBuilder(num2).reverse().toString();
//     // even 99 * 99 is < 10000, so maximaly 4 digits
//     int[] d = new int[num1.length() + num2.length()];
//     for (int i = 0; i < num1.length(); i++) {
//         int a = num1.charAt(i) - '0';
//         for (int j = 0; j < num2.length(); j++) {
//             int b = num2.charAt(j) - '0';
//             d[i + j] += a * b;
//         }
//     }
//     StringBuilder sb = new StringBuilder();
//     for (int i = 0; i < d.length; i++) {
//         int digit = d[i] % 10;
//         int carry = d[i] / 10;
//         sb.insert(0, digit);
//         if (i < d.length - 1)
//             d[i + 1] += carry;
//     }
//     //trim starting zeros
//     while (sb.length() > 0 && sb.charAt(0) == '0') {
//         sb.deleteCharAt(0);
//     }
//     return sb.length() == 0 ? "0" : sb.toString();
// }

- (NSString *)addBinary:(NSString *)str1 andStr:(NSString *)str2
{
    if (str1.length == 0 || str2.length == 0) // return "" emtpy string and nil
    {
        return nil;
    }

    NSMutableString *sum = [NSMutableString string];

    NSInteger carry = 0;
    NSInteger i = str1.length - 1;
    NSInteger j = str2.length - 1;

    while(j >= 0|| i >= 0 || carry > 0) {
        NSInteger p = (i >= 0) ? [str1 substringWithRange:NSMakeRange(i, 1)].integerValue : 0;
        NSInteger q = (j >= 0) ? [str2 substringWithRange:NSMakeRange(j, 1)].integerValue : 0;

        NSInteger curr = (p + q + carry) % 2;
        carry = (p + q + carry) / 2;
        [sum insertString:[NSString stringWithFormat:@"%ld", (long)curr] atIndex:0];
        i--;
        j--;
    }
    //这里可以check 下 是否对00 这样的输出结果，直接输出还是trim the zero
    return [sum copy];
}

// - (NSString *)palindromePairs:(NSArray<NSString *> *)
// {

// }

// 2 pointers 

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle
{
    //which integer indicate not found index
    // m * n
    NSInteger idx = 0;
    for (NSInteger i = 0; i < haystack.length; ++i)
    {
        NSInteger curr = i;
        for (NSUInteger j = 0; j < needle.length; ++j)
        {
            if ([haystack substringWithRange:NSMakeRange(curr, 1)] != [needle substringWithRange:NSMakeRange(j, 1)]) {
                break;
            }
            curr += 1;
        }
        return idx;
    }
    return - 1;
}

BOOL isAalphaNumber(unichar ch)
{
    NSCharacterSet *alphanumericCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    return [alphanumericCharacterSet characterIsMember:ch];
}

//头尾双指针，可以和快速排序对比下

- (BOOL)isPalindrome:(NSString *)str
{
    if(str.length <= 1) {
        return YES;
    }

    NSInteger start = 0;
    NSInteger end = str.length - 1;

    while(start < end) {
        while(!isAalphaNumber([str characterAtIndex:start]) && start < end) {
            start++;
        }
        while(!isAalphaNumber([str characterAtIndex:end]) && start < end) {
            end--;
        }
        if(![[str substringWithRange:NSMakeRange(start, 1)] isEqualToString:[str substringWithRange:NSMakeRange(end, 1)]]) {
            return NO;
        }
        start++;
        end--;
    }
    return YES;
}


// bool isBadVersion(int version);

// //1, 2,3,4,5,6,9
// - (NSInteger)firstBadVersion:(NSInteger)n
// {
//     //找一个满足条件的
//     NSInteger left = 1;
//     NSInteger right = n;
//     while(left < right) {
//         NSInteger mid = (right - left) / 2 + left;
//         if(isBadVersion(mid)) {
//             right = mid - 1;
//             if(right == 1 || !isBadVersion(mid-1)) {
//                 return mid;
//             }
//         } else {
//             left = mid + 1;
//         }
//     }
//     return left;
// }

// start from 1 ,这中写法容易TLE 果然是指数级别的,当把n=500 的时候, 内存和cpu都爆了，并且运算了好久。内存一直在涨，说明stack一直在涨

- (NSString *)countAndSay_recursive:(NSInteger)n
{
    if(n <= 0) {
        return nil;
    }
    if(n == 1) {
        return @"1";
    } 
    NSString *prev = [self countAndSay_recursive:n - 1];
    NSInteger count = 1;
    NSString *curStr = [prev substringWithRange:NSMakeRange(0 , 1)];
    NSMutableString *result =[NSMutableString string];
    for(NSInteger i = 1; i < prev.length; i++) {
        if([[prev substringWithRange:NSMakeRange(i , 1)] isEqualToString: curStr]) {
            count++;
        } else {
            [result appendString:[NSString stringWithFormat:@"%ld%@", (long)count, curStr]];
            curStr = [prev substringWithRange:NSMakeRange(i , 1)];
            count = 1; // reset count
        }
    }
    //last one
    [result appendString:[NSString stringWithFormat:@"%ld%@", (long)count, curStr]];
    return [result copy];
}

// 这里在和前面元素进行比较的时候，也可以通过i i-1 index 进行比较
- (NSString *)countAndSay_iterative:(NSInteger)n
{
    if(n <= 0) {
        return nil;
    }

    NSString *curStr = @"1";    
    for(NSInteger i = 2; i <= n; i++) {
        NSMutableString *ms = [NSMutableString string];

        NSString *prevChar = [curStr substringWithRange:NSMakeRange(0, 1)];
        NSInteger count = 1;
        for(NSInteger j = 1; j < curStr.length; j++) {
            NSString *currChar = [curStr substringWithRange:NSMakeRange(j, 1)];
            if([currChar isEqualToString:prevChar]) {
                count++;
            } else {
                [ms appendString:[NSString stringWithFormat:@"%ld%@", (long)count, prevChar]];
                prevChar = currChar;
                count = 1;
            }
        }
        [ms appendString:[NSString stringWithFormat:@"%ld%@", (long)count, prevChar]];
        curStr = [ms copy];
    }
    return curStr;
}

- (NSArray<NSArray<NSString *> *> *)groupAnagrams:(NSArray<NSString *> *)strs
{
    if(strs == nil) {
        return nil;
    }
    if([strs count] <= 1) {
        return @[strs];
    }

    NSMutableDictionary<NSString *, NSMutableArray *> *dic = [NSMutableDictionary dictionary];
    for(NSString *str in strs) {
        NSString *key = [str sorted];
        if(dic[key]) {
            [dic[key] addObject:str];
        } else {
            dic[key] = [@[str] mutableCopy];
        }
    }
    return [dic allValues];
}
// emtpy string . 如何处理 DP

- (BOOL)wordBreak:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0) {
        return YES;
    }

    NSInteger count = str.length;
    NSMutableArray *map = [NSMutableArray array];
    for(NSInteger k = 0; k <= count; k++) {
        [map addObject:@(NO)];
    }

    //base case
    map[0] = @(YES);
    for(NSInteger i = 1; i <= count; i++) { //
        for(NSInteger j = 1; j <= i; j++) { // 拆分成sub problem
            NSString *subStr = [str substringWithRange:NSMakeRange(i-j ,j)];
            if(map[i-j] && [set containsObject:subStr]) {
                map[i] = @(YES);
                break;
            }
        }
    }
    return [map[count] boolValue];
}

//DFS

- (NSArray<NSString *> *)wordBreak_2:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0 || set == nil) {
        return nil;
    }

    return [self doWordBreak:str idx:0 set:set];
}

//Time complexity 有些复杂，概率性的 和set 有关
- (NSArray<NSString *> *)doWordBreak:(NSString *)str idx:(NSInteger)idx set:(NSSet*)set
{
    //base case
    if(idx == str.length) {
        return @[@""];
    }

    NSMutableArray *result = [NSMutableArray array];
    for(NSInteger i = idx + 1; i <= str.length; i++) {
        NSString *leftStr = [str substringWithRange:NSMakeRange(idx, i - idx)];
        if([set containsObject:leftStr]) { //如果set包含进行递归调用
            NSArray *temp = [self doWordBreak:str idx:i set:set];

            for(NSString *e in temp) {
                if([e length] > 0) {
                    [result addObject:[NSString stringWithFormat:@"%@ %@", leftStr, e]];
                } else {
                    [result addObject:leftStr];
                }
            }
        }
    }
    return result;
}

// method 1. 用product of all elements dived by each element 
// method 2  
// first scan form right to left calculate the product of all elements in the left side of a[i] excluding a[i]
// scan form left to right

// assum integer can hold

- (NSArray<NSNumber *> *)productExceptSelf:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *> *product = [NSMutableArray array];
    long long preProduct = 1;
    for(NSInteger i = 0; i < [nums count]; i++) {
        [product addObject: @(preProduct)];
        preProduct *= nums[i].longLongValue;
    }

    preProduct = 1;
    for(NSInteger i = [nums count] - 1; i >= 0; i--){
        product[i] = @(product[i].longLongValue * preProduct);
        preProduct *= nums[i].longLongValue;
    } 
    return product;
}

@end

@implementation NSString (FBSort) 

- (NSString *)sorted
{
    NSMutableArray *charArray = [NSMutableArray arrayWithCapacity:self.length];
    for (int i=0; i< self.length; ++i) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        [charArray addObject:charStr];
    }

    return [[charArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] componentsJoinedByString:@""];
}

@end

//#prama mark - Array

@implementation Solution (Array)

// MIT open class has video

- (NSArray<NSArray *> *)threeSum:(NSArray *)nums // 3sum
{
    //sort array
    NSAssert([nums count] >= 3 , @"");
    
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
        if( obj1.integerValue < obj2.integerValue ) {
            return NSOrderedAscending;
        } else if(obj2.integerValue == obj1.integerValue) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < [nums count] - 2 ; i++) {
        if(i == 0 || (i > 0 && sortedNums[i].integerValue != sortedNums[i-1].integerValue)) { //注意去除重复，这里可以提取出来，写成continue 的形式，或者while 的形式
            NSUInteger left = i + 1;
            NSUInteger right = [nums count] - 1;
            NSInteger sum = 0 - sortedNums[i].integerValue;
            
            while (left < right) {
                if(sortedNums[left].integerValue + sortedNums[right].integerValue == sum) {
                    [result addObject: @[sortedNums[left], sortedNums[right], sortedNums[i]]];
                    while(left < right && sortedNums[left].integerValue == sortedNums[left + 1].integerValue) { //注意去除重复
                        left += 1;
                    }
                    while (left < right && sortedNums[right].integerValue == sortedNums[right - 1].integerValue) { //注意去除重复
                        right -= 1;
                    }
                    left++;
                    right--;
                } else if (sortedNums[left].integerValue + sortedNums[right].integerValue < sum) {
                    left ++;
                } else {
                    right--;
                }
          }
       }
    }
    return result;
}

- (NSInteger)threeSumCloset:(NSArray<NSNumber *> *)nums target:(NSInteger)target; // 3sum
{
    //sort array
    NSAssert([nums count] >= 3 , @"");
    
    NSArray<NSNumber *> *sortedNums = [nums sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
        if( obj1.integerValue < obj2.integerValue ) {
            return NSOrderedAscending;
        } else if(obj2.integerValue == obj1.integerValue) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];

    NSInteger result = NSIntegerMax;
    for(NSUInteger i = 0; i < [nums count] - 2; i++) {
        if(i > 0 && sortedNums[i] == sortedNums[i-1]) {
            continue;
        }
        NSUInteger left = i + 1;
        NSUInteger right = [nums count] - 1;
        NSInteger sum = target - sortedNums[i].integerValue;
        while(left < right) {
            NSInteger diff = (sum - sortedNums[left].integerValue - sortedNums[right].integerValue);
//            if(diff == 0) {
//                return 0;
//            } else
                
            if(diff < 0) {
                result = MIN(labs(diff), result);
                left++;
            } else {
                result = MIN(labs(diff), result);
                right--;
            }
            while(left < right && sortedNums[left] == sortedNums[left + 1]) {
                left++;
            }
            while(left < right && sortedNums[right] == sortedNums[right - 1]) {
                right--;
            }
        }
    }
    return result;
}

// - (NSInteger)threeSumClosest
// {
//
// }

// - (NSInteger)3sumSmaller
// {

// }

 - (NSArray *)Twosum:(NSArray<NSNumber *> *)nums target:(NSInteger)target
 {
     // can we assume the length of nums larger than 1
     if(nums.count < 2) {
         return @[];
     }

     NSMutableDictionary<NSNumber *, NSNumber *> *map = [NSMutableDictionary dictionary];
     for(NSUInteger idx = 0; idx < nums.count; idx++) {
         NSNumber *prevIdx = map[@(target - nums[idx].integerValue)];
         if(prevIdx) {
             return @[prevIdx, @(idx)];
         } else {
             map[@(idx)] = @(idx); //
         }
     }
     return @[];
 }

- (NSArray *)twosumSortedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    // can we assume the length of nums larger than 1
    if(nums.count < 2) {
        return @[];
    }
    
    //idx Two pointer
    NSUInteger l = 0;
    NSUInteger h = nums.count - 1;
    
    while(l < h) {
        NSInteger res = nums[l].integerValue + nums[h].integerValue;
        if(res == target) {
            break;
        } else if(res < target) {
            l++;
        } else {
            h--;
        }
    }
    return @[@(l + 1), @(h + 1)];
}

// - (NSInteger)4sum
// {
//
// }

// k the max number 题型。
// top k 问题
// 有相同值的情况咋办
// 1. sort
// 2. heap  
// 3  ...... 上面两种不满足 O(n) 的复杂度要求

- (NSInteger)thirdMax:(NSArray<NSNumber *> *)nums
{
    NSInteger max1 = NSIntegerMin;
    NSInteger max2 = NSIntegerMin;
    NSInteger max3 = NSIntegerMin;

    for(NSInteger idx = 0; idx < [nums count]; idx++) {
        NSInteger item = nums[idx].integerValue;
        if(item == max3 || item == max2 || item == max1) {
            continue;
        }
        if(item > max3) {
            max1 = max2; 
            max2 = max3;
            max3 = item;
        } else if(item > max2) {
            max1 = max2;
            max2 = item;
        } else if(item > max1) {
            max1 = item;
        }
    }
    return max1 == NSIntegerMin ? max3 : max1;
}

//BST 过程中 idx 如何更新
// index 处理的需要注意 数组中是否有相等的元素。
// 在遇到 case [3, 1] targe = 1 的时候 错了. 是因为 在判断排好序的左边那一行 写成 > 正确的应该是 >=

- (NSInteger)searchInRotatedArray:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSUInteger left = 0;
    NSUInteger right = [nums count] - 1;
// eg 67012345 
// eg 34567012
    while(left <= right) {
        NSUInteger mid = (right - left) / 2 + left;
        //两种结构情况
        if(nums[mid].integerValue == target) {
            return mid;
        }
        // 排好序的在左边
        if(nums[mid] >= nums[left]) {
            if(target >= nums[left].integerValue && target < nums[mid].integerValue) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        // 反之
        } else {
            if(target > nums[mid].integerValue && target <= nums[right].integerValue) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
    }
    return -1;
}

// eg 67012345 
// eg 34567012

// https://discuss.leetcode.com/topic/310/when-there-are-duplicates-the-worst-case-is-o-n-could-we-do-better/2

// eg 111811111

- (BOOL)searchInRotatedArrayDuplicate:(NSArray<NSNumber *> *)nums target:(NSInteger)target
{
    NSUInteger left = 0;
    NSUInteger right = [nums count] - 1;
    while(left <= right) {
        NSUInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue == target) {
            return YES;
        }
        if(nums[mid] > nums[left]) {
            if(target >= nums[left].integerValue && target < nums[mid].integerValue) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        } else if(nums[mid] < nums[left]) {
            if(target > nums[mid].integerValue && target <= nums[right].integerValue) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        } else { // 主要就是多了一行这个处理， Worst case O(n)
            left += 1;
        }
    }
    return NO;
}

// 递归
// int search(int A[], int n, int target) {
//         return searchRotatedSortedArray(A, 0, n-1, target);
//     }
    
//     int searchRotatedSortedArray(int A[], int start, int end, int target) {
//         if(start>end) return -1;
//         int mid = start + (end-start)/2;
//         if(A[mid]==target) return mid;
        
//         if(A[mid]<A[end]) { // right half sorted
//             if(target>A[mid] && target<=A[end])
//                 return searchRotatedSortedArray(A, mid+1, end, target);
//             else
//                 return searchRotatedSortedArray(A, start, mid-1, target);
//         }
//         else {  // left half sorted
//             if(target>=A[start] && target<A[mid]) 
//                 return searchRotatedSortedArray(A, start, mid-1, target);
//             else
//                 return searchRotatedSortedArray(A, mid+1, end, target);
//         }
//     }

// 如果数组很大怎么办
// assum array not emtpy
// 難題目

// - (float)findMedianInSortedArrays:(NSArray<NSNumber *> *)arr1 anotherArray:(NSArray<NSNumber *> *)arr2
// {
//     //two special case
//     //step 1 odd
//     NSInteger m = [arr1 count];
//     NSInteger n = [arr2 count];
//     NSInteger mid = (m + n) / 2;
//     if((m + n0) % 2) {
//         return (float)[self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid + 1];
//     } else {
//         NSInteger first = [self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid];
//         NSInteger second = [self findKthNumInArray:arr1 idx:0 otherArray:arr2 idx:0 kth:mid];
//         return double (first + second) * 0.5;
//     }
// }

// - (NSInteger)findKthNumInArray:(NSArray<NSNumber *> *)arr1 idx:(NSInteger)i otherArray:(NSArray<NSNumber *> *)arr2 idx:(NSInteger)j kth:(NSInteger)k
// {
//     if(i >= [arr1 count]) {
//         return arr2[j + k - 1];
//     }
//     if(j >= [arr2 count]) {

//     }


// }

//- (NSArray<interval *> *)mergeIntervals:(NSArray<interval *> *)intervals
//{
//   //sort interval O(nlog(n))
//   if([intervals count] < 2) {
//       return intervals;
//   }
//   NSArray *sortedIntervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(interval *first, interval *second ) {
//       if(first.start < second.start) {
//           return NSOrderedAscending;
//       } else if(first.start == second.start) {
//           return NSOrderedSame;
//       } else {
//           return NSOrderedDescending;
//       }
//   }];
//   
//   NSMutableArray *result;
//   interval *cur = sortedIntervals[0];
//   interval *next;
//   for(NSInteger idx = 1; idx < [sortedIntervals count]; idx ++){
//       *next = sortedIntervals[idx];
//       if(cur.end >= next.start) {
//           cur.end = MAX(cur.end, next.end); //注意这里需要和第二个的end进行比较
//       } else {
//           [result addObject:cur];
//           cur = next;
//       }
//   }
//   [result addObject:cur]; //添加last value
//   return result;
//}

// Solution A: scane it , build an dictionary
// which nums is larger , does it has some impact the alogrithm we choose ?
// 数组里面是整数吗？／／ 这个要确定
// Two hash table 我对于这到题目的理解，和网上的不太一样，区别在于 数组的中元素的重复个数是不是一定要相同
// 区别在于[1,2,2,2,3] [2,2,3]

// What if the given array is already sorted? How would you optimize your algorithm?
// A: 先搜索，在开始scan 的数组, 利用two pointers 

// Q: What if nums1's size is small compared to nums2's size? Which algorithm is better?

// A: If two arrays are sorted, we could use binary search, i.e., 
// for each element in the shorter array, search in the longer one. 
// So the overall time complexity is O(nlogm), where n is the length of the shorter array, and m is the length of the longer array. 
// Note that this is better than Solution 1 since the time complexity is O(n + m) in the worst case. 

// Q: What if elements of nums2 are stored on disk, and the memory is limited such that you cannot load all elements into the memory at once?
// A: If only nums2 cannot fit in memory, put all elements of nums1 into a HashMap, 
// read chunks of array that fit into the memory, and record the intersections.
// If both nums1 and nums2 are so huge that neither fit into the memory, sort them individually (external sort),
//  then read 2 elements from each array at a time in memory, record intersections

- (NSArray<NSNumber *> *)intersectionOfTwoArray:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }

    NSMutableDictionary<NSNumber *, NSNumber *> *dic = [NSMutableDictionary dictionary];
    for(NSNumber *num in array) {
        if(dic[num]) {
            dic[num] = @(dic[num].integerValue + 1);
        } else {
            dic[num] = @(1);
        }
    }

    NSMutableDictionary<NSNumber *, NSNumber *> *copyDic = [dic mutableCopy];
    for(NSNumber *num in array2) {
        if(copyDic[num]) {
            copyDic[num] = @(copyDic[num].integerValue - 1);
        }
        //skip the not found num©
    }
    // filter the result
    NSMutableArray *result = [NSMutableArray array];
    for(NSNumber *key in copyDic.allKeys) {
        if(copyDic[key].integerValue == 0) {
            NSInteger count = dic[key].integerValue;
            while(count > 0) {
                [result addObject:dic[key]];
                count--;
            }
        }
    }
    return [result copy]; // we should return an imutable object
}
// unique 的话, we can use an set 
- (NSArray<NSNumber *> *)intersectionOfTwoArray_TwoPointer:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    //nums1.size() is large
    //corner case
    
    // sorted the two array 
    // NSArray<NSNumber *> *sortedNums = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
    //     if( obj1.integerValue < obj2.integerValue ) {
    //         return NSOrderedAscending;
    //     } else if(obj2.integerValue == obj1.integerValue) {
    //         return NSOrderedSame;
    //     } else {
    //         return NSOrderedDescending;
    //     }
    // }];

    if([array lastObject] < [array2 firstObject] || [array firstObject] > [array2 lastObject]) {
        return @[];
    }

    NSInteger i = 0; // scan array
    NSInteger j = 0;
    NSMutableArray *result = [NSMutableArray array];
    while(i < [array count] && j < [array count]) {  // 这里的问题是如果数组很长，但是另外一个数组很小，可以通过二分查找先快速定位
        if(array[i].integerValue == array2[j].integerValue) {
            [result addObject: array[i]];
            i++;
            j++;
        } else if(array[i].integerValue < array2[j].integerValue) {
            i++;
        } else {
            j++;
        }
    }
    return result;
}

// 这种解法 因为用到的set 的高级的api，那么得和面试官确认下这样是否 允许

- (NSArray<NSNumber *> *)intersectionOfTwoArrayUnique:(NSArray<NSNumber *> *)array andArray2:(NSArray<NSNumber *> *)array2
{
    if([array2 count] == 0 || [array count] == 0) {
        return @[];
    }
    NSMutableSet *set = [NSMutableSet setWithArray:array];
    NSSet *set2 = [NSSet setWithArray:array2];
    [set intersectSet:set2];
    return [set allObjects];
}

//统计个数0 1 2，然后rewrite 的array。 Two pass algorithm

// 没有实现

// - (void)sortedColors:(NSMutableArray *)nums
// {
//     NSInteger i = 0;
//     NSInteger j = [nums count] - 1;

//     while(i < j) {
//         while(i < j && nums[i].integerValue == 0) {
//             i++;
//         }
//         while(i < j && nums[j].integerValue == 2) {
//             j--;
//         }
//         if(nums[i].integerValue > nums[i].integerValue) {

//         }

//     }
//     return nums;
// }

// 记住这几个 index 的位置 九章算法版本
// 0......0   1......1  x1 x2 .... xm   2.....2
//        |             |           |
//       left          cur         right

- (void)sortedColors:(NSMutableArray<NSNumber *> *)nums
{
    if([nums count] <= 1) {
        return;
    }

    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    NSInteger cur = 0;
    while(cur <= right) {
        if(nums[cur].integerValue == 0) {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:left];
            cur++;
            left++;
        } else if(nums[cur].integerValue == 1) {
            cur++;
        } else {
            [nums exchangeObjectAtIndex:cur withObjectAtIndex:right];
            right--;
        }
    }
}

//prove the correctness of alogrithm
// leftmost element is always larger than right most
// campare the mid of the element with left most
//

// corner case: 是否元素唯一
// [1, 2] , [2, 1]
// *****

// 和Search in Rotated Sorted Array I这题换汤不换药。同样可以根据A[mid]和A[end]来判断右半数组是否sorted：
// 原数组：0 1 2 4 5 6 7
// 情况1：  6 7 0 1 2 4 5   
// 情况2：  2 4 5 6 7 0 1  
// (1) A[mid] < A[end]：A[mid : end] sorted => min不在A[mid+1 : end]中
// 搜索A[start : mid]
// (2) A[mid] > A[end]：A[start : mid] sorted且又因为该情况下A[end]<A[start] => min不在A[start : mid]中
// 搜索A[mid+1 : end]
// (3) base case：
// a. start =  end，必然A[start]为min，为搜寻结束条件。
// b. start + 1 = end，此时A[mid] =  A[start]，而min = min(A[mid], A[end])。而这个条件可以合并到(1)和(2)中。

- (NSNumber *)findMin:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");

    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue < nums[right].integerValue) {
            right = mid;
        } else if(nums[mid].integerValue > nums[right].integerValue) {
            left = mid + 1; 
        }
    }
    return nums[left];
}

// mid with left ，需要特殊处理没有排序的情况
- (NSNumber *)findMin_my:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");

    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        //not rotate case
        if(nums[left] < nums[right]) {
            return nums[left];
        }
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue > nums[left].integerValue) {
            left = mid + 1;
        } else if(nums[mid].integerValue > nums[left].integerValue) {
            right = mid; 
        }
    }
    return nums[left];
}

- (NSNumber *)findMin2:(NSArray<NSNumber *> *)nums
{
    NSAssert([nums count] > 0, @"");

    NSInteger left = 0;
    NSInteger right = [nums count] - 1;
    
    while(left < right) {
        NSInteger mid = (right - left) / 2 + left;
        if(nums[mid].integerValue < nums[right].integerValue) {
            right = mid;
        } else if(nums[mid].integerValue > nums[right].integerValue) {
            left = mid + 1; 
        } else {
            right--; // 这里不能写成left++
        }
    }
    return nums[left];
}

// https://discuss.leetcode.com/topic/17063/4ms-o-n-8ms-o-nlogn-c
// Binary Search 的实现有些复杂 Olg(n). TODO： 可以自己实现下

- (NSInteger)minimumSizeSubArraySum:(NSInteger)s nums:(NSArray<NSNumber *> *)nums
{
    NSInteger start = 0;
    NSInteger minSize = NSIntegerMax;
    NSInteger sum = 0;

    for(NSInteger i = 0; i < [nums count]; i++) {
        sum += nums[i].integerValue;
        while(sum >= s) {
            minSize = MIN(minSize, i - start + 1);
            sum = sum - nums[start].integerValue;
            start++;
        }
    }
    return minSize == NSIntegerMax ? 0 : minSize;
}

// 注意over flow 
// O(n * n) brute force 假设不会溢出
// 没想到 one pass 的方法 
// DP
//

- (NSInteger)maxProduct:(NSArray<NSNumber *> *)nums
{
    NSInteger count = [nums count];
    NSMutableArray<NSNumber *> *maxProduct = [NSMutableArray array];
    NSMutableArray<NSNumber *> *minProduct = [NSMutableArray array];
    [maxProduct addObject:nums[0]];
    [minProduct addObject:nums[0]];

    NSInteger maxRes = nums[0].integerValue;
    for(NSInteger j = 1; j < count; j++) {
        NSInteger curr = nums[j].integerValue;
        
        if(nums[j].integerValue >= 0) {
            [maxProduct addObject:@(MAX(curr, curr * maxProduct[j-1].integerValue))];
            [minProduct addObject:@(MIN(curr, curr * minProduct[j-1].integerValue))];
        } else {
            [maxProduct addObject:@(MAX(curr, curr * minProduct[j-1].integerValue))];
            [minProduct addObject:@(MIN(curr, curr * maxProduct[j-1].integerValue))];
        }
        maxRes = MAX(maxRes, maxProduct[j].integerValue);
    } 
    return maxRes;
}

- (NSInteger)maxProduct_OptimizeSpace:(NSArray<NSNumber *> *)nums
{
    NSInteger count = [nums count];
    NSInteger currMax = [nums firstObject].integerValue;
    NSInteger currMin = currMax;

    NSInteger maxRes = nums[0].integerValue;
    for(NSInteger j = 1; j < count; j++) {
        NSInteger curr = nums[j].integerValue;
        NSInteger prevMax = currMax;
        currMax = MAX(MAX(prevMax * curr, currMin * curr), curr);
        currMin = MIN(MIN(currMin * curr, prevMax * curr), curr);
        maxRes = MAX(maxRes, currMax);
    } 
    return maxRes;
}

@end
