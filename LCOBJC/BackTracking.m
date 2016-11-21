//
//  BackTracking.m
//  LCOBJC
//
//  Created by ethon_qi on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "BackTracking.h"

@implementation BackTracking

- (BOOL)existWithBorad:(NSArray<NSArray *> *)board word:(NSString *)word
{
    NSInteger m = [board count];
    NSInteger n = [[board firstObject] count];
    //initilize visited array
    NSMutableArray *visited = [NSMutableArray array];
    for(NSInteger i = 0; i < m; i++) {
        NSMutableArray *subArray = [NSMutableArray array];
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

- (BOOL)_findBoard:(NSArray<NSArray *> *)board x:(NSInteger)x y:(NSInteger)y word:(NSString *)word index:(NSInteger)idx visited:(NSMutableArray<NSMutableArray *> *)visited
{
    if(idx == [word length]) {
        return YES;
    }
    //break 
    NSString *cha = [word substringWithRange:NSMakeRange(idx, 1)];
    if(x < 0 || y < 0 || x >= [board count] || y >= [[board firstObject] count] || [visited[x][y] boolValue] || ![visited[x][y] isEqualToString:cha]) {
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
        if(mStr.length) { //这里要添加空字符串的判断
            NSInteger count = [result count];
            NSMutableArray *temp = [NSMutableArray array];
            
            for(NSInteger j = 0; j < mStr.length; j++){
                NSString *ch = [mStr substringWithRange:NSMakeRange(j, 1)];
                for(NSInteger k = 0; k < count; k++) {
                    NSMutableString *str = [NSMutableString stringWithString:result[k]];
                    [str appendString:ch];
                    [temp addObject:str];
                }
            }
            result = temp;
        }
    }
    return result;
}

- (NSArray<NSString *> *)letterCombinations_recursive:(NSString *)digits
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
    if(alphaValue.length == 0) {
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
    }
    for(NSInteger i = 0; i < alphaValue.length; i++){
        NSString *ch = [alphaValue substringWithRange:NSMakeRange(i, 1)];
        //NSMutableString *str = [NSMutableString stringWithString:prefix]; //这里可以优化成下面combinationSum的方式，避免无用对象的copy
        [prefix appendString:ch];//[str appendString:ch];
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
        [prefix deleteCharactersInRange:NSMakeRange(prefix.length - 1, 1)];
    }
}

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

- (NSArray<NSArray *> *)combinationSum:(NSArray *)array target:(NSInteger)target
{
    if(target <= 0 || [array count] == 0){
        return nil;
    }
    NSMutableSet *result = [NSMutableSet set];
    [self doCombinationSum:array target:target result:result currResult:[@[] mutableCopy]];

    return [result allObjects]; 
}

- (void)doCombinationSum:(NSArray<NSNumber *> *)array target:(NSInteger)target result:(NSMutableSet *)result currResult:(NSMutableArray<NSNumber *> *)curr
{
    if(target == 0) {
        NSArray *sorted = [curr sortedArrayUsingSelector:@selector(compare:)];
        if(![result containsObject:sorted]) {
            [result addObject:curr]; //sorted first then insert
        }
        return;
    }
    
    for(NSInteger i = 0; i < [array count]; i++){
        NSInteger nextTarget = target - array[i].integerValue;
        if(nextTarget >= 0) {
            [curr addObject:array[i]];
            [self doCombinationSum:array target:nextTarget result:result currResult:curr];
            [curr removeObjectAtIndex:[curr count] - 1]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
        }
    }
}

// 上面这种方法是在最终搜索到解的情况下进行去重判断，这样就相当于在搜索的过程中，有很多无效的搜索。
- (NSArray<NSArray *> *)combinationSum_optimize:(NSArray *)array target:(NSInteger)target
{
    if(target <= 0 || [array count] == 0){
        return nil;
    }
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *result = [NSMutableArray array];
    [self doCombinationSum_optimize:sortedArray start:0 target:target result:result currResult:[@[] mutableCopy]];

    return result; 
}

- (void)doCombinationSum_optimize:(NSArray<NSNumber *> *)array start:(NSInteger)start target:(NSInteger)target result:(NSMutableArray *)result currResult:(NSMutableArray<NSNumber *> *)curr
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
            [curr addObject:array[i]]; //如果需要确保结果集合是没有重复的，但是元素是可以重复使用的,直接将start递归下
            [self doCombinationSum_optimize:array start:start target:nextTarget result:result currResult:curr];
            [curr removeObjectAtIndex:[curr count] - 1]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
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
    [self doCombinationSum_optimize_2:sortedArray start:0 target:target result:result currResult:[@[] mutableCopy]];

    return result; 
}

