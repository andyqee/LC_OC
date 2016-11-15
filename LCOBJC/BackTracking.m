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
   

}

- ()doLetterCombinations:(NSString *)digits start:(NSInteger)start prefix:(NSMutableArray<NSMutableString *> *)prefix
{
    if(start == digits.length - 1) {
        return;
    }
    // NSString *ch = [digits substringWithRange:NSMakeRange(start, 1)];
    // NSString *alphaValue = map[ch];
    // for(NSInteger i = 0; i < alphaValue.length; i++){
    //     NSString *ch = [alphaValue substringWithRange:NSMakeRange(i, 1)];
    //     [prefix appendString:ch];
    //     [self doLetterCombinations:digits start:start + 1 prefix:prefix];
    // }
}

@end
