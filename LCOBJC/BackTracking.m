//
//  BackTracking.m
//  LCOBJC
//
//  Created by ethon_qi on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "BackTracking.h"
#import "Tree.h"

@implementation BackTracking

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

// 可以先暂时用 array 来存储中间结果，最后加入到结果集合里面的时候 在做一次 array ---> string 的转换
// 注释部分的代码是二次优化的时候写的

- (void)binaryTreePath:(TreeNode *)node prefixStr:(NSMutableArray *)prefixStr array:(NSMutableArray *)array
{
    if(!node){
        return;
    }
    [prefixStr addObject:@(node.val)];
    if(!node.left && !node.right) { // 1: backtracking 枚举的终止条件
        // [prefixStr appendString:[NSString stringWithFormat:@"%ld", (long)node.val]];
//        [prefixStr addObject: @(node.val)];
        [array addObject: [prefixStr componentsJoinedByString:@"->"]];
        [prefixStr removeLastObject];
        return;
    }
    // if(node.left) {
        // [prefixStr addObject:@(node.val)];
        [self binaryTreePath:node.left prefixStr:prefixStr array:array];
        // [prefixStr removeLastObject];
    // }
    // if(node.right) {
        // [prefixStr addObject:@(node.val)];
        [self binaryTreePath:node.right prefixStr:prefixStr array:array];
        // [prefixStr removeLastObject];
    // }
            [prefixStr removeLastObject];
}

// 用DFS 迭代如何实现呢？ preorder
// 迭代解法 3: Stack + 自定义 StackFrame

// 这种做法最有意思，我也最喜欢，觉得只要有合适的 field 属性，很容易 generalize 到各种其他递归解法中。
// 首先对于二叉树，我们可以这样定义 StackFrame 的三个状态：
// 0 : 刚入栈，未访问子树；
// 1 : 正在访问左子树，返回代表左子树访问完毕；
// 2 : 正在访问右子树，返回代表右子树访问完毕；
// 这样代码如下，每次 stack 里存的，都是当前路径 (配合一个 List 做高效 print path 操作)，
// 而每次栈顶的 StackFrame 都记录了当前 node 的访问状态和下一步的动向。
// 这种 0/1/2 的状态表示方式看着有点像 Graph 里面做 DFS / BFS 的标注，其实不完全一样，只是在这题我们的树一定是二叉而已。
// 对于多叉树的情况，改动也不会很难；这次 index 代表着 “下一个要访问的 child index”，
// 当 index == children.size() 的时候，我们就可以知道当前 node 的所有子节点都访问完了。

// 关键:在Preorder traverse t同时 记录 path

- (NSArray<NSString *> *)binaryTreePath_dfs_iterative:(TreeNode *)node
{
    if(!node){
        return nil;
    }
    NSMutableArray *stack = [NSMutableArray array];
    [stack addObject:node];
    NSMutableArray *pathStack = [NSMutableArray array];

    NSMutableArray *path = [NSMutableArray array];
    NSMutableString *str = [NSMutableString string];
    [pathStack addObject:str];

    while([stack count]){   
        TreeNode *node = stack.firstObject;
        [stack removeLastObject];

        str = pathStack.firstObject;
        [pathStack removeLastObject];
        
        [str appendString:[NSString stringWithFormat:@"%@->", @(node.val)]];

        if(!node.left && !node.right){
            [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];//remove the "->"
            [path addObject:[str copy]];
        }
        if(node.right){
            [stack addObject:node.right];
            [pathStack addObject:[str mutableCopy]];
        }
        if(node.left){
            [stack addObject:node.left];
            [pathStack addObject:[str mutableCopy]];
        }
    }
    return path;
}

// BFS Binary tree Paths 速度不够快, 并且不是最优方案
// optimize the solution
//    2
//  1   3
// 4 5
// T : O(n)  S: O(n) * log(n)

- (NSArray<NSString *> *)binaryTreePath_bfs_iterative:(TreeNode *)node
{
    if(!node){
        return nil;
    }
    
    NSMutableArray<NSArray *> *paths = [NSMutableArray array];// store the node root to the current node while doing bfs search
    NSMutableArray<NSString *> *res = [NSMutableArray array];
    [paths addObject:@[node]];

    while([paths count]){
        NSArray<TreeNode *> *path = paths.firstObject; //
        [paths removeObjectAtIndex:0];
        
        TreeNode *curr = path.lastObject;
        if(!curr.left && !curr.right){
            [res addObject:[path componentsJoinedByString:@"->"]];
        }
        
        if(curr.left){
            NSMutableArray *newPath = [NSMutableArray arrayWithArray:path];
            [newPath addObject:curr.left];
        }
        if(curr.right){
            NSMutableArray *newPath = [NSMutableArray arrayWithArray:path];
            [newPath addObject:curr.right];
        }
    }
    return res;
}

#pragma mark - Binary tree path based on linkedlist

//based on List, 链表可以被覆盖掉，所以不需要backtracking

- (void)binaryTreePath_baseList:(TreeNode *)node prefixStr:(ListNode *)head prevNode:(ListNode *)prev array:(NSMutableArray *)array
{
    if(!node){
        return;
    }

    ListNode *currNode = [ListNode new];
    currNode.val = node.val;
    if(prev){
        prev.next = currNode;
    }
    if(!head.next){        
        head.next = currNode;
    }

    if(!node.left && !node.right){
//        [array addObject:[head clone]];// clone the list
        return;
    }

    [self binaryTreePath_baseList:node.left prefixStr:head prevNode:prev.next array:array];
    [self binaryTreePath_baseList:node.right prefixStr:head prevNode:prev.next array:array];
}

#pragma mark - 79. Word Search

- (BOOL)existWithBoard:(NSArray<NSArray<NSString *> *> *)board word:(NSString *)word
{
    NSInteger m = [board count];
    NSInteger n = [[board firstObject] count];
    //initilize visited array
    NSMutableArray *visited = [NSMutableArray arrayWithCapacity:m];
    for(NSInteger i = 0; i < m; i++) {
        NSMutableArray *subArray = [NSMutableArray arrayWithCapacity:n];
        for(NSInteger j = 0; j < n; j++) {
            [subArray addObject:@(NO)];
        }
        [visited addObject:subArray];
    }

    for(NSInteger i = 0; i < m; i++) {
        for(NSInteger j = 0; j < n; j++) {
            if([self _findBoard:board x:i y:j word:word index:0 visited:visited]) {
                return YES;
            }
        }
    }
    return NO;
}

//helper method
//http://www.jiuzhang.com/solutions/word-search/
// Time complexity: 这里要注意时间复杂度：虽然有四个方向,但是有一个方向是回去的, 那么就会prune 掉 所以是三个真正有效的是三个方向，所以base 是3
// T: m * n * 3 ^ l  m =  width  n = length  3 is base or the direction it can try  . l is the length of the string

- (BOOL)_findBoard:(NSArray<NSArray *> *)board x:(NSInteger)x y:(NSInteger)y word:(NSString *)word index:(NSInteger)idx visited:(NSMutableArray<NSMutableArray *> *)visited
{
    if(idx == [word length]) {
        return YES;
    }
    //break, 棋盘的break 规则和 find path in matrix , island 有overlap 的地方
    NSString *cha = [word substringWithRange:NSMakeRange(idx, 1)];
    if(x < 0 || y < 0 || x >= [board count] || y >= [[board firstObject] count] || [visited[x][y] boolValue] || ![board[x][y] isEqualToString:cha]) {
        return NO;
    }
    visited[x][y] = @(YES); 
    BOOL isFound = [self _findBoard:board x:x-1 y:y word:word index:idx+1 visited:visited] ||
                   [self _findBoard:board x:x y:y-1 word:word index:idx+1 visited:visited] ||
                   [self _findBoard:board x:x+1 y:y word:word index:idx+1 visited:visited] ||
                   [self _findBoard:board x:x y:y+1 word:word index:idx+1 visited:visited];
    visited[x][y] = @(NO);
    return isFound;
}

//先来个递归版本，再来个迭代 DFS的思路

//FIXME: Fellow up

//What is time and space complexity of iterative BFS solutions, why?
//What is time and space complexity of iterative DFS solutions, why?
//What is time and space complexity of recursive BFS solutions, why?
//What is time and space complexity of recursive DFS solutions, why?Which approach has better time and space, why
//What if 数字对应的字母可以任意改变 e.g. 1: "abcde", 2: "", 3: "f", ... then
//What is time and space complexity of ... ?
//Which approach has better time and space, why?