- (void)doCombinationSum_optimize_2:(NSArray<NSNumber *> *)array start:(NSInteger)start target:(NSInteger)target result:(NSMutableArray *)result currResult:(NSMutableArray<NSNumber *> *)curr
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
            [curr addObject:array[i]]; //如果需要确保结果集合是没有重复的，但是元素是可以重复使用的,直接将start递归下
            [self doCombinationSum_optimize_2:array start:start+1 target:nextTarget result:result currResult:curr];
            [curr removeObjectAtIndex:[curr count] - 1]; //递归完恢复状态,用这种方式，如果加入到result 中curr 不copy一份的话，返回的是空array，相比较上面的方法，减少了一些中间对象的创建
        }
    }
}

// handle empty string 

- (BOOL)isMatch:(NSString *)str withPatten:(NSString *)p 
{
    //handle emtpy case
    return [self doIsMatch_re:str i:0 withPatten:p j:0];
}

- (BOOL)doIsMatch_re:(NSString *)str i:(NSInteger)i withPatten:(NSString *)p j:(NSInteger)j
{
    if(i > str.length || j > str.length){
        return NO;
    }

    if(i == str.length && j == str.length){
        return YES;
    }
    NSString *strCh = [str substringWithRange:NSMakeRange(i, 1)];
    NSString *pCh = [str substringWithRange:NSMakeRange(j, 1)];

    if([pCh isEqualToString:@"."] || [pCh isEqualToString:strCh]){
        return [self doIsMatch_re:str i:i+1 withPatten:p j:j+1];
    } else if([pCh isEqualToString:@"*"]){
        return [self doIsMatch_re:str i:i+1 withPatten:p j:j] || [self doIsMatch_re:str i:i+1 withPatten:p j:j+1];
    } else {
        return NO;
    }
}

// 如果是两个string，每个字符串相互关联,就用二维数组
// 各种case 应该考虑全面

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
    for(NSInteger i = 0; i <= m; i++){
        for(NSInteger j = 1; j <= n; j++) {
            NSString *p = [str substringWithRange:NSMakeRange(j - 1, 1)];
            NSString *ch = [str substringWithRange:NSMakeRange(i - 1, 1)];

        }
    }
    return map[m][n].boolValue;
}

//301
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

// DFS solution 
// [1, 2, 3] = subset of [1, 2] union with insert 3 into the subset of [1,2]
// subset(n) = subset(n-1) union [insert n in the subset(n-1)]
// T = exponential =  1 + 2 + 2^2 + 2^3 + 2^(n-1) = 2^n

// stack size O(n) heap size O(2^n)

- (NSArray<NSArray *> *)subSets:(NSArray *)nums
{
    if([nums count] == 0){
        return @[@[]];
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@[]];
    [self _subSet:nums start:0 set:result];
    return result;
}

//我这种递归和网上的不太一样. 插入法。 这两种方法到底有哪些差异呢？

- (void)_subSet:(NSArray *)nums start:(NSInteger)start set:(NSMutableArray *)set;
{
    if(start == [nums count]){
        return;
    }
    NSNumber *e = nums[start];
    NSMutableArray *newResult = [NSMutableArray array];//因为在遍历set的时候不能直接更新
    for(NSArray *item in set){
        NSMutableArray *newItem = [NSMutableArray arrayWithArray:item];
        [newItem addObject:e]; //这里
        [newResult addObject:newItem];
    }
    [set addObjectsFromArray:newResult];
    [self _subSet:nums start:start + 1 set:set];
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
    [result addObject:[subRes copy]];
     for(NSInteger i = start; i < nums.count; i++){
         [subRes addObject:nums[i]];
         [self _subSet:nums start:i + 1 subRes:subRes res:result];
         [subRes removeLastObject];
    }
}

