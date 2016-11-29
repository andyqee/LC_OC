//
//  DP.m
//  LCOBJC
//
//  Created by ethon_qi on 23/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "DP.h"

@implementation DP

// emtpy string . 如何处理 DP

#pragma mark - word break

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

//- (BOOL)isMatchString:(NSString *)str patten:(NSString *)p
//{
//
//}

@end