#pragma mark  letter Combinations
//Follow up http://www.1point3acres.com/bbs/forum.php?mod=viewthread&tid=160432&extra=page%3D12%26filter%3Dsortid%26sortid%3D311%26searchoption%5B3046%5D%5Bvalue%5D%3D2%26searchoption%5B3046%5D%5Btype%5D%3Dradio%26sortid%3D311

// T: O(length) * O(length of str in map) *
// T: O(n) * O(k) * O(k^n)

- (NSArray<NSString *> *)letterCombinations:(NSString *)digits
{
    if(digits.length == 0) {
        return nil;
    }
    NSDictionary<NSString*, NSString*> *map = @{ @"1" : @"",
                                                 @"2" : @"abc",
                                                 @"3" : @"def",
                                                 @"4" : @"ghi",
                                                 @"5" : @"jkl",
                                                 @"6" : @"mno",
                                                 @"7" : @"pqrs",
                                                 @"8" : @"tuv",
                                                 @"9" : @"wxyz",
                                                 @"0" : @"" };
    
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    [result addObject:[@"" mutableCopy]];

    for(NSInteger i = 0; i < digits.length; i++) {
        NSString *key = [digits substringWithRange:NSMakeRange(i, 1)];
        NSString *mStr = map[key];
        if(mStr.length) { //！！！这里要添加空字符串的判断
            NSInteger count = [result count];
            NSMutableArray *temp = [NSMutableArray array];
            
            for(NSInteger j = 0; j < mStr.length; j++){ // 
                NSString *ch = [mStr substringWithRange:NSMakeRange(j, 1)];
                for(NSInteger k = 0; k < count; k++) {
                    [temp addObject:[result[k] stringByAppendingString:ch]];
                }
            }
            result = temp;
        }
    }
    return result;
}

- (NSArray<NSString *> *)letterCombinations_dfs:(NSString *)digits
{
    if(digits.length == 0) {
        return nil;
    }
    NSDictionary<NSString*, NSString*> *map = @{ @"1" : @"",
                                                 @"2" : @"abc",
                                                 @"3" : @"def",
                                                 @"4" : @"ghi",
                                                 @"5" : @"jkl",
                                                 @"6" : @"mno",
                                                 @"7" : @"pqrs",
                                                 @"8" : @"tuv",
                                                 @"9" : @"wxyz",
                                                 @"0" : @"" };
  NSMutableArray *result = [NSMutableArray array];
  [self doLetterCombinations:digits start:0 prefix:[@"" mutableCopy] result:result dic:map];
  return result;
}

- (void)doLetterCombinations:(NSString *)digits start:(NSInteger)start prefix:(NSMutableString *)prefix result:(NSMutableArray *)result dic:(NSDictionary *)map;
{
    if(start == digits.length) {  //这里的判断条件 是length， 不是length - 1！！！
        [result addObject:[prefix copy]];
        return;
    }

    NSString *ch = [digits substringWithRange:NSMakeRange(start, 1)];
    NSString *alphaValue = map[ch];
    if(alphaValue.length == 0) { //skip current
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
    }
    for(NSInteger i = 0; i < alphaValue.length; i++){
        NSString *ch = [alphaValue substringWithRange:NSMakeRange(i, 1)];
        [prefix appendString:ch];//[str appendString:ch];
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
        [prefix deleteCharactersInRange:NSMakeRange(prefix.length - 1, 1)];
    }
}

// BFS 就靠 Queue，以 queue 首长度 == i 来判断层数，反复做 join. 另外维护一个 String[] 用作字典查询

// BFS
// public List<String> letterCombinations(String digits) {
//     LinkedList<String> ans = new LinkedList<String>();
//     if(digits.length == 0){
//       return ans;
//     }
//     String[] mapping = new String[] {"0", "1", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
//     ans.add("");
//     for(int i =0; i<digits.length();i++){
//         int x = Character.getNumericValue(digits.charAt(i));
//         while(ans.peek().length()==i){
//             String t = ans.remove();
//             for(char s : mapping[x].toCharArray())
//                 ans.add(t+s);
//         }
//     }
//     return ans;
// }

// 这种也是要输出所有结果。and 这些结果保证不重复

#pragma mark Combination Sum I

//- (NSArray<NSArray *> *)combinationSum:(NSArray *)array target:(NSInteger)target
//{
//    if(target <= 0 || [array count] == 0){
//        return nil;
//    }
//    NSMutableSet *result = [NSMutableSet set];
//    [self _doCombinationSum:array target:target result:result currResult:[@[] mutableCopy]];
//
//    return [result allObjects]; 
//}
//
//- (void)_doCombinationSum:(NSArray<NSNumber *> *)array target:(NSInteger)target result:(NSMutableSet *)result currResult:(NSMutableArray<NSNumber *> *)curr
//{
//    if(target == 0) {
//        NSArray *sorted = [curr sortedArrayUsingSelector:@selector(compare:)];
//        if(![result containsObject:sorted]) {
//            [result addObject:curr]; //sorted first then insert
//        }
//        return;
//    }
//    
//    for(NSInteger i = 0; i < [array count]; i++){
//        NSInteger nextTarget = target - array[i].integerValue;
//        if(nextTarget >= 0) {
//            [curr addObject:array[i]];
//            [self _doCombinationSum:array target:nextTarget result:result currResult:curr];
//            [curr removeLastObject]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
//        }
//    }
//}

// 上面这种方法是在最终搜索到解的情况下进行去重判断，这样就相当于在搜索的过程中，有很多无效的搜索。

- (NSArray<NSArray *> *)combinationSum:(NSArray *)array target:(NSInteger)target
{
    if(target <= 0 || [array count] == 0){
        return nil;
    }
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];// 1.先排序
    NSMutableArray *result = [NSMutableArray array];
    [self _doCombinationSum:sortedArray start:0 target:target result:result currResult:[@[] mutableCopy]];

    return result; 
}

- (void)_doCombinationSum:(NSArray<NSNumber *> *)array start:(NSInteger)start target:(NSInteger)target result:(NSMutableArray *)result currResult:(NSMutableArray<NSNumber *> *)curr
{
    if(target == 0) {
        [result addObject:[curr copy]]; //sorted first then insert
        return;
    }
    for(NSInteger i = start; i < [array count]; i++){
        // skip duplicate, 这里需要确认array里面是否包含重复的数据结构
        if(i > start && array[i].integerValue == array[i-1].integerValue){ //用来过滤input nums 是否有重复
            continue;
        }
        NSInteger nextTarget = target - array[i].integerValue;
        if(nextTarget >= 0) {
            [curr addObject:array[i]]; //如果需要确保结果集合是没有重复的，但是元素是可以重复使用的,直接将i递归下,如果将start传递下去，就会出现重复的如[3, 4] [4, 3] 之类的
            [self _doCombinationSum:array start:i target:nextTarget result:result currResult:curr];// 这里是i还是i+1,取决于元素是否只能用一次 
            [curr removeLastObject]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
        }
    }
}

- (NSArray<NSArray *> *)combinationSum_2:(NSArray *)array target:(NSInteger)target
{
    if(target <= 0 || [array count] == 0){
        return nil;
    }
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *result = [NSMutableArray array];
    [self _doCombinationSum_optimize_2:sortedArray start:0 target:target result:result currResult:[@[] mutableCopy]];

    return result; 
}

- (void)_doCombinationSum_optimize_2:(NSArray<NSNumber *> *)array start:(NSInteger)start target:(NSInteger)target result:(NSMutableArray *)result currResult:(NSMutableArray<NSNumber *> *)curr
{
    if(target == 0) {
        [result addObject:[curr copy]]; //sorted first then insert
        return;
    }
    for(NSInteger i = start; i < [array count]; i++){
        // skip duplicate, 这里需要确认array里面是否包含重复的数据结构
        if(i > start && array[i].integerValue == array[i-1].integerValue){
            continue;
        }
        NSInteger nextTarget = target - array[i].integerValue;
        if(nextTarget >= 0) {
            [curr addObject:array[i]]; //如果需要确保结果集合是没有重复的，但是元素是可以重复使用的,直接将i递归下
            [self _doCombinationSum_optimize_2:array start:i+1 target:nextTarget result:result currResult:curr];
            [curr removeLastObject]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
        }
    }
}

- (NSArray<NSArray *> *)combinationSum_3:(NSInteger)sum count:(NSInteger)k
{
    if (sum <= 0 || sum > 45) {
        return nil; //
    }
    NSMutableArray *result = [NSMutableArray array];
    [self _doCombinationSum_3:result temp:[@[] mutableCopy] sum:sum start:1 count:k];
    
    return [result copy];
}

