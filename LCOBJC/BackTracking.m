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

//先来个递归版本，再来个迭代
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
        [result addObject:prefix];
        return;
    }

    NSString *ch = [digits substringWithRange:NSMakeRange(start, 1)];
    NSString *alphaValue = map[ch];
    if(alphaValue.length == 0) {
        [self doLetterCombinations:digits start:start + 1 prefix:prefix result:result dic:map];
    }
    for(NSInteger i = 0; i < alphaValue.length; i++){
        NSString *ch = [alphaValue substringWithRange:NSMakeRange(i, 1)];
        NSMutableString *str = [NSMutableString stringWithString:prefix];
        [str appendString:ch];
        [self doLetterCombinations:digits start:start + 1 prefix:str result:result dic:map];
    }
}

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

//- (void)doCombinationSum:(NSArray<NSNumber *> *)array target:(NSInteger)target result:(NSMutableSet *)result currResult:(NSArray<NSNumber *> *)curr
//{
//    if(target == 0) {
//        NSArray *sorted = [curr sortedArrayUsingSelector:@selector(compare:)];
//        if(![result containsObject:sorted]) {
//            [result addObject:sorted]; //sorted first then insert
//        }
//        return;
//    }
//
//    for(NSInteger i = 0; i < [array count]; i++){
//        NSInteger nextTarget = target - array[i].integerValue;
//        if(nextTarget >= 0) {
//            NSMutableArray *temp = [NSMutableArray arrayWithArray:curr];
//            [temp addObject:array[i]];
//            [self doCombinationSum:array target:nextTarget result:result currResult:temp];
//        }
//    }
//}

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

@end
