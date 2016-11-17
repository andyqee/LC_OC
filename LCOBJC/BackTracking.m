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
            if([self findBoard:board x:i y:j word:word index:0 visited:visited]) {
                return YES;
            }
        }
    }
    return NO;
}

//helper method
//http://www.jiuzhang.com/solutions/word-search/

- (BOOL)findBoard:(NSArray<NSArray *> *)board x:(NSInteger)x y:(NSInteger)y word:(NSString *)word index:(NSInteger)idx visited:(NSMutableArray<NSMutableArray *> *)visited
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
    BOOL isFound = [self findBoard:board x:x-1 y:y word:word index:idx+1 visited:visited] ||
                   [self findBoard:board x:x y:y-1 word:word index:idx+1 visited:visited] ||
                   [self findBoard:board x:x+1 y:y word:word index:idx+1 visited:visited] ||
                   [self findBoard:board x:x y:y+1 word:word index:idx+1 visited:visited];
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
    
  [self doLetterCombinations:digits start:0 prefix:@"" result:result dic:map];
  return result;
}

- (void)doLetterCombinations:(NSString *)digits start:(NSInteger)start prefix:(NSString *)prefix result:(NSMutableArray *)result dic:(NSDictionary *)map;
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
        [prefix appendString:ch]//[str appendString:ch];
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
        [prefix deleteStringAtIndex:prefix.length - 1];
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

@end