- (void)_doCombinationSum_3:(NSMutableArray *)result temp:(NSMutableArray *)temp sum:(NSInteger)sum start:(NSInteger)start count:(NSInteger)k
{
    if(sum == 0 && [temp count] == k){
        [result addObject:[temp copy]];
        return;
    }
    if(sum < 0 || [temp count] >= k){
        return;
    }
    for (NSInteger i = start ; i <= 9; i++) {
        [temp addObject: @(i)];
        [self _doCombinationSum_3:result temp:temp sum:sum - i start:i + 1 count:k];
        [temp removeLastObject];
    }
}

#pragma mark - Permutations

- (NSArray<NSArray *> *)permut:(NSArray<NSNumber *> *)nums
{
    NSMutableArray *array = [NSMutableArray array];
    [self _permut:[nums mutableCopy] index:0 result:array];
    return array;
}

// 第一种解法：标准解法 swap index 和后面所有的元素.

- (void)_permut:(NSMutableArray<NSNumber *> *)nums index:(NSInteger)index result:(NSMutableArray *)result
{
    if(index == nums.count){
        [result addObject:[nums copy]];
        return;
    }
    for(NSInteger i = index; i < nums.count; i++){
        [nums exchangeObjectAtIndex:i withObjectAtIndex:index]; //
        [self _permut:nums index:index+1 result:result];
        [nums exchangeObjectAtIndex:index withObjectAtIndex:i];
    }
}

// 第二种解法，利用visited 排除重复, 高中数学就是这个思路

- (void)_permut:(NSMutableArray<NSNumber *> *)nums temp:(NSMutableArray *)temp result:(NSMutableArray *)result visited:(NSMutableArray<NSNumber *> *)visited
{
    if(temp.count == nums.count){
        [result addObject:[temp copy]];
        return;
    }
    for(NSInteger i = 0; i < nums.count; i++){
        if(visited[i].boolValue){
            continue;
        }
        visited[i] = @(YES);
        [temp addObject:nums[i]];
        [self _permut:nums temp:temp result:result visited:visited];
        [temp removeLastObject];
        visited[i] = @(NO);
    }
}

// 第三种迭代枚举写法，我比较擅长的解法
// T(o) = n!

- (NSArray<NSArray *> *)permut_i:(NSArray<NSNumber *> *)nums// handle empty string
{
    NSMutableArray<NSArray *> *result = [NSMutableArray arrayWithObject:@[nums[0]]];
    for (NSInteger i = 1; i < nums.count; i++) {
        NSMutableArray *temp = [NSMutableArray array];
        for(NSArray *sub in result){
            for (NSInteger j = 0; j <= sub.count; j++) {
                NSMutableArray *newResult = [NSMutableArray arrayWithArray:sub];
                [newResult insertObject:nums[i] atIndex:j];
                [temp addObject:newResult];
            }
        }
        result = temp;
    }
    return result;
}

//有重复元素
#pragma mark Permutations 2

- (NSArray<NSArray *> *)permut2:(NSArray<NSNumber *> *)nums
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *sortedNums = [nums sortedArrayUsingSelector:@selector(compare:)];
    [self _permut2:[sortedNums mutableCopy] index:0 result:array];
    return array;
}

//这道题目比我想象中的复杂
//解法1: 根据Permutations的第二种解法的基础上改动

//关键: 1.visited[i-1].boolValue == NO 前面的必须使用了，才可以使用当前的 2. input nums 需要sort
//这里的关键1 确实不太好理解:举个例子，假设这里第一个选的 2,第二个可能是1,这是灰出现两个 1,1.这时候痛过这种方式来进行去重，只有前面那个选了，才选第二1.
//             /*
//             上面的判断主要是为了去除重复元素影响。
//             比如，给出一个排好序的数组，[1,2,2]，那么第一个2和第二2如果在结果中互换位置，
//             我们也认为是同一种方案，所以我们强制要求相同的数字，原来排在前面的，在结果
//             当中也应该排在前面，这样就保证了唯一性。所以当前面的2还没有使用的时候，就
//             不应该让后面的2使用。
//             */
- (void)_permut2:(NSMutableArray<NSNumber *> *)nums temp:(NSMutableArray *)temp result:(NSMutableArray *)result visited:(NSMutableArray<NSNumber *> *)visited
{
    if(temp.count == nums.count){
        [result addObject:[temp copy]];
        return;
    }
    for(NSInteger i = 0; i < nums.count; i++){
        if(visited[i].boolValue){
            continue;
        }
        if (i > 0 && nums[i].integerValue == nums[i-1].integerValue && visited[i-1].boolValue == NO) { 
            continue;
        }
        visited[i] = @(YES);
        [temp addObject:nums[i]];
        [self _permut2:nums temp:temp result:result visited:visited];
        [temp removeLastObject];
        visited[i] = @(NO);
    }
}

//解法1: 根据Permutations的第1种解法的基础上改动
//这种交换办法还要再想想
// 112
// 112 121 
// 211 112

- (void)_permut2:(NSMutableArray<NSNumber *> *)nums index:(NSInteger)index result:(NSMutableSet *)result
{
    if(index == nums.count){
        if(![result containsObject:[nums copy]]){
            [result addObject:[nums copy]];
        }
        return;
    }
    for(NSInteger i = index; i < nums.count; i++) {
        if(i != index && nums[i].integerValue == nums[i-1].integerValue){
            continue;
        }
        [nums exchangeObjectAtIndex:index withObjectAtIndex:i];
        [self _permut2:nums index:index+1 result:result];
        [nums exchangeObjectAtIndex:index withObjectAtIndex:i];
    }
}

#pragma mark - 31. Next Permutation [R] Need 默

// 这个题目的技巧性略强
// permutation 序列中比这个大的元素中的最小的一个
//
//https://discuss.leetcode.com/topic/15216/a-simple-algorithm-from-wikipedia-with-c-implementation-can-be-used-in-permutations-and-permutations-ii/2

// 1) scan from right to left, find the first element that is less than its previous one
//    4 5 6 3 2 1
//      |
//      p
// 2)scan from right to left, find the first element that is greater than p.
//    4 5 6 3 2 1
//        |
//        q
// swap p and q
//    4 5 6 3 2 1
//    swap
//    4 6 5 3 2 1
// 4) reverse elements [p+1, nums.length]
//  4 6 1 2 3 5

- (void)nextPermutation:(NSMutableArray *)nums
{
    if (nums == nil || [nums count] < 2) {
        return;
    }
    NSInteger p = - 1;
    for (NSInteger i = nums.count - 2; i >= 0; i--) {
        if (nums[i] < nums[i+1]) {
            p = i;
            break;
        }
    }
    if (p == -1) {
        [self _reverse:nums low:0 high:nums.count-1];
        return;
    }
    NSInteger s = -1;
    for (NSInteger i = nums.count - 1; i > p; i--) {
        if (nums[i] > nums[p]) {
            s = i;
            break;
        }
    }
    [nums exchangeObjectAtIndex:p withObjectAtIndex:s];
    
    [self _reverse:nums low:p + 1 high:nums.count-1];
}

- (void)_reverse:(NSMutableArray *)array low:(NSInteger)low high:(NSInteger)high
{
    while (low < high) {
        [array exchangeObjectAtIndex:low withObjectAtIndex:high];
        low++;
        high--;
    }
}

// previous permutation
// FIXME: 高频!!  区别正好是 前面两个循环的判断条件 相反

//1. Find largest index i such that str[i – 1] > str[i].
//2. Find largest index j such that j >= i and str[j] < str[i - 1].
//3. Swap str[j] and str[i - 1].
//4. Reverse the sub-array starting at str[i].

- (void)previousPermutation:(NSMutableArray *)nums
{
    if (nums == nil || [nums count] < 2) {
        return;
    }
    NSInteger p = - 1;
    for(NSInteger i = nums.count - 2; i >= 0; i--){
        if(nums[i] > nums[i + 1]){
            p = i;
            break;
        }
    }
    // FIXME: 如果一开始是升序列，那么他的previous 可以是最大的那个组合，这里要和面试官确认
    if(p == -1){
        [self _reverse:nums low:0 high:nums.count-1];
        return;
    }
    
    NSInteger q = -1;
    for (NSInteger i = nums.count - 1; i >= p; i--) {
        if(nums[i] < nums[p]){
            q = i;
            break;
        }
    }
    [nums exchangeObjectAtIndex:p withObjectAtIndex:q];
    [self _reverse:nums low:p + 1 high:nums.count-1];

}

