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

// Fellow up 返回结果

- (NSString *)wordBreakFollowup:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0) {
        return str;
    }
    
    NSInteger count = str.length;
    NSMutableArray *map = [NSMutableArray array];
    NSMutableArray<NSNumber *> *from = [NSMutableArray array];

    for(NSInteger k = 0; k <= count; k++) {
        [map addObject:@(NO)];
        [from addObject:@(-1)];
    }
    
    //base case
    map[0] = @(YES);
    for(NSInteger i = 1; i <= count; i++) { //
        for(NSInteger j = 0; j < i; j++) { // 拆分成sub problem
            NSString *subStr = [str substringWithRange:NSMakeRange(j ,i - j)];
            if(map[j] && [set containsObject:subStr]) {
                map[i] = @(YES);
                from[i] = @(j);
            }
        }
    }
    NSInteger t = count;
    NSMutableArray *rest = [@[] mutableCopy];
    while(t > 0){ // t == 0 就不需要在往前面找了
        NSInteger p = [from[t] integerValue];
        NSString *sub = [str substringWithRange:NSMakeRange(p, t - p)];//这里的t 是比index > 1,所有不用 t-p + 1
        [rest addObject:sub];
        t = p;
    }
    return [[[rest reverseObjectEnumerator] allObjects] componentsJoinedByString:@" "];
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

//76. Minimum Window Substring

//- (BOOL)isMatchString:(NSString *)str patten:(NSString *)p
//{
//
//}


- (NSInteger)maxKilledEnemies:(NSArray<NSArray *> *)matrix
{
    NSInteger res = 0;
    NSMutableArray<NSNumber *> *colVal = [NSMutableArray arrayWithCapacity:matrix.firstObject.count];
    NSInteger rowVal = 0;

    for (NSInteger i = 0; i < matrix.count; i++) {
        for (NSInteger j = 0; j < matrix.firstObject.count; j++) {
            if([matrix[i][j] isEqual:@"W"]){ //如果是wall, 就skip掉
                continue;
            }
            if(j == 0 || [matrix[i][j - 1] isEqual:@"W"]){ //如果左边是wall，或者是row 的第一个元素，需要重新计算
                rowVal = 0;// reset
                for(NSInteger k = j; k < matrix.firstObject.count && ![matrix[i][k] isEqual:@"W"]; k++){
                    if([matrix[i][k] isEqual:@"E"]) { //统计E
                        rowVal++;
                    }
                }
            }
            
            if(i == 0 || [matrix[i - 1][j] isEqual:@"W"]){  //每一列的值可以reuse, 也就是@”W“ 之前的都是有效的
                colVal[j] = @(0); // reset
                for(NSInteger k = i; k < matrix.count && ![matrix[k][j] isEqual:@"W"]; k++){
                    if([matrix[k][j] isEqual:@"E"]) { //统计E
                        colVal[j] = @(colVal[j].integerValue + 1);
                    }
                }
            }
            if([matrix[i][j] isEqual:@"0"]){
                res = MAX(res, rowVal + colVal[j].integerValue);
            }
        }
    }
    return res;
}

//85. Maximal Rectangle
// 两种方法
// 需要多个数组来存储状态

// 下面这种解法是有问题的。 矩阵的长宽，如果分开算，下面的办法，没有正确的考虑到matrix的范围
// 边界弄错啦 啊啊啊！

- (NSInteger)maximalRectangle_Wrong:(NSArray<NSArray<NSString *> *> *)matrix
{
    //corner case
    if([matrix count] == 0 || [[matrix firstObject] count] == 0){
        return 0;
    }
    
    NSMutableArray<NSMutableArray<NSArray<NSNumber *> *> *> *dp = [NSMutableArray array]; // store the pairs, firstObject is width, lastObejct is height
    for(NSInteger i = 0; i <= matrix.count; i++){
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j <= matrix.firstObject.count; j++){
            [sub addObject:@[@0, @0]];
        }
        [dp addObject:sub];
    }
    
    //base case 1 * n  , n * 1 // 都是0，可以merge 到上面的初始化过程中
    //general cases
    NSInteger maxSize = 0;
    for(NSInteger i = 1; i <= matrix.count; i++){
        for(NSInteger j = 1; j <= matrix.firstObject.count; j++){
            if([matrix[i - 1][j - 1] isEqual:@"1"]) {
                dp[i][j] = @[@(dp[i - 1][j][0].integerValue + 1), @(dp[i][j - 1][1].integerValue + 1)];
                maxSize = MAX(maxSize, dp[i][j][0].integerValue * dp[i][j][1].integerValue);
            } else {
                dp[i][j] = @[@0, @0]; // reset to 0
            }
        }
    }
    return maxSize;
}

// 需要用 left[n]  right[n]  以及height[] 确定
//
// 难点1 这里的2D 如何转成一维

//left(i,j) = max(left(i-1,j), cur_left), cur_left can be determined from the current row
//right(i,j) = min(right(i-1,j), cur_right), cur_right can be determined from the current row
//height(i,j) = height(i-1,j) + 1, if matrix[i][j]=='1';
//height(i,j) = 0, if matrix[i][j]=='0'