// subset 2
- (void)_subSet_dup:(NSArray *)nums start:(NSInteger)start subRes:(NSMutableArray *)subRes res:(NSMutableArray<NSMutableArray *>*)result
{
    [result addObject:[subRes copy]];
    for(NSInteger i = start; i < nums.count; i++){
        if(i == start || [nums[i] compare:nums[i-1]] == NSOrderedSame) { // 数组中过滤掉相同的
            [subRes addObject:nums[i]];
            [self _subSet_dup:nums start:i + 1 subRes:subRes res:result];
            [subRes removeLastObject];
        }
    }
}
//这个解法和论坛一样
- (NSArray<NSArray *> *)subSets_iterate:(NSArray *)nums
{
    NSUInteger capacity = 1 << nums.count;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:capacity];
    [result addObject:@[]];
    
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

// O (m *n) 
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
    grid[i][j] = @(0);
    [self _dfsSearch:grid i:i - 1 j:j];
    [self _dfsSearch:grid i:i + i j:j];
    [self _dfsSearch:grid i:i j:j - 1];
    [self _dfsSearch:grid i:i j:j + 1];
}

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
        [self _generateParenthesis:count withLeft:l right:r+1 sub:sub result:result];
        [sub deleteCharactersInRange:NSMakeRange(sub.length - 1 , 1)];
    }
}

//method DP, //还有一种方法是用stack 来实现

- (NSInteger)longestValidParentheses:(NSString *)str
{
    NSUInteger n = str.length + 1;
    NSInteger max = 0; //DP[i]：以s[i-1]为结尾的longest valid parentheses substring的长度。
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:n];
    for(NSInteger i = 0; i < n; i++){
        [dp addObject:@(0)];
    }
    //关键是找到（）序列直接的关系
//    X()(())X
//    j......i-1 

    for(NSInteger i = 1; i <= str.length; i++){
        NSInteger j = i - 2 - dp[i-1].integerValue; //
        NSString *ch = [str substringWithRange:NSMakeRange(i-1, 1)];
        NSString *p = [str substringWithRange:NSMakeRange(j, 1)];
// 这个状态转移方程不太好整
        if([ch isEqualToString:@"("] || j < 0 || [p isEqualToString:@")"]){
            dp[i] = @(0);
        } else {
            dp[i] = @(dp[i-1].integerValue + 2 + dp[j].integerValue);
            max = MAX(max, dp[i].integerValue);
        }
    }
    return max;
}

//121. Best Time to Buy and Sell Stock

- (NSInteger)maxProfit:(NSArray<NSNumber *> *)prices
{
    if([prices count] < 2){
        return 0;
    }
    NSInteger maxProfit = 0;
    NSInteger minPrice = 0;

    for(NSInteger i = 1; i < [prices count]; i++){
        if([prices[i] compare:prices[i-1]] == NSOrderedDescending){
            maxProfit = MAX(maxProfit, prices[i].integerValue - minPrice);
        } else {
            minPrice = MIN(minPrice, prices[i].integerValue);
        }
    }
    return maxProfit;
}

//122. Best Time to Buy and Sell Stock

// 这里可以利用一个变量来替换array
// Second, suppose the first sequence is "a <= b <= c <= d", the profit is "d - a = (b - a) + (c - b) + (d - c)" without a doubt. And suppose another one is "a <= b >= b' <= c <= d", the profit is not difficult to be figured out as "(b - a) + (d - b')". So you just target at monotone sequences.

- (NSInteger)maxProfit_2:(NSArray<NSNumber *> *)prices
{
    if([prices count] < 2){
        return 0;
    }
    NSInteger count = prices.count + 1;
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:count];
    [dp addObject:@(0)];
    [dp addObject:@(0)];
    
    for(NSInteger i = 2; i <= [prices count]; i++){
        NSInteger temp = prices[i-1].integerValue - prices[i-2].integerValue;
        [dp addObject: @(MAX(dp[i].integerValue + temp, dp[i].integerValue))];
    }
    return dp[count].integerValue;
}

//198. House Robber

- (NSInteger)rob:(NSArray<NSNumber *> *)nums
{
    NSMutableArray *dp
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