//找到数学规律
// http://bangbingsyb.blogspot.hk/2014/11/leetcode-permutation-sequence.html
// 有空写一下
//"123"
//"132"
//"213"
//"231"
//"312"
//"321"

//- (NSString *)getPermutation:(NSInteger)n kth:(NSInteger)k
//{
//    
//}

#pragma mark - Palindrome

//TODO: 132. Palindrome Partitioning II

- (NSArray<NSArray<NSString *> *> *)partition:(NSString *)str;
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    [self _partition:str start:0 temp:temp result:result];
    return result;
}
// aaaaaaaaaaa
//  |....|
//  s    i
//  s range 0..<len
//  i range s..<len

- (void)_partition:(NSString *)str start:(NSInteger)start temp:(NSMutableArray *)temp result:(NSMutableArray *)result
{
    if (start == str.length) {
        [result addObject:[temp copy]];
        return;
    }
    for (NSInteger i = start; i < str.length; i++) {
        if([self _isPalindrome:str low:start high:i]){
            [temp addObject:[str substringWithRange:NSMakeRange(start, i - start + 1)]];
            [self _partition:str start:i+1 temp:temp result:result];
            [temp removeLastObject];
        }
    }
}

- (BOOL)_isPalindrome:(NSString *)str low:(NSInteger)low high:(NSInteger)high
{
    while (low < high) {
        NSString *ch = [str substringWithRange:NSMakeRange(low, 1)];
        NSString *ch2 = [str substringWithRange:NSMakeRange(high, 1)];
        if(![ch isEqualToString:ch2]){
            return NO;
        }
        low++;
        high--;
    }
    return YES;
}

//- (NSInteger)numberOfPalindrome:(NSString *)str
//{
//
//}

//这题目有动态规划可以弄，DP不局限于找最优解之类

#pragma mark Combinations

//method 1: BackTracking

- (NSArray<NSArray<NSNumber *> *> *)combineNumber:(NSInteger)n k:(NSInteger)k
{
    if (k == 0 || n == 0 || k > n) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array]; // 这里需要改成Array
    NSMutableArray *temp = [NSMutableArray array];

    [self _doCombinNumber:n start:1 k:k temp:temp result:result];
    return result;
}

//这里的T(n) n * n - 1 * n - 2, 算法复杂度

- (void)_doCombinNumber:(NSInteger)n start:(NSInteger)start k:(NSInteger)k temp:(NSMutableArray *)temp result:(NSMutableArray *)result
{
    if(k == 0){
        NSArray *sub = [temp copy];
        [result addObject:sub];
        return;
    }
    for(NSInteger i = start; i <= n ;i++){
        [temp addObject:@(i)];
        [self _doCombinNumber:n start:i+1 k:k - 1 temp:temp result:result];//注意这里需要把 i+1 传递下去
        [temp removeLastObject];
    }
}

//method 2: 递归

- (NSArray<NSArray<NSNumber *> *> *)combineNumberMethod2:(NSInteger)n k:(NSInteger)k
{
    if(k == 0 || k > n || n == 0){
        return nil;
    }
    if(k == 1){
        NSMutableArray *subArray = [NSMutableArray array];
        for(NSInteger i = 1; i <= n; i++){
            [subArray addObject:@[@(i)]];
        }
        return subArray;
    }

    NSArray *sub1 = [self combineNumberMethod2:n-1 k:k]; // not chose n pick k elements from n - 1
    NSArray *sub2 = [self combineNumberMethod2:n-1 k:k-1]; // chose n
    
    //merge the result;
    NSMutableArray *result = [NSMutableArray arrayWithArray:sub1];
    
    for(NSArray *item in sub2){
        NSMutableArray *res = [NSMutableArray arrayWithArray:item];
        [res addObject:@(n)];
        [result addObject:res];
    }
    return result;
}

//method 2: 枚举

- (NSSet<NSSet<NSNumber *> *> *)combineNumberMethod3:(NSInteger)n k:(NSInteger)k
{
    if(k == 0 || k > n || n == 0){
        return nil;
    }
    
    NSMutableSet<NSMutableSet *> *result = [NSMutableSet set];
    for (NSInteger i = 1; i <= n; i++) {
        [result addObject:[NSMutableSet setWithObject:@(i)]];
    }
    
    for (NSInteger i = 2; i <= k; i++) {
        NSMutableSet *temp = [NSMutableSet set];
        
        for (NSInteger j = 1; j <= n; j++) {
            for (NSMutableSet *set in result) {
                if(![set containsObject:@(j)]){
                    [set addObject:@(j)];
                    if(![temp containsObject:set]){
                        [temp addObject:set];
                    }
                }
            }
        }
        result = temp;
    }
    return result;
}

#pragma mark - 10. Regular Expression Matching
//递归版本
- (BOOL)isMatch:(NSString *)str withPatten:(NSString *)p 
{   //handle emtpy case
    NSAssert(str, @"");
    NSAssert(p, @"");
    if(p.length == 0){
        return str.length == 0;
    }
    
    return [self _isMatch_recursive:str strIndex:0 withPatten:p pattenIndex:0];
}

//If the next character of p is NOT ‘*’, then it must match the current character of s. Continue pattern matching with the next character of both s and p.
//If the next character of p is ‘*’, then we do a brute force exhaustive matching of 0, 1, or more repeats of current character of p… Until we could not match any more characters.

// http://articles.leetcode.com/regular-expression-matching