// https://leetcode.com/problems/maximal-rectangle/

- (NSInteger)maximalRectangle:(NSArray<NSArray<NSString *> *> *)matrix
{
    //corner case
    if([matrix count] == 0 || [[matrix firstObject] count] == 0){
        return 0;
    }
    NSMutableArray<NSNumber *> *lefts = [NSMutableArray array];
    NSMutableArray<NSNumber *> *rights = [NSMutableArray array];
    
    for(NSInteger j = 0; j < matrix.firstObject.count; j++){
        [rights addObject:@(matrix.firstObject.count)];
        [lefts addObject:@0];
    }
    NSMutableArray<NSNumber *> *heights = [NSMutableArray array];
    for(NSInteger j = 0; j < matrix.firstObject.count; j++){
        [heights addObject:@0];
    }
    
    NSInteger maxSize = 0;
    
    for(NSInteger i = 0; i <= matrix.count - 1; i++){
        NSInteger currLeft = 0; // 放置在内循环里面
        NSInteger currRight = matrix.firstObject.count;

        for(NSInteger j = 0; j <= matrix.firstObject.count - 1; j++){
            if([matrix[i][j] isEqual:@"1"]) { //
    
                heights[j] = @(heights[j].integerValue + 1);
                lefts[j] = @(MAX(lefts[j].integerValue, currLeft)); //和上一次内循环中的left比,end up with j 的left 进行比较，左边界取更右边的

            } else {
                heights[j] = @(0);
                currLeft = j + 1;
                lefts[j] = @0; // 为了要取到最大值
            }
            NSLog(@"height: %@", [heights componentsJoinedByString:@" "]);
            NSLog(@"lefts %@", [lefts componentsJoinedByString:@" "]);

        }
        
        for (NSInteger j = matrix.firstObject.count - 1; j >= 0; j--) {
            if([matrix[i][j] isEqual:@"1"]) {
                rights[j] = @(MIN(rights[j].integerValue, currRight)); //
            } else {
                currRight = j;
                rights[j] = @(matrix.firstObject.count); //why 这里需要设置成 n？ 因为要取最小值
            }
            NSLog(@"right %@", [rights componentsJoinedByString:@" "]);
        }
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            maxSize = MAX(maxSize, (rights[j].integerValue - lefts[j].integerValue ) * heights[j].integerValue);
        }
    }
    return maxSize;
}

// 方法2 基于 largest rectangle

- (NSInteger)maximalRectangleMethod2:(NSArray<NSArray<NSString *> *> *)matrix
{
    if(!matrix || [matrix count] == 0 || [[matrix firstObject] count] == 0){
        return 0;
    }
    
    NSMutableArray<NSNumber *> *heights = [NSMutableArray array];
    for(NSInteger j = 0; j < matrix.firstObject.count; j++){
        [heights addObject:@0];
    }
    NSInteger maxRect = 0;
    for (NSInteger i = 0; i < matrix.count; i++) {
        for(NSInteger j = 0; j < matrix[i].count; j++){
            if ([matrix[i][j] isEqualToString:@"0"]) {
                heights[j] = @0;
            } else {
                heights[j] = @(heights[j].integerValue + 1);
            }
        }
        maxRect = MAX(maxRect, [self largestRect:heights]);
        //calculate max rectangle
    }
    return maxRect;
}

//hard
// 用stack 管理状态，处理的关键是什么时候pop ，什么时候push，这个比较难搞
// scane from left to right
// 遇到比当前小的的就pop掉，因为它的高度不会限制rect 的max size

//1) Create an empty stack.
//
//2) Start from first bar, and do following for every bar ‘hist[i]’ where ‘i’ varies from 0 to n-1.
//……a) If stack is empty or hist[i] is higher than the bar at top of stack, then push ‘i’ to stack.
//……b) If this bar is smaller than the top of stack, then keep removing the top of stack while top of the stack is greater. Let the removed bar be hist[tp]. Calculate area of rectangle with hist[tp] as smallest bar. For hist[tp], the ‘left index’ is previous (previous to tp) item in stack and ‘right index’ is ‘i’ (current index).
//
//3) If the stack is not empty, then one by one remove all bars from stack and do step 2.b for every removed bar.

- (NSInteger)largestRect:(NSArray<NSNumber *> *)rect
{
    NSInteger maxSize = 0;
    NSMutableArray<NSNumber *> *stack = [NSMutableArray array];
    for(NSInteger i = 0; i < [stack count]; i++){
        if(stack.count == 0 || rect[stack.lastObject.integerValue].integerValue <= rect[i].integerValue){
            [stack addObject:rect[i]];
        } else {
            NSInteger idx = stack.lastObject.integerValue;
            [stack removeLastObject];
            
            maxSize = MAX(maxSize, rect[idx].integerValue * ([stack count] ? i : (i - rect.lastObject.integerValue - 1)));
            --i; //i 当前值只有等大于top的时候，菜更新
        }
    }
    return maxSize;
}


@end