- (BOOL)_isMatch_recursive:(NSString *)str strIndex:(NSInteger)i withPatten:(NSString *)p pattenIndex:(NSInteger)j
{
    if(j == p.length){
        return i == str.length;
    }
    NSString *nextCh = @"";
    if(p.length > j + 1){
        nextCh = [str substringWithRange:NSMakeRange(j + 1, 1)];
    }
    
    NSString *strCh = [str substringWithRange:NSMakeRange(i, 1)];
    NSString *pCh = [p substringWithRange:NSMakeRange(j, 1)];
    
    if([nextCh isEqualToString:@"*"]) {
        if ([self _isMatch_recursive:str strIndex:i withPatten:p pattenIndex:j + 2]) { //"bcd" vs "a*bcd" 这种不管当前有没有相等，如果直接跳过。
            return YES;
        }
        while ([[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:pCh] || [pCh isEqualToString:@"."]) { // "abcd" vs "a*bcd"
            if ([self _isMatch_recursive:str strIndex:++i withPatten:p pattenIndex:j + 2]) { // bcd vs "bcd"
                return YES;
            }
        }
    } else {
        return ([strCh isEqualToString:pCh] || [pCh isEqualToString:@"."]) && // case 2: 下一个不是“*”，所以当前ch 得匹配上 “abc” -- "abd"
                [self _isMatch_recursive:str strIndex:i + 1 withPatten:p pattenIndex:j + 1]; // 匹配下一个
    }
    return NO;
}

// 如果是两个string，每个字符串相互关联,就用二维数组
// 各种case 应该考虑全面
// https://discuss.leetcode.com/topic/17901/accepted-c-dp-solution-with-a-trick/2

/**
* f[i][j]: if s[0..i-1] matches p[0..j-1]
* if p[j - 1] != '*'
*      f[i][j] = f[i - 1][j - 1] && s[i - 1] == p[j - 1]
* if p[j - 1] == '*', denote p[j - 2] with x
*      f[i][j] is true iff any of the following is true
*      1) "x*" repeats 0 time and matches empty: f[i][j - 2]
*      2) "x*" repeats >= 1 times and matches "x*x": s[i - 1] == x && f[i - 1][j]
* '.' matches any single character
*/

- (BOOL)isMatch_dp:(NSString *)str withPatten:(NSString *)p
{
    NSInteger m = str.length;
    NSInteger n = p.length;

    NSMutableArray<NSMutableArray<NSNumber *> *> *map = [NSMutableArray array];
    for(NSInteger i = 0; i <= m; i++){
        NSMutableArray<NSNumber *> *sub = [NSMutableArray array];
        for(NSInteger j = 0; j <= n; j++){
            [sub addObject:@(NO)];
        }
        [map addObject:sub];
    }

    
    map[0][0] = @(YES);
    map[0][1] = @(NO);// 特殊处理下 str 是空，p 是一个字符此时是NO
    
//    for(NSInteger i = 1; i <= m; i++){ // p is emtpy
//        map[i][0] = @(NO);
//    }
    for(NSInteger j = 2; j <= n; j++){ // str is emtpy. start from 2
        map[0][j] = @(map[0][j - 2].boolValue && [[p substringWithRange:NSMakeRange(j - 1, 1)] isEqualToString:@"*"]);
    }
    
    for(NSInteger i = 1; i <= m; i++){
        for(NSInteger j = 1; j <= n; j++) {
            NSString *strCh = [str substringWithRange:NSMakeRange(i - 1 , 1)];
            NSString *pCh = [p substringWithRange:NSMakeRange(j - 1, 1)];
            if([pCh isEqualToString:@"*"]) {// j >= 2
                NSString *prevCh = [p substringWithRange:NSMakeRange(j - 2, 1)]; //注意数组越界
                map[i][j] = @(map[i][j - 2].boolValue || (([prevCh isEqualToString:@"."] || [prevCh isEqualToString:strCh]) && map[i-1][j].boolValue));
            } else {
                map[i][j] = @(map[i - 1][j - 1].boolValue && ([strCh isEqualToString:pCh] || [strCh isEqualToString:@"."]));
            }
        }
    }
    return map[m][n].boolValue;
}


// 301 Remove Invalid Parentheses
// clarify: 1如果str 是合法的返回什么？ 2 result中包含的是否是unique 
// 关键点：如何确保结果unique

// https://discuss.leetcode.com/topic/34875/easy-short-concise-and-fast-java-dfs-3-ms-solution/2
// 思路:
// 0. when the counter is negetive , we have more ')',
// 1. remove the first ')' in a series of concecutive ')' --- 为了去重复
// 2. reverse the left part 

// 真的很难！
// 是否需要再做：是
- (NSArray<NSString *> *)removeInvalidParentheses:(NSString *)str
{
    NSInteger removeL = 0;
    NSInteger removeR = 0;
    
    for(NSInteger i = 0; i < str.length; i++){
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        if([ch isEqualToString:@"("]) {
            removeL++;
        } else if ([ch isEqualToString:@")"]) {
            if(removeL != 0) {
                removeL--;
            } else {
                removeR++;
            }
        }
    }
    NSMutableSet *set = [NSMutableSet set];
    [self dfs:str start:0 set:set result:[@"" mutableCopy] idxL:removeL idxR:removeR open:0];
    return [set allObjects];
}


// 需要统计 （ ， ） 需要删除的数目
- (void)dfs:(NSString *)str start:(NSInteger)start set:(NSMutableSet *)set result:(NSMutableString *)result idxL:(NSInteger)l idxR:(NSInteger)r open:(NSInteger)open
{
    if(l < 0 || r < 0 || open < 0){
        return;
    }
    if(start == str.length){
        if(l == 0 && r == 0 && open == 0){
            [set addObject:[result copy]];
        }
        return;
    }
    
    NSString *ch = [str substringWithRange:NSMakeRange(start, 1)];
    if([ch isEqualToString:@"("]) {
        [self dfs:str start:start + 1 set:set result:result idxL:l -1 idxR:r open:open];
        [result appendString:ch];
        [self dfs:str start:start + 1 set:set result:result  idxL:l idxR:r open:open + 1];

    } else if([ch isEqualToString:@")"]) {
        [self dfs:str start:start + 1 set:set result:result idxL:l idxR:r-1 open:open]; //没有使用当前的括号
        [result appendString:ch];
        [self dfs:str start:start + 1 set:set result:result  idxL:l idxR:r open:open - 1];
    } else {
        [result appendString:ch];
        [self dfs:str start:start + 1 set:set result:result  idxL:l idxR:r open:open];
    }
    [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
}

// https://discuss.leetcode.com/topic/28855/java-bfs-solution-16ms-avoid-generating-duplicate-strings
// 枚举所有

//- (NSArray<NSString *> *)removeInvalidParentheses_bfs:(NSString *)str
//{
//    
//}

// 括号isvalid 函数
- (BOOL)isValid:(NSString *)str
{
    NSInteger counter = 0;
    for(NSInteger i = 0; i < str.length; i++){
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        if([ch isEqualToString:@"("]){
            counter++;
        } else if([ch isEqualToString:@")"]){
            counter--;
            if(counter < 0){
                return NO;
            }
        }
    }
    return counter == 0;//最后要判断和0 是否相等
}

#pragma mark - subSets

// DFS solution 
// [1, 2, 3] = subset of [1, 2] union with insert 3 into the subset of [1,2]
// subset(n) = subset(n-1) union [insert n in the subset(n-1)]
// T = exponential =  1 + 2 + 2^2 + 2^3 + 2^(n-1) = 2^n

// stack size O(n) heap size O(2^n)

// 基于数学的递归法

- (NSSet<NSSet *> *)subSets2Shuai:(NSArray *)nums
{
    return [self subSets:nums index:0];
}

- (NSSet<NSSet *> *)subSets:(NSArray *)nums index:(NSInteger)index
{
    if(index == nums.count){
        return [NSSet setWithArray:@[@[]]];
    }
    NSSet<NSSet *> *temp = [self subSets:nums index:index + 1];
    NSMutableSet *cTemp = [temp mutableCopy];

    for(NSSet *e in temp){
        NSMutableSet *new = [NSMutableSet setWithSet:e];
        [new addObject:nums[index]];
        [cTemp addObject:new];
    }
    return [cTemp copy];
}

- (NSArray<NSArray *> *)subSets:(NSArray *)nums
{
    if([nums count] == 0){
        return @[@[]];
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@[]]; // 插入一个空数组
    
    [self _subSet:nums start:0 result:result];
    return result;
}

//我这种递归和网上的不太一样. 插入法。 这两种方法到底有哪些差异呢？

- (void)_subSet:(NSArray *)nums start:(NSInteger)start result:(NSMutableArray *)result;
{
    if(start == [nums count]){
        return;
    }
    NSNumber *e = nums[start];
    NSMutableArray *newResult = [NSMutableArray array];//因为在遍历set的时候不能直接更新
    for(NSArray *item in result){
        NSMutableArray *newItem = [NSMutableArray arrayWithArray:item];
        [newItem addObject:e]; //这里
        [newResult addObject:newItem];
    }
    [result addObjectsFromArray:newResult];
    [self _subSet:nums start:start + 1 result:result];
}

//另外一种递归，网上的版本, 这是标准的backtracking
- (NSArray<NSArray *> *)subSet_r:(NSArray *)nums
{
    if([nums count] == 0){
        return @[@[]];
    }
    //注意：这里要确认是否需要排序
    NSMutableArray *result = [NSMutableArray array];
    [self _subSet:nums start:0 subRes:[@[] mutableCopy] res:result];
    
    return result;
}

- (void)_subSet:(NSArray *)nums start:(NSInteger)start subRes:(NSMutableArray *)subRes res:(NSMutableArray<NSMutableArray *>*)result
{
    [result addObject:[subRes copy]]; //add result here cuz we need [],and we don't need a return statement cuz it's in loop
     for(NSInteger i = start; i < nums.count; i++){
         [subRes addObject:nums[i]];
         [self _subSet:nums start:i + 1 subRes:subRes res:result];
         [subRes removeLastObject];
    }
}

// subset 2, 需要排序

- (void)_subSet_dup:(NSArray *)nums start:(NSInteger)start subRes:(NSMutableArray *)subRes res:(NSMutableArray<NSMutableArray *>*)result
{
    [result addObject:[subRes copy]];
    for(NSInteger i = start; i < nums.count; i++){
        if(i == start || [nums[i] compare:nums[i-1]] != NSOrderedSame) { // 数组中过滤掉相同的
            [subRes addObject:nums[i]];
            [self _subSet_dup:nums start:i + 1 subRes:subRes res:result];
            [subRes removeLastObject];
        }
    }
}
//这个解法和论坛一样

- (NSArray<NSArray *> *)subSets_iterate:(NSArray *)nums
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@[]]; //add emtpy array
    
    for(NSInteger i = 0; i < nums.count; i++){
        NSInteger count = result.count;
        NSNumber *num = nums[i];
        for(NSInteger j = 0; j < count; j++){
            NSMutableArray *temp = [NSMutableArray arrayWithArray:result[j]];
            [temp addObject:num];
            [result addObject:temp];
        }
    }
    return result;
}

// Bit Manipulation。还有解法是用位运算
// space : O(1)

- (NSArray<NSArray *> *)subSets_iterate_bits:(NSArray *)nums
{
    NSMutableArray<NSMutableArray *> *result = [NSMutableArray array];
    
    for(NSInteger i = 0; i < (1 << nums.count); i++){
        NSMutableArray *tem = [NSMutableArray array];
        for (NSInteger j = 0; j < nums.count; j++) {
            if((i & (1 << j)) != 0){
                [tem addObject:nums[j]];
            }
        }
        [result addObject:tem];
    }
    return [result copy];
}

// 有重复的
- (NSArray<NSArray *> *)subSetsWithDup:(NSArray *)nums
{
    if([nums count] == 0){
        return @[@[]];
    }
    NSMutableSet *set = [NSMutableSet set]; // 这里可以用 NSMutableArray
    [set addObject:@[]];
    [self _subSetsWithDup:nums start:0 set:set];
    return [set allObjects];
}
//TODO: 思考下另外一种方法
- (void)_subSetsWithDup:(NSArray *)nums start:(NSInteger)start set:(NSMutableSet *)set;
{
    if(start == [nums count]){
        return;
    }
    NSNumber *e = nums[start];
    NSMutableArray<NSMutableArray *> *newResult = [NSMutableArray array];//因为在遍历set的时候不能直接更新
    for(NSArray *item in set){
        NSMutableArray *newItem = [NSMutableArray arrayWithArray:item];
        [newItem addObject:e]; //这里
        [newResult addObject:newItem];
    }
    //简单的办法是这里进行去重复
    for(NSMutableArray *arr in newResult){
        if(![set containsObject:arr]){
            [set addObject:arr];
        }
    }

    [set addObjectsFromArray:newResult];
    [self _subSetsWithDup:nums start:start + 1 set:set];
}

#pragma mark - island

// O (m *n)
// TODO: Fellow up： 最大的island 的面积
//

- (NSInteger)numIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid
{
    NSInteger num = 0;
    for(NSInteger i = 0; i < grid.count; i++){
        for(NSInteger j = 0; j < [grid firstObject].count; j++) {
            if(grid[i][j].integerValue == 1){
                [self _dfsSearch:grid i:i j:j];
                num++;
            }
        }
    }
    return num;
}

- (void)_dfsSearch:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid i:(NSInteger)i j:(NSInteger)j
{
    if(i < 0 || j < 0 || i >= grid.count || j >= [grid firstObject].count || grid[i][j].integerValue == 0){
        return;
    }
    grid[i][j] = @(0); //关键是这里设成0
    [self _dfsSearch:grid i:i - 1 j:j];
    [self _dfsSearch:grid i:i + i j:j];
    [self _dfsSearch:grid i:i j:j - 1];
    [self _dfsSearch:grid i:i j:j + 1];
}

- (NSInteger)maxSizeIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid
{
    NSInteger max = 0;
    for(NSInteger i = 0; i < grid.count; i++){
        for(NSInteger j = 0; j < [grid firstObject].count; j++) {
            if(grid[i][j].integerValue == 1){
                NSInteger count = 0;
                [self _dfsSearch:grid i:i j:j count:&count];
                max = MAX(max, count);
            }
        }
    }
    return max;
}

- (void)_dfsSearch:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid i:(NSInteger)i j:(NSInteger)j count:(NSInteger *)count
{
    if(i < 0 || j < 0 || i >= grid.count || j >= [grid firstObject].count || grid[i][j].integerValue == 0){
        return;
    }
    grid[i][j] = @(0); //关键是这里设成0
    *count += 1;
    [self _dfsSearch:grid i:i - 1 j:j];
    [self _dfsSearch:grid i:i + i j:j];
    [self _dfsSearch:grid i:i j:j - 1];
    [self _dfsSearch:grid i:i j:j + 1];
}

#pragma mark - Fellow Up remove island when size small than k

// actually we can store the cordinates of island, and we the count meets the constrain , we set remove the island according to the index we store
// so by the way we need a
// 这种方式需要额外的 set 存储 index, 此外网上还有一种解法是 用两个matrix 其一种一个copy，并且通过全局变量来count 这个size
// https://github.com/coder0813/FaceBook-Intern-Leetcode/blob/master/remove%20island%20of%20area%20k/remove.java

- (void)removeIslands:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid k:(NSInteger)k
{
    NSMutableSet *set = [NSMutableSet set];
    for(NSInteger i = 0; i < grid.count; i++){
        for(NSInteger j = 0; j < grid.firstObject.count; j++){
            NSMutableSet<NSArray<NSNumber *> *> *rest = [NSMutableSet set];
            [self _dfsSearch:grid i:i j:j indexSet:set k:k removedIndexSet:rest];
            
            if([rest count] <= k){
                [rest enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * _Nonnull obj, BOOL * _Nonnull stop) {
                    NSInteger i = obj.firstObject.integerValue;
                    NSInteger j = obj.lastObject.integerValue;
                    grid[i][j] = @(0);
                }];
            }
        }
    }
}

// TODO: 这里写反了，对于是移除size < k 的island, 学会掌握这种path路径的技巧。

- (void)_dfsSearch:(NSMutableArray<NSMutableArray<NSNumber *> *> *)grid i:(NSInteger)i j:(NSInteger)j
          indexSet:(NSMutableSet *)set k:(NSInteger)k removedIndexSet:(NSMutableSet *)res
{
    if(i < 0 || j < 0 || i >= grid.count || j >= [grid firstObject].count || grid[i][j].integerValue == 0 || [set containsObject:@[@(i), @(j)]]){
        return;
    }
    
    // 这里会自动REMOVE duplicate
    [res setByAddingObjectsFromSet:set];//
    
    [set addObject:@[@(i), @(j)]];
    
    [self _dfsSearch:grid i:i - 1 j:j indexSet:set k:k removedIndexSet:res];
    [self _dfsSearch:grid i:i + i j:j indexSet:set k:k removedIndexSet:res];
    [self _dfsSearch:grid i:i j:j - 1 indexSet:set k:k removedIndexSet:res];
    [self _dfsSearch:grid i:i j:j + 1 indexSet:set k:k removedIndexSet:res];
    
    [set removeObject:@[@(i), @(j)]];
}

#pragma mark - 22. Generate Parentheses

- (NSArray<NSString *> *)generateParenthesis:(NSInteger)count
{
    NSMutableArray *result = [NSMutableArray array];
    [self _generateParenthesis:count withLeft:0 right:0 sub:[@"" mutableCopy] result:result];
    return result;
}

- (void)_generateParenthesis:(NSInteger)count withLeft:(NSInteger)l right:(NSInteger)r sub:(NSMutableString *)sub result:(NSMutableArray *)result
{
    // r = 0 的时候，已经insert 一个“）”，所以当r == 2 的时候已经满了。所以这里当r == 3 就退出。不能写成 r > count
    // 遇到计数的问题小心 count 是从0 开始，还是从1开始
    if(r == count){
        [result addObject:[sub copy]];
        return;
    }
    //insert "("
    if(l < count){
        [sub appendString:@"("];
        [self _generateParenthesis:count withLeft:l + 1 right:r sub:sub result:result];
        [sub deleteCharactersInRange:NSMakeRange(sub.length - 1 , 1)];
    }

    if(l > r){
        [sub appendString:@")"];
        [self _generateParenthesis:count withLeft:l right:r + 1 sub:sub result:result];
        [sub deleteCharactersInRange:NSMakeRange(sub.length - 1 , 1)];
    }
}


// 字符串问题，可以问下哪些接口可以用
// 设计case: 正确的几种,错误的,边界的,极端的

- (BOOL)isOneEditDistance:(NSString *)str withStr:(NSString *)str2
{   //corner case
    if(str.length == 0 && str2.length == 0){
        return YES;
    }
    if(ABS((NSInteger)str.length - (NSInteger)str2.length) > 1) { //这里length 的属性NSUInteger，所以如果小的数减去大的数，会非常大
        return NO;
    } 
    NSInteger count = 0;
    NSInteger i = 0;
    NSInteger j = 0;

    while (i < str.length && j < str2.length) {
        NSString *p = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *q = [str substringWithRange:NSMakeRange(j, 1)];
        if(![p isEqualToString:q]){
            if(count >= 1){
                return NO;
            }
            count += 1;
            if(str.length > str2.length){
                i++; // 也可以判断直接调用substring 方法判断后面的sub string 是否相等
                // 或者可以这么判断 [str substringFromIndex:i+1] isEqual:[str substringFromIndex:j];
            } else if (str.length < str2.length){
                j++;
            } else {
                i++;
                j++;
            }
            //[str substringFromIndex:i] isEqual:[str substringFromIndex:j]
        } else {
            i++;
            j++;
        }

    }
    if(i < str.length || j < str2.length){
        count++;
    }
    
    return count <= 1;
}

- (BOOL)isOneEditDistance2Shuai:(NSString *)str withStr:(NSString *)str2
{   //corner case
    if(str.length == 0 && str2.length == 0){
        return YES;
    }
    if(ABS((NSInteger)str.length - (NSInteger)str2.length) > 1) { //这里length 的属性NSUInteger，所以如果小的数减去大的数，会非常大
        return NO;
    }

    if (str.length < str2.length) {
        return [self isOneEditDistance2Shuai:str2 withStr:str];
    }
    if(str.length != str2.length){
        if([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:[str2 substringWithRange:NSMakeRange(0, 1)]]){
            return [[str substringWithRange:NSMakeRange(0, str2.length)] isEqualToString:str2];
        } else {
            return [[str substringWithRange:NSMakeRange(1, str2.length)] isEqualToString:str2];
        }
    } else {
        for (NSInteger i = 0; i < str.length; i++) {
            if(![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:[str2 substringWithRange:NSMakeRange(i, 1)]]){
                return [[str substringFromIndex:i + 1] isEqualToString:[str2 substringFromIndex:i + 1]];// 这里最边界的case是str.length，此时返回的是空字符串，如果超过则throw
            }
        }
    }
    return YES;
}

#pragma mak - Expression Add Operators

//思路:
- (NSArray *)addOperators:(NSString *)num target:(NSInteger)target
{
    NSMutableArray *res = [NSMutableArray array];
    [self addOperators:num start:0 target:target temp:[@"" mutableCopy] result:res eval:0 expr:0];
    return [res copy];
}

//overflow: we use a long type once it is larger than Integer.MAX_VALUE or minimum, we get over it.
//0 sequence: because we can't have numbers with multiple digits started with zero, we have to deal with it too.
//a little trick is that we should save the value that is to be multiplied in the next recursion.

- (void)addOperators:(NSString *)nums start:(NSInteger)start target:(NSInteger)target temp:(NSMutableString *)temp result:(NSMutableArray *)resutArray eval:(NSInteger)eval expr:(NSInteger)expr
{
    if(eval == target){
        [resutArray addObject:[temp copy]];
        return;
    }
    for (NSInteger i = start; i < nums.length; i++) {
        //
        if(i != start && [[nums substringWithRange:NSMakeRange(start, 1)] isEqualToString:@"0"]) {//这一行有点不太明白！！！ 是因为不能出现 01 * 22，不能以 0开头
            break;
        }
        NSString *ch = [nums substringWithRange:NSMakeRange(start, 1 + i - start)];
        
        if(start == 0){
            [temp appendString:ch];
            [self addOperators:nums start:i + 1 target:target temp:temp result:resutArray eval:(eval + ch.integerValue) expr:ch.integerValue];
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 1, 1)];
        } else {
            [temp appendString:[NSString stringWithFormat:@"+%@",ch]];
            [self addOperators:nums start:i + 1 target:target temp:temp result:resutArray eval:(eval + ch.integerValue) expr:ch.integerValue];
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 2, 2)];
            
            [temp appendString:[NSString stringWithFormat:@"-%@",ch]];
            [self addOperators:nums start:i + 1 target:target temp:temp result:resutArray eval:(eval - ch.integerValue) expr:(0 - ch.integerValue)];
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 2, 2)];
            
            [temp appendString:[NSString stringWithFormat:@"*%@",ch]]; //关键是 * 的处理
            [self addOperators:nums start:i + 1 target:target temp:temp result:resutArray eval:(eval - expr + expr * ch.integerValue) expr:(expr * ch.integerValue)];
            [temp deleteCharactersInRange:NSMakeRange(temp.length - 2, 2)];
        }
    }
}

#pragma mark - 218. The skyline Problem

 // https://leetcode.com/problems/the-skyline-problem/
// https://discuss.leetcode.com/topic/19978/java-570ms-heap-bst-and-430ms-divide-and-conquer-solution-with-explanation

// public class Solution {
//     public List<int[]> getSkyline(int[][] buildings) {
//         List<int[]> heights = new ArrayList<>();
//         for (int[] b: buildings) {
//             heights.add(new int[]{b[0], - b[2]});
//             heights.add(new int[]{b[1], b[2]});
//         }
//         Collections.sort(heights, (a, b) -> (a[0] == b[0]) ? a[1] - b[1] : a[0] - b[0]);
//         TreeMap<Integer, Integer> heightMap = new TreeMap<>(Collections.reverseOrder());
//         heightMap.put(0,1);
//         int prevHeight = 0;
//         List<int[]> skyLine = new LinkedList<>();
//         for (int[] h: heights) {
//             if (h[1] < 0) {
//                 Integer cnt = heightMap.get(-h[1]);
//                 cnt = ( cnt == null ) ? 1 : cnt + 1;
//                 heightMap.put(-h[1], cnt);
//             } else {
//                 Integer cnt = heightMap.get(h[1]);
//                 if (cnt == 1) {
//                     heightMap.remove(h[1]);
//                 } else {
//                     heightMap.put(h[1], cnt - 1);
//                 }
//             }
//             int currHeight = heightMap.firstKey();
//             if (prevHeight != currHeight) {
//                 skyLine.add(new int[]{h[0], currHeight});
//                 prevHeight = currHeight;
//             }
//         }
//         return skyLine;
//     }
// }

// HARD
//

// - (NSArray<NSNumber *> *)getSkyline:(NSArray<NSArray<NSNumber *> *> *)nums
// {
//     NSMutableArray<NSArray<NSNumber *> *> *heights = [NSMutableArray array];
//     for (NSArray<NSNumber *> *item in nums) {
//         [heights addObject:@[item[0], @(-item[2].integerValue)]]; // step1 : sort array first based on start point value then height
//         [heights addObject:@[item[1], @(item[2].integerValue)]];
//     }
    
//     [heights sortUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
//         if([[obj1 firstObject] compare:[obj2 firstObject]] != NSOrderedSame){
//             return [[obj1 firstObject] compare:[obj2 firstObject]]; // 起点
//             //key point 如果是起点相同，高的放在前面
//             //如果是终点相同，矮的放在前面
//         } else {
//             return [[obj1 lastObject] compare:[obj2 lastObject]];  // 高度
//         }
//     }];
    
//     CFBinaryHeapRef heap;
//     CFBinaryHeapCallBacks callBack;
    
//     heap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callBack, NULL);
//     for (NSArray<NSNumber *> *item in heights) {
        
//         if([item lastObject].integerValue < 0){
//             CFBinaryHeapAddValue(heap, (__bridge const void *)(item));
//         } else {
//             // 没有删除 cf 没有删除
            
//         }
//     }
// }

// public List<int[]> getSkyline(int[][] buildings) {
//     List<int[]> result = new ArrayList<>();
//     List<int[]> height = new ArrayList<>();
//     for(int[] b:buildings) {
//         height.add(new int[]{b[0], -b[2]});
//         height.add(new int[]{b[1], b[2]});
//     }
//     Collections.sort(height, (a, b) -> { /             //key point 如果是起点相同，高的放在前面
//                                                        //如果是终点相同，矮的放在前面
//         if(a[0] != b[0])
//             return a[0] - b[0];
//         return a[1] - b[1];
//     });
//     Queue<Integer> pq = new PriorityQueue<>((a, b) -> (b - a));
//     pq.offer(0);
//     int prev = 0;
//     for(int[] h:height) {
//         if(h[1] < 0) { // 遇到起点入堆，
//             pq.offer(-h[1]);
//         } else {   //遇到终点出堆
//             pq.remove(h[1]);
//         }
//         int cur = pq.peek(); //当前堆中的最大值如果和前面一样，就skip掉，这里可以看图，如果不一样就加入到堆中
//         if(prev != cur) {
//             result.add(new int[]{h[0], cur});
//             prev = cur;
//         }
//     }
//     return result;
// }

#pragma mark - [LOCK]Walls and Gates

// DFS
- (void)wallsAndGates:(NSMutableArray<NSMutableArray<NSNumber *> *> *)rooms
{
    if(rooms.count == 0 || rooms.firstObject.count == 0){
        return;
    }
    //没有想到可以从0开始出发
    for (NSInteger i = 0; i < rooms.count; i++) {
        for(NSInteger j = 0; j < rooms[i].count; j++){
            if(rooms[i][j].integerValue == 0){
                [self _search:rooms atRow:i atCol:j steps:0]; //关键一点是从0 的位置开始遍历
            }
        }
    }
}

// 首先这里是否需要 创建一个数组来标记是否已经访问过。 这里有距离的判断，如果重复访问到之前访问过的点的话，steps > 当前值, 
// 所以其实不需要额外的空间来存储每个点的访问状态
// how to anlaysis the Time comlexity and space comlexity ?
// ?? m * n * (numbers of zero)
// beacuse it will not revisited in each search progress

- (void)_search:(NSMutableArray<NSMutableArray<NSNumber *> *> *)rooms atRow:(NSInteger)i atCol:(NSInteger)j steps:(NSInteger)steps
{
    //很多判断逻辑都是可以放在这边
    if (i < 0 || j < 0 || i >= rooms.count || j >= rooms[i].count || rooms[i][j].integerValue < steps) {
        return;
    }
    rooms[i][j] = @(steps);
    [self _search:rooms atRow:i + 1 atCol:j steps:steps + 1];
    [self _search:rooms atRow:i atCol:j + 1 steps:steps + 1];
    [self _search:rooms atRow:i - 1 atCol:j steps:steps + 1];
    [self _search:rooms atRow:i atCol:j - 1 steps:steps + 1];
}

- (void)wallsAndGatesBFS:(NSMutableArray<NSMutableArray<NSNumber *> *> *)rooms
{
    if(rooms.count == 0 || rooms.firstObject.count == 0){
        return;
    }
    NSMutableArray *queue = [NSMutableArray array];
    for (NSInteger i = 0; i < rooms.count; i++) {
        for(NSInteger j = 0; j < rooms[i].count; j++){
            if(rooms[i][j].integerValue == 0){
                [queue addObject:@[@(i), @(j)]];
            }
        }
    }
    while([queue count]){
        NSArray<NSNumber *> *p = queue.firstObject;
        [queue removeObjectAtIndex:0];
        // 四个方向
        NSInteger i = p.firstObject.integerValue;
        NSInteger j = p.lastObject.integerValue;
        // 针对这个地方可以优化下
        if(i > 0 && rooms[i - 1][j].integerValue > rooms[i][j].integerValue) { //这里直接和
            rooms[i - 1][j] = @(rooms[i][j].integerValue + 1);
            [queue addObject: @[@(i - 1), @(j)]];
        }
        if(i < rooms.count - 1 && rooms[i + 1][j].integerValue > rooms[i][j].integerValue) {
            rooms[i + 1][j] = @(rooms[i][j].integerValue + 1);
            [queue addObject: @[@(i + 1), @(j)]];
        }
        if(j > 0 && rooms[i][j - 1].integerValue > rooms[i][j].integerValue) {
            rooms[i][j - 1] = @(rooms[i][j].integerValue + 1);
            [queue addObject: @[@(i), @(j - 1)]];
        }
        if(j < rooms[i].count - 1 && rooms[i][j + 1].integerValue > rooms[i][j].integerValue) {
            rooms[i][j + 1] = @(rooms[i][j].integerValue + 1);
            [queue addObject: @[@(i), @(j + 1)]];
        }
    }
}

// 为什么BFS是最近的呢？棋盘问题的算法复杂度，很多都是 O(m *n)
- (void)wallsAndGatesBFSOptimize:(NSMutableArray<NSMutableArray<NSNumber *> *> *)rooms
{
    if(rooms.count == 0 || rooms.firstObject.count == 0){
        return;
    }
    NSMutableArray *queue = [NSMutableArray array];
    for (NSInteger i = 0; i < rooms.count; i++) {
        for(NSInteger j = 0; j < rooms[i].count; j++){
            if(rooms[i][j].integerValue == 0){
                [queue addObject:@[@(i), @(j)]];
            }
        }
    }
    NSArray<NSNumber *> *x = @[@(-1),@0,@1,@0];
    NSArray<NSNumber *> *y = @[@0,@1,@0,@(-1)];

    while([queue count]){
        NSArray<NSNumber *> *p = queue.firstObject;
        [queue removeObjectAtIndex:0];
        // 四个方向
        NSInteger i = p.firstObject.integerValue;
        NSInteger j = p.lastObject.integerValue;
        // 针对这个地方可以优化下
        for(NSInteger k = 0; k < p.count; i++){
            NSInteger row = i - x[k].integerValue;
            NSInteger col = j - y[k].integerValue;
            if(row < 0 || row == rooms.count || col < 0 || col == rooms.lastObject.count || rooms[row][col].integerValue <= rooms[i][j].integerValue){ //BFS 算法是最短路径，这是性质
                continue;
            }
            rooms[row][col] = @(rooms[i][j].integerValue + 1);
            [queue addObject: @[@(row), @(col)]];
        }
    }
}

- (NSArray<NSArray<NSNumber *> *> *)solveNQueens:(NSInteger)n
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    [self solve:n index:temp result:result];
    return result;
}
// 这里需要注意的 对角线也是invalid
// 这里，我是在travers 的过程中就进行 chess 的绘制，带来一些无效的计算，可以在最后成功的时候再进行绘制

- (void)solve:(NSInteger)n index:(NSMutableArray *)cols result:(NSMutableArray *)result
{
    if([cols count] == n){
        [result addObject:[self buildChessString:cols]];
        return;
    }
    
    for(NSInteger i = 0; i < n; i++){
        if([self isTriagnleSafe:cols n:n index:i]){
            [cols addObject:@(i)];
            [self solve:n index:cols result:result];
            [cols removeLastObject];
        }
    }
}

- (BOOL)isTriagnleSafe:(NSArray<NSNumber *> *)cols n:(NSInteger)n index:(NSInteger)idx
{
    NSInteger row = [cols count];
    NSInteger r = 0;
    for (NSNumber *col in cols) {
        if(col.integerValue == idx || ABS(col.integerValue - idx) == ABS(row - r)) {
            return NO;
        }
        r++;
    }
    return YES;
}

- (NSNumber *)buildChessString:(NSArray<NSNumber *> *)arr
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSNumber *col in arr) {
        NSMutableString *str = [NSMutableString string];
        for (NSInteger j = 0; j < arr.count; j++) {
            if(j == col.integerValue){
                [str appendString:@"Q"];
            } else {
                [str appendString:@"."];
            }
        }
        [temp addObject:[str copy]];//
    }
    return [temp copy];
}

@end

@interface Trie : NSObject
@property (nonatomic, strong) NSMutableDictionary<NSString*, Trie*> *map;
- (BOOL)hasWord:(NSString *)word;

@end

@implementation Trie

- (instancetype)init
{
    self = [super init];
    if(self){
        _map = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)hasWord:(NSString *)word
{
    return self.map[word] != nil;
}

- (BOOL)isEmpty
{
    return [self.map allKeys] != 0;
}

@end

// 211. Add and Search Word

#pragma mark - 211. Add and Search Word

@interface WordDictionary()
@property (nonatomic, strong) Trie *trie;

@end

@implementation WordDictionary

- (instancetype)init
{
    self = [super init];
    if(self){
        _trie = [Trie new];
    }
    return self;
}

- (void)addWord:(NSString *)word
{
    if(word.length == 0){
        return;
    }
    Trie *trie = self.trie;

    for(NSInteger i = 0; i < word.length; i++){
        NSString *ch = [word substringWithRange:NSMakeRange(i, 1)];
        if(![trie hasWord:ch]){
            trie.map[ch] = [Trie new];
        } 
        trie = trie.map[ch];
    }
}

// 这道题目的关键是对 @"."进行递归搜索 DFS

- (BOOL)search:(NSString *)word
{
    return [self search:word index:0 withTrie:self.trie];
}

// 如果输入是 @“abcd” 但是 search 是 @“abc”， 需要返回NO。 长度要一致
// best case : O(K) worst case 26^k

- (BOOL)search:(NSString *)word index:(NSInteger)idx withTrie:(Trie *)trie
{
    if(idx == word.length){
        return [trie isEmpty]; //递归break条件 ！这里需要判断 剩下的trie 是否为空，如果不为空，说明匹配的字符串短了。注意这里是 ==
    }

    NSString *ch = [word substringWithRange:NSMakeRange(idx, 1)];
    if([ch isEqualToString:@"."]){
        for(NSString *key in trie.map.allKeys){
            if([self search:word index:idx+1 withTrie:trie.map[key]]){
                return YES;
            }
        }
        return NO; // 如果没有trie 没有找到，返回NO
    } else if(trie.map[ch]) {
        return [self search:word index:idx+1 withTrie:trie.map[ch]];
    } else {
        return NO;
    }
}

@end
