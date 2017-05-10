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
    NSMutableArray<NSNumber *> *map = [NSMutableArray array];
    for(NSInteger k = 0; k <= count; k++) {
        [map addObject:@(NO)];
    }
    
    //base case
    map[0] = @(YES);
    for(NSInteger i = 1; i <= count; i++) { //
        for(NSInteger j = 1; j <= i; j++) { // 拆分成sub problem j 剩余字符的最短长度
            NSString *subStr = [str substringWithRange:NSMakeRange(i-j ,j)];
            if(map[i-j].boolValue && [set containsObject:subStr]) {
                map[i] = @(YES);
                break;
            }
        }
    }
    return [map[count] boolValue];
}
// TODO: 优化 这里如果字符串比较长, 但是dic 比较小，可以优化下 j 的范围  最大是dic 中字符的最大长度。
// Fellow up 返回结果

- (NSString *)wordBreakFollowup:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0) {
        return str;
    }
    
    NSInteger count = str.length;
    NSMutableArray<NSNumber *> *map = [NSMutableArray array];
    NSMutableArray<NSNumber *> *from = [NSMutableArray array];

    for(NSInteger k = 0; k <= count; k++) {
        [map addObject:@(NO)];
        [from addObject:@(-1)];
    }
    
    //base case
    map[0] = @(YES);
    for(NSInteger i = 1; i <= count; i++) { //
        for(NSInteger j = 0; j < i; j++) { // 拆分成sub problem define j as the index of the right part string
            NSString *subStr = [str substringWithRange:NSMakeRange(j ,i - j)];
            if(map[j].boolValue && [set containsObject:subStr]) {
                map[i] = @(YES);
                from[i] = @(j); // if we need find all the result, need to remove break. then  we can store all the index,
                break;
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

// DFS 返回所有结果
// backtracking

// worst case T: 2^n
// T(n) = T(n-1) + T(n-2) .....T(1)

- (NSArray<NSString *> *)wordBreak_2_BK:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0 || set == nil) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];

    [self _dfsWordBreak:str start:0 temp:temp result:result set:set];
    return [result copy];
}

- (void)_dfsWordBreak:(NSString *)str start:(NSInteger)start temp:(NSMutableArray *)temp result:(NSMutableArray *)result set:(NSSet *)set
{
    if(start == str.length){
        NSString *s = [temp componentsJoinedByString:@" "];
        [result addObject:s];
        return; // do not forget
    }
    
    for(NSInteger i = start + 1; i <= str.length; i++){ // i is the end of the subtring, not include
        NSString *sub = [str substringWithRange:NSMakeRange(start, i - start)];
        if([set containsObject:sub]){
            [temp addObject:sub];
            [self _dfsWordBreak:str start:i temp:temp result:result set:set];
            [temp removeLastObject];
        }
    }
}

// --------

- (NSArray<NSString *> *)wordBreak_2:(NSString *)str set:(NSSet*)set
{
    if(str.length == 0 || set == nil) {
        return nil;
    }
    
    return [self doWordBreak:str idx:0 set:set];
}

// Time complexity 有些复杂，概率性的 和set 有关

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

- (NSArray<NSString *> *)wordBreak_2_memorize:(NSString *)str set:(NSSet*)set
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return [self wordBreak_2_memorize:str set:set dic:dic];
}

// 需要dic 记忆计算结果
// O(len(wordDict) ^ len(s / minWordLenInDict)) Because there're len(wordDict) possibilities for each cut

- (NSArray<NSString *> *)wordBreak_2_memorize:(NSString *)str set:(NSSet*)set dic:(NSMutableDictionary<NSString *, NSArray*> *)dic
{
    if(str.length == 0){
        return @[@""];
    }
    
    if(dic[str]){ // 如果存在就直接返回
        return dic[str];
    }
    // we take i as the length of the substring start at 0
    NSMutableArray *rest = [NSMutableArray array];
    
    for(NSInteger i = 1; i <= str.length; i++){
        NSString *sub = [str substringWithRange:NSMakeRange(0, i)];
        NSString *leftSub = [str substringFromIndex:i];
        
        if([set containsObject:sub]){
            NSArray *temp = [self wordBreak_2_memorize:leftSub set:set dic:dic];
            if (temp.count == 0) {
                continue;
            }
            for (NSString *s in temp) {
                NSMutableString *newStr = [NSMutableString stringWithString:sub]; // 构建新的字符
                
                if([s length] > 0){ // 过滤掉s 为空依然拼接 space 的情况
                    [newStr appendString:@" "];
                    [newStr appendString:s];
                }
                
                [rest addObject:newStr];
            }
        }
    }
    
    dic[str] = [rest copy];
    return dic[str];
}

// Boom Enemy 炸弹人

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
                        colVal[j] = @(colVal[j].integerValue + 1); //这其实就是个终向滚动数组
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
// 边界弄错啦

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
        [rights addObject:@(matrix.firstObject.count)]; // 最初状态
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
        }
        
        for (NSInteger j = matrix.firstObject.count - 1; j >= 0; j--) {
            if([matrix[i][j] isEqual:@"1"]) {
                rights[j] = @(MIN(rights[j].integerValue, currRight)); //
            } else {
                currRight = j;
                rights[j] = @(matrix.firstObject.count); //why 这里需要设置成 n？ 因为要取最小值
            }
        }
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            maxSize = MAX(maxSize, (rights[j].integerValue - lefts[j].integerValue) * heights[j].integerValue);
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

// hard https://leetcode.com/problems/largest-rectangle-in-histogram/
// 用stack 管理状态，处理的关键是什么时候pop ，什么时候push，这个比较难搞
// scane from left to right
// 遇到比当前小的的就pop掉，因为它的高度不会限制rect的max size

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
    for(NSInteger i = 0; i <= [rect count]; i++){ //这里取 == 是为了处理最右边的边界
        NSInteger height = (i == [rect count] ? 0 : rect[i].integerValue);
        // Create an empty stack. The stack holds indexes of hist[] array
        // The bars stored in stack are always in increasing order of their
        // heights.
        if(stack.count == 0 || rect[stack.lastObject.integerValue].integerValue <= height){
            [stack addObject: @(i)]; //add index
        } else {
            // If this bar is lower than top of stack, then calculate area of rectangle
            // with stack top as the smallest (or minimum height) bar. 'i' is
            // 'right index' for the top and element before top in stack is 'left index'
            NSInteger idx = stack.lastObject.integerValue;
            [stack removeLastObject];
            
            maxSize = MAX(maxSize, rect[idx].integerValue * ([stack count] ? i : (i - stack.lastObject.integerValue - 1)));
            --i; //i 当前值只有等大于top的时候，才更新
        }
    }
    return maxSize;
}

// red, blue or green

#pragma mark - Paint House

// 需要和interview 确认input if its mutable

- (NSInteger)minCost:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    if (matrix.count == 0) {
        return 0;
    }
    // n * 3
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array]; // 这里可以优化成O(k) k is the number of colors
    for (NSInteger i = 0; i < matrix.count; i++) {
        [dp addObject:[matrix[i] mutableCopy]];
    }
//    可以精简成下面几行代码
//    for (int j = 0; j < 3; ++j) {
//        dp[i][j] += min(dp[i - 1][(j + 1) % 3], dp[i - 1][(j + 2) % 3]);
//    }
    for (NSInteger i = 1; i < matrix.count; i++) {
        dp[i][0] = @(MIN(dp[i - 1][1].integerValue, dp[i - 1][2].integerValue) + matrix[i][0].integerValue);
        dp[i][1] = @(MIN(dp[i - 1][0].integerValue, dp[i - 1][2].integerValue) + matrix[i][1].integerValue);
        dp[i][2] = @(MIN(dp[i - 1][1].integerValue, dp[i - 1][0].integerValue) + matrix[i][2].integerValue);
    }
    return MIN(MIN(dp[matrix.count - 1][0].integerValue, dp[matrix.count - 1][1].integerValue), dp[matrix.count - 1][2].integerValue);
}

#pragma mark - Paint House 2

// n 个房子
// 0..k-1 k 种颜色

// no two adjacent houses have the same color
// 这种表述更好一些 dp[i][j] represents the min paint cost from house 0 to house i when house i use color j
// dp[i][j] total cost end up with paint the house i with j color

// state transition equation: dp[i][j] = MIN(dp[i - 1][0...l...k]) + matrix[i][j] // while l != j
// MIN(dp[i - 1][0...l...k]) 这里取出最小值
// T: O( n * k * k )

- (NSInteger)minCost2:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    if (matrix.count == 0 || matrix.firstObject.count == 0) { //
        return 0;
    }
    NSInteger k = matrix.firstObject.count;
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for(NSInteger i = 0; i <= matrix.count; i++){
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j <= matrix.firstObject.count; j++){
            [sub addObject:@0];
        }
        [dp addObject:sub];
    }
    
    for(NSInteger j = 0; j < k; j++){ //base case
        dp[0][j] = matrix[0][j];
    }
    //general case
    for (NSInteger i = 1; i < matrix.count; i++) {
        for(NSInteger j = 0; j < k; j++){
            NSInteger temp = NSIntegerMax;
            for(NSInteger p = 0; p < k; p++){
                if(p == j) continue;
                temp = MIN(temp, dp[i - 1][p].integerValue);
            }  //不需要比较k个，只需要记录最小的cost 那个，但是这个时候最小cost 的可能和当前的颜色一样，所以也要记录secon min cost
            dp[i][j] = @(temp + matrix[i][j].integerValue);
        }
    }
    
    NSInteger minCost = NSIntegerMax;
    for (NSInteger i = 0; i < k; i++) {
        minCost = MIN(dp[matrix.count - 1][i].integerValue, minCost);
    }
    return minCost;
}

//Explanation: dp[i][j] represents the min paint cost from house 0 to house i when house i use color j; The formula will be dp[i][j] = Math.min(any k!= j| dp[i-1][k]) + costs[i][j].
//Take a closer look at the formula, we don't need an array to represent dp[i][j], we only need to know the min cost to the previous house of any color and if the color j is used on previous house to get prev min cost, use the second min cost that are not using color j on the previous house. So I have three variable to record: prevMin, prevMinColor, prevSecondMin. and the above formula will be translated into: dp[currentHouse][currentColor] = (currentColor == prevMinColor? prevSecondMin: prevMin) + costs[currentHouse][currentColor].

// 下面这个解法可以合并

// 是个错误的解法

- (NSInteger)minCost2_optmize:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    if (matrix.count == 0 || matrix.firstObject.count == 0) { //
        return 0;
    }
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for(NSInteger i = 0; i < matrix.count; i++){
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            [sub addObject:@0];
        }
        [dp addObject:sub];
    }
    NSInteger prevMin = NSIntegerMax;
    NSInteger prevSecondMin = NSIntegerMax;
    NSInteger prevColor = 0;
    
    NSInteger k = matrix.firstObject.count;
    for(NSInteger j = 0; j < k; j++){ //step 1 : base case
        if(prevMin > matrix[0][j].integerValue){
            prevMin = matrix[0][j].integerValue;
            prevColor = j;
        } else if(prevSecondMin > matrix[0][j].integerValue) {
            prevSecondMin = matrix[0][j].integerValue;
        }
    }
    
    for (NSInteger i = 1; i < matrix.count; i++) { //step 2 : general case
        for(NSInteger j = 0; j < k; j++){
            if(j == prevColor){
                dp[i][j] = @(matrix[i][j].integerValue + prevSecondMin);
            } else {
                dp[i][j] = @(matrix[i][j].integerValue + prevMin);
            }
        } //update prevMin
        for(NSInteger j = 0; j < k; j++){  //因为 preMin上面用到过了，所以 这里不能更新了
            if(prevMin > dp[i][j].integerValue){
                prevMin = dp[i][j].integerValue;
                prevColor = j;
            } else if(prevSecondMin > dp[i][j].integerValue) {
                prevSecondMin = dp[i][j].integerValue;
            }
        }
    }
    
    NSInteger n = matrix.count - 1; //
    NSInteger res = NSIntegerMax;
    for(NSInteger j = 0; j < k; j++){
        res = MIN(res, dp[n][j].integerValue);
    }
    return res;
    //这里需要再算一遍最小值
}

// step 1:  将i == 0 合并进去

- (NSInteger)minCost2_optmize2:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    if (matrix.count == 0 || matrix.firstObject.count == 0) { //
        return 0;
    }
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for(NSInteger i = 0; i < matrix.count; i++){
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            [sub addObject:@0];
        }
        [dp addObject:sub];
    }
    
    NSInteger prevMin = 0;
    NSInteger prevSecondMin = 0;
    NSInteger prevColor = -1;
    
    NSInteger k = matrix.firstObject.count;
    for (NSInteger i = 0; i < matrix.count; i++) { //step 2 : general case
        NSInteger currMin = NSIntegerMax;
        NSInteger currSecondMin = NSIntegerMax;
        NSInteger currColor = -1;
        for(NSInteger j = 0; j < k; j++){
            if(j == prevColor){
                dp[i][j] = @(matrix[i][j].integerValue + prevSecondMin);
            } else {
                dp[i][j] = @(matrix[i][j].integerValue + prevMin); // 这个就可以兼容 i == 0
            }
            if(currMin > dp[i][j].integerValue) {
                currMin = dp[i][j].integerValue;
                currColor = j;
            } else if(currSecondMin > dp[i][j].integerValue) {
                currSecondMin = dp[i][j].integerValue;
            }
        } //update prevMin
        
        prevMin = currMin;
        prevSecondMin = currSecondMin;
        prevColor = currColor;
    }
    return prevMin;
}

// Paint Fence
// You have to paint all the posts such that no more than two adjacent fence posts have the same color
// 关键是这个 f(n) = (k-1)(f(n-1)+f(n-2)) // k

- (NSInteger)numWays:(NSInteger)n color:(NSInteger)k
{
    NSMutableArray<NSNumber *> *dp = [NSMutableArray array];
    for (NSInteger i = 0; i <= n; i++) {
        if(n == 1){
            [dp addObject:@(k)];
        } else if(n == 2){
            [dp addObject:@(k * k)];
        } else {
            [dp addObject:@(0)];
        }
    }
    
    for(NSInteger i = 3; i <= n; i++){
        dp[i] = @((dp[i - 1].integerValue + dp[i - 2].integerValue) * (k - 1));
    }
    
    return dp[n].integerValue;
}

- (NSInteger)numWaysOptimizeSpace:(NSInteger)n color:(NSInteger)k
{
    NSInteger s1 = k;
    NSInteger s2 = k * k;
    NSInteger s3 = 0;
    if(n == 1){
        return s1;
    } else if(n == 2){
        return s2;
    }
    
    for(NSInteger i = 3; i <= n; i++){
        s3 = (s1 + s2) * (k - 1);
        s1 = s2;
        s2 = s3;
    }
    
    return s3;
}

//corner case : 数组包含空字符串怎么处理
//general case:
//1.space 均匀插入,如果不能均匀，左边的比右边的多
//2. 最后一行是left justified

// [
//    "This    is    an",
//    "example  of text",
//    "justification.  "
// ]

// one line constrain : word[i..j] + (j - i) <= L && word[i..j+1] + (j - i + 1) > L

- (NSArray<NSString *> *)fullJustify:(NSArray<NSString *> *)str length:(NSInteger)len
{
    NSMutableArray *res = [NSMutableArray array];
    NSInteger i = 0;
    while (i < str.count) {
        NSInteger j = i;
        NSInteger wordLen = str[j].length;
        while(wordLen + j - i <= len){
            j++;
            wordLen += str[j].length;
        }
        NSInteger space = len - (wordLen - str[j].length); //总共剩space
        j--;//rollback

        NSString *line = [self buildLine:str start:i end:j totalSpace:space];
        [res addObject:line];
        
        i = j + 1; //go to next line
    }
    return res;
}

- (NSString *)buildLine:(NSArray<NSString *> *)str start:(NSInteger)i end:(NSInteger)j totalSpace:(NSInteger)space
{
    NSMutableString *line;
    if(i == j){
        line = [NSMutableString stringWithString:str[i]];
        while (space > 0) {
            [line appendString:@" "];
            space--;
        }
    } else {
        line = [NSMutableString string];
        NSInteger d = space / (i - j);
        NSInteger yu = space % (i - j);
        while(i <= j){
            [line appendString:str[i]];
            NSInteger t = d;
            while (t > 0) {
                t--;
                [line appendString:@" "];
            }
            while(yu > 0){
                yu--;
                [line appendString:@" "];
            }
            i++;
        }
    }
    return line;
}

//312. Burst Balloons [H]

// nums = [3,1,5,8] --> [3,5,8] -->   [3,8]   -->  [8]  --> []
// coins =  3*1*5      +  3*5*8    +  1*3*8      + 1*8*1   = 167
// 这个和matrix chain 问题对应的模版是很类似的，左右分块的思路
// 第二次做的时候，状态转移方程竟然忘记了
// 找出区间 dp[i][j] 之间所有可能性的最大值，然后逐步扩大这个区间。
// dp[i][j] = MAX(dp[i][l] +  num[l]  * num[r] * num[l] +  dp[l][r]) l -> (i+1, r+1) // 最后一个burst位置l
//  $1,[3,1,5,8] $1
// 这里 l 的变化区间 正好是 1 ~ 4 // 0 和 5 直接被规避掉了
//
- (NSInteger)maxCoin:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *>  *num = [NSMutableArray arrayWithObject:@1];
    [num addObjectsFromArray:nums];
    [num addObject:@1];
    
    NSInteger length = num.count;
    
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for(NSInteger i = 0; i < length; i++){
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j < length; j++){
            [sub addObject:@0];
        }
        [dp addObject:sub];
    }
    
    for(NSInteger len = 2; len < length; len++){
        for(NSInteger l = 0; l < length - len; l++){
            NSInteger r = l + len;// 最小覆盖三个元素
            for(NSInteger k = l + 1; k < r; k++){
                dp[l][r] = @(MAX(dp[l][r].integerValue,
                                 dp[l][k].integerValue + num[k].integerValue * num[l].integerValue * num[r].integerValue + dp[k][r].integerValue));
            }
        }
    }
    return dp[0][length - 1].integerValue;
}

// 309. Best Time to Buy and Sell Stock with Cooldown [M2]
// 这个理解的过程没有记录下来
// step 1: 三个数组分别标记状态

// prices = [1, 2, 3, 0, 2]
// buy[i] means before day i what is the maxProfit for any sequence end with buy.
//
// sell[i] means before day i what is the maxProfit for any sequence end with sell.
//
// rest[i] means before day i what is the maxProfit for any sequence end with rest.

//One tricky point is how do you make sure you sell before you buy, since from the equations it seems that [buy, rest, buy] is entirely possible.

//
//Well, the answer lies within the fact that buy[i] <= rest[i] which means rest[i] = max(sell[i-1], rest[i-1]). That made sure [buy, rest, buy] is never occurred.
//
//A further observation is that and rest[i] <= sell[i] is also true therefore
//
//rest[i] = sell[i-1]
//Substitute this in to buy[i] we now have 2 functions instead of 3:
//
//buy[i] = max(sell[i-2]-price, buy[i-1])
//sell[i] = max(buy[i-1]+price, sell[i-1])
//This is better than 3, but
//
//we can do even better
//
//Since states of day i relies only on i-1 and i-2 we can reduce the O(n) space to O(1). And here we are at our final solution:

#pragma mark - Fellow up

// Fellow up: out put transaction
// http://www.1point3acres.com/bbs/thread-217319-1-1.html

// https://mnmunknown.gitbooks.io/algorithm-notes/content/626,_dong_tai_gui_hua_ff0c_subarray_lei.html
// http://codeforces.com/blog/entry/13713
// 局部最优解和全局最优解之间状态的切换

- (NSInteger)maxProfitCooldown:(NSArray<NSNumber *> *)prices
{
    NSMutableArray<NSNumber *> *buy = [NSMutableArray array];
    NSMutableArray<NSNumber *> *sell = [buy mutableCopy];
    NSMutableArray<NSNumber *> *rest = [buy mutableCopy];
    
    for(NSInteger i = 0; i < prices.count; i++){
        [buy addObject:@(- prices[i].integerValue)];
        [sell addObject:@(NSIntegerMin)];
        [rest addObject:@0];
    }
    
    for(NSInteger i = 1; i < prices.count; i++){
        buy[i] = @(MAX(buy[i - 1].integerValue , rest[i - 1].integerValue - prices[i].integerValue)); // 另一种情况是没有买, 之前已经sell 了
        //cooldown should after sell
        sell[i] = @(MAX(buy[i - 1].integerValue + prices[i].integerValue, sell[i - 1].integerValue)); //
        //rest[i] = @(MAX(MAX(buy[i - 1].integerValue , sell[i - 1].integerValue), rest[i-1].integerValue));
        rest[i] = @(MAX(sell[i - 1].integerValue, rest[i-1].integerValue));
    }
    
    return MAX(sell[prices.count - 1].integerValue, rest[prices.count - 1].integerValue);
}

// 下面是优化空间版本的

public int maxProfit(int[] prices) {
    if (prices == null || prices.length < 2) {//note that prices.length < 2 to avoid buy[1] oob when length == 1 !!!
        return 0;
    }
    int sell = 0, prev_sell = 0;
    int buy = Integer.MIN_VALUE, prev_buy = Integer.MIN_VALUE;
    for (int i : prices) {
        prev_buy = buy;
        buy = Math.max(prev_sell - i, prev_buy);
        prev_sell = sell;
        sell = Math.max(prev_buy + i, prev_sell);
    }
    return sell;
}

//121. Best Time to Buy and Sell Stock

// Example 1:
// Input: [7, 1, 5, 3, 6, 4]
// Output: 5

// max. difference = 6-1 = 5 (not 7-1 = 6, as selling price needs to be larger than buying price)
// Example 2:
// Input: [7, 6, 4, 3, 1]
// Output: 0

- (NSInteger)maxProfit:(NSArray<NSNumber *> *)prices
{
    NSAssert([prices count] >= 2, @"");
    
    NSInteger maxProfit = 0;
    NSInteger minPrice = prices.firstObject.integerValue; //注意这里不是0，如果是0 [10, 22] 就不对了。
    
    for(NSInteger i = 1; i < [prices count]; i++){
        if([prices[i] compare:prices[i - 1]] == NSOrderedDescending){
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
    NSInteger count = prices.count;
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:count];
    [dp addObject:@(0)];//站位
    
    for(NSInteger i = 1; i < [prices count]; i++){
        NSInteger temp = prices[i].integerValue - prices[i-1].integerValue; //大于> 就累加
        [dp addObject: @(MAX(dp[i].integerValue + temp, dp[i].integerValue))];
    }
    return dp[count - 1].integerValue;
}

- (NSInteger)maxProfit_2_optimizeSpace:(NSArray<NSNumber *> *)prices
{
    if([prices count] < 2){
        return 0;
    }
    NSInteger maxProfit = 0;
    
    for(NSInteger i = 1; i < [prices count]; i++){
        NSInteger temp = prices[i].integerValue - prices[i-1].integerValue; //大于> 就累加
        maxProfit = MAX(maxProfit + temp, maxProfit);
    }
    return maxProfit;
}

//123. Best Time to Buy and Sell Stock III

// 最多交易两次
// 第一遍没什么思路
// 没在题库里面看到

//- (NSInteger)maxProfit_3:(NSArray<NSNumber *> *)prices
//{
//    
//}
//
////188. Best Time to Buy and Sell Stock IV
//
//- (NSInteger)maxProfit:(NSArray<NSNumber *> *)prices k:(NSInteger)k
//{
//
//}

#pragma mark -
#pragma mark - 300. Longest Increasing Subsequence [M]

// suppose the longest i s which end up with nums[i] is denoted as dp[i] = MAX(map[j] + 1, 1) j vary form [1, i -1] if
// http://www.geeksforgeeks.org/dynamic-programming-set-3-longest-increasing-subsequence/

- (NSInteger)longestLIS:(NSArray<NSNumber *> *)nums
{
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:nums.count];
    for(NSInteger i = 0; i < nums.count; i++){
        [dp addObject:@1];
    }
    NSInteger maxRes = 1;
    for(NSInteger i = 1; i < nums.count; i++){
        for (NSInteger j = 0; j < i; j++) {
            if(nums[i].integerValue > nums[j].integerValue){
                dp[i] = @(MAX(dp[j].integerValue + 1, dp[i].integerValue)); // 不能忘记 + 1
            }
        }
        maxRes = MAX(maxRes, dp[i].integerValue);
    }
    return maxRes;
}


//    A robot is located at the top-left corner of a m x n grid (marked 'Start' in the diagram below).
//
//    The robot can only move either down or right at any point in time. The robot is trying to reach the bottom-right corner of the grid (marked 'Finish' in the diagram below).

//Thus, we have the following state equations: suppose the number of paths to arrive at a point (i, j) is denoted as P[i][j], it is easily concluded that P[i][j] = P[i - 1][j] + P[i][j - 1].
//
//The boundary conditions of the above equation occur at the leftmost column (P[i][j - 1] does not exist) and the uppermost row (P[i - 1][j] does not exist). These conditions can be handled by initialization (pre-processing) --- initialize P[0][j] = 1, P[i][0] = 1 for all valid i, j. Note the initial value is 1 instead of 0!

// 关键: 初始化 1 not 0
//dp[j] = dp[j] + dp[j-1]  优化成一维度数组

#pragma mark - uniquePaths

- (NSInteger)uniquePaths:(NSInteger)m n:(NSInteger)n
{
    //并且上面的边界case 也可以优化, 分析下最后 corner case 能不能merge过来, 这种方法比我原来的简洁许多
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for (NSInteger i = 0; i < m; i++) {
        NSMutableArray *sub = [NSMutableArray array];
        for (NSInteger j = 0; j < n; j++){
            [sub addObject:@1];
        }
        [dp addObject:sub];
    }
    
    for (NSInteger i = 1; i < m; i++) {
        for (NSInteger j = 1; j < n; j++){
            dp[i][j] = @(dp[i][j - 1].integerValue + dp[i - 1][j].integerValue);
        }
    }
    return dp[m-1][n-1].integerValue;
}

- (NSInteger)uniquePathsWithObstacles:(NSArray<NSArray<NSNumber *> *> *)obstacleGrid
{
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for (NSInteger i = 0; i <= obstacleGrid.count; i++) {
        NSMutableArray *sub = [NSMutableArray array];
        for (NSInteger j = 0; j <= obstacleGrid.firstObject.count; j++){
            NSInteger repeatingValue = (obstacleGrid[0][0].integerValue == 1) ? 0 : 1;
            [sub addObject:@(repeatingValue)];
        }
        [dp addObject:sub];
    }
    dp[0][1] = @1; //关键 非常重要的技巧，主要是兼容 dp[1][1] = dp[1][0] + dp[0][1]。
    for (NSInteger i = 1; i <= obstacleGrid.count; i++) {
        for (NSInteger j = 1; j <= obstacleGrid.firstObject.count; j++){
            dp[i][j] = (obstacleGrid[i - 1][j - 1].integerValue == 1) ? @0 : @(dp[i - 1][j].integerValue + dp[i][j-1].integerValue);
        }
    }
    return dp[obstacleGrid.count][obstacleGrid.firstObject.count].integerValue;
}

// 优化空间

- (NSInteger)uniquePathsWithObstacles_OptimizeSpace:(NSArray<NSArray<NSNumber *> *> *)obstacleGrid
{
    NSMutableArray<NSNumber *> *dp = [NSMutableArray array];
    for (NSInteger j = 0; j <= obstacleGrid.firstObject.count; j++){
        [dp addObject:@0];
    }
    
    dp[0] = @1; //非常重要的技巧
    for (NSInteger i = 1; i <= obstacleGrid.count; i++) {
        for (NSInteger j = 1; j <= obstacleGrid.firstObject.count; j++){
            dp[j] = (obstacleGrid[i - 1][j - 1].integerValue == 1) ? @0 : @(dp[j].integerValue + dp[j-1].integerValue);
        }
    }
    return dp[obstacleGrid.firstObject.count].integerValue;
}

//method DP, //还有一种方法是用stack 来实现
//DP[i]：以s[i-1]为结尾的 longest valid parentheses substring的长度
// dp[i] = @(dp[i-1].integerValue + 2 + dp[j].integerValue)

- (NSInteger)longestValidParentheses:(NSString *)str
{
    NSUInteger n = str.length + 1;
    NSInteger max = 0;
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
        // 这个状态转移方程不太好整
        
        if([ch isEqualToString:@"("] || j < 0 || [[str substringWithRange:NSMakeRange(j-1, 1)] isEqualToString:@")"]){
            dp[i] = @(0);
        } else {
            dp[i] = @(dp[i-1].integerValue + 2 + dp[j].integerValue); //
            max = MAX(max, dp[i].integerValue);
        }
    }
    return max;
}

#pragma mark - 44. Wildcard Matching

//p[j-1] == s[i-1] || p[j-1] == '?'：dp[i][j] = dp[i-1][j-1]
//p[j-1] == '*'：
//1. 匹配0个字符：dp[i][j] = dp[i][j-1]
//2. 匹配1个字符：dp[i][j] = dp[i-1][j-1]
//3. 匹配多个字符：dp[i][j] = dp[i-1][j]

- (BOOL)isMatchWildcard_dp2Array:(NSString *)str withPatten:(NSString *)p
{
    NSInteger m = str.length + 1;
    NSInteger n = p.length + 1;
    
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for (NSInteger i = 0 ; i < m; i++) {
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j < n; j++){
            [sub addObject:@NO];
        }
        [dp addObject:sub];
    }
    
    dp[0][0] = @(YES); // base case
    for(NSInteger j = 1; j < n; j++){
        dp[0][j] = @(dp[0][j - 1].boolValue && ([[p substringWithRange:NSMakeRange(j - 1, 1)] isEqualToString:@"*"])); //str = "" p ="********"
    }
    
    for (NSInteger i = 1 ; i < m; i++) {
        for(NSInteger j = 1; j < n; j++){
            NSString *strCh = [str substringWithRange:NSMakeRange(i - 1, 1)];
            NSString *pCh = [p substringWithRange:NSMakeRange(j - 1, 1)];
            if([pCh isEqualToString:@"?"] || [pCh isEqualToString:strCh]) {
                dp[i][j] = dp[i-1][j-1];
            } else if([pCh isEqualToString:@"*"]){
                dp[i][j] = @(dp[i-1][j-1].boolValue || dp[i][j-1].boolValue || dp[i-1][j].boolValue);// 中间那个是匹配0个, 这里也可以把1个 给取消掉，因为多次和0次cover 了这个case
            } else {
                dp[i][j] = @(NO);
            }
        }
    }
    
    return dp[m][n].boolValue;
}

//1. 转成一维，size 和inloop 相同
//2. 需要两个变量
//3.

- (BOOL)isMatchWildcard_dp1Array:(NSString *)str withPatten:(NSString *)p
{
    NSMutableArray<NSNumber *> *dp = [NSMutableArray array];
    
    NSInteger m = str.length + 1;
    NSInteger n = p.length + 1;
    dp[0] = @(YES);
    
    for (NSInteger i = 0 ; i < m; i++) {
        NSNumber *prev = dp[0]; //这里是0
        dp[0] = (i== 0) ? @YES : @NO;// 这里有些问题
        for(NSInteger j = 1; j < n; j++){
            NSNumber *temp = dp[j]; // 相当于 dp[i-1][j]
            
            NSString *strCh = [str substringWithRange:NSMakeRange(i - 1, 1)];
            NSString *pCh = [p substringWithRange:NSMakeRange(j - 1, 1)];
            
            if([pCh isEqualToString:@"?"] || [pCh isEqualToString:strCh]) {
                dp[j] = prev;
            } else if([pCh isEqualToString:@"*"]){
                dp[j] = @(prev.boolValue || dp[j].boolValue || dp[j-1].boolValue); // 中间那个是匹配灵个
            }
            prev = temp; // dp[i][j-1] 保留上一次内部循环的作用
        }
    }
    return dp[m].boolValue;
}

//二维数组转成 1纬

- (BOOL)isMatchWildcard:(NSString *)str withPatten:(NSString *)p
{
    return [self _isMatchWildcard:str i:0 withPatten:p j:0];
}

- (BOOL)_isMatchWildcard:(NSString *)str i:(NSInteger)i withPatten:(NSString *)p j:(NSInteger)j
{
    if(i > str.length || j > str.length){
        return NO;
    }
    if(i == str.length && j == str.length){ //两个字符必须得完全匹配完，所以这里是 == length
        return YES;
    }
    NSString *strCh = [str substringWithRange:NSMakeRange(i, 1)];
    NSString *pCh = [p substringWithRange:NSMakeRange(j, 1)];
    
    if([pCh isEqualToString:@"?"] || [pCh isEqualToString:strCh]){
        return [self _isMatchWildcard:str i:i + 1 withPatten:p j:j + 1]; //匹配一个字符
    } else if([pCh isEqualToString:@"*"]){ //1. compare one more  2.compare zero
        return [self _isMatchWildcard:str i:i + 1 withPatten:p j:j] || [self _isMatchWildcard:str i:i withPatten:p j:j+1];
    } else {
        return NO;
    }
}

#pragma mark - 198. House Robber

//这里也可以将空间O(n) 优化到O（1）
// Fellow up: 如何找到所有 rob 的house 呢？

- (NSInteger)rob:(NSArray<NSNumber *> *)nums
{
    NSInteger n = nums.count;
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:2];
    [dp addObject:nums[0]];
    [dp addObject:@(MAX(nums[0].integerValue, nums[1].integerValue))];
    
    for(NSInteger i = 2; i < n; i++) {
        dp[i % 2] = @(MAX(dp[(i - 2) % 2].integerValue + nums[i].integerValue, dp[(i - 1) % 2].integerValue));
    }
    return dp[(n - 1) % 2].integerValue;
}

- (NSInteger)rob:(NSArray<NSNumber *> *)nums l:(NSInteger)l r:(NSInteger)r
{
//    if(r - l <= 2){  可以省略
//        return MAX(nums[l].integerValue, nums[r].integerValue);
//    }
    NSInteger prevprev = nums[l].integerValue;
    NSInteger prev = MAX(nums[l].integerValue, nums[l + 1].integerValue);

    NSInteger curr = 0;
    for(NSInteger i = l + 2; i <= r; i++){
        curr = MAX(prev, prevprev + nums[i].integerValue);
        prevprev = prev;
        prev = curr;
    }
    return prev;
}

//methos 1 : 首先想到的是用两个数组
//其实可以用第一问的方法来写

- (NSInteger)rob_2:(NSArray<NSNumber *> *)nums
{
    NSInteger n = nums.count;
    if(n < 2) return (n > 0 ? nums[0].integerValue : 0);
    return MAX([self rob:nums l:0 r:n - 2], [self rob:nums l:1 r:n - 1]); //递归调用
}


//Given many coins of 3 different face values, print the combination sums of the coins up to 1000. Must be printed in order.
//
//eg: coins(10, 15, 55)
//print:
//10
//15
//20
//25
//30
//.
//.
//.
//1000

// 太巧妙啦！！！
//public void printSums(int c1, int c2, int c3) {
//    
//    Set<Integer> sums = new HashSet<>();
//    sums.add(0);
//    
//    for(int sum = 1; sum <= 1000; sum++) {
//        
//        if(sums.contains(sum - c1) || sums.contains(sum - c2) || sums.contains(sum - c3)) {
//            System.out.println(sum);
//            sums.add(sum);
//        }
//    }
//}


关于decode way要给出所有的string。写完之后问复杂度这个DFS复杂度是多少呢

public List<String> decode(String encode)
{
    List<String> result = new ArrayList<String>();
    HashMap<Integer,String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.put(3, "C");
    map.put(4, "D");
    map.put(5, "E");
    map.put(6, "F");
    map.put(7, "G");
    map.put(8, "H");
    map.put(9, "I");
    map.put(10, "J");
    map.put(11, "K");
    map.put(12, "L");
    map.put(13, "M");
    map.put(14, "N");
    map.put(15, "O");
    map.put(16, "P");
    map.put(17, "Q");
    map.put(18, "R");
    map.put(19, "S");
    map.put(20, "T");
    map.put(21, "U");
    map.put(22, "V");
    map.put(23, "W");
    map.put(24, "X");
    map.put(25, "Y");
    map.put(26, "Z");
    
    dfs(encode, 0, "", result, map);
    return result;
}

public void dfs(String encode, int index, String curr, List<String> result, HashMap<Integer, String> map)
{
    if(index==encode.length())
    {
        result.add(curr);
        return;
    }
    
    if(isValid(encode.substring(index,index+1))){
        int num = Integer.parseInt(encode.substring(index,index+1));
        dfs(encode, index+1, curr+map.get(num), result, map);
    }
    
    if(index+1<encode.length()&&isValid(encode.substring(index,index+2))){
        int num2 = Integer.parseInt(encode.substring(index,index+2));
        dfs(encode, index+2, curr+map.get(num2), result, map);
    }
}

//private boolean isValid(String str)
//{
//    if(str.charAt(0)=='0')
//        return false;
//    int num = Integer.parseInt(str);
//    return num>=1&&num<=26;
//}

//fb有一道题是给一个int array, 给这个array建一个min heap的树，并且这个树的中序遍历的结果跟原array相同
//这里提供一个时间和空间都是o(n)的解法，
//对于一个升序的array e.g. 1 2 3 4 5 这个树只能是1
//\
//2
//\
//3
//\
//4
//\
//5
//对于一个降序的array e.g 5 4 3 2 1 这个树只能是
//1
///
//2
///
//3
///
//4
///
//5
//从这两个例子就启发用stack来解这个题
//TreeNode.
//
//{
//    int val;
//    TreeNode left;
//    TreeNode right;
//}.


//public TreeNode buildMinHeap(int[] array)
//{
//    if(array == null || array.length == 0) return null;
//    Stack<TreeNode> s = new Stack<TreeNode>();
//    for(int i = 0; i < array.length; i++)
//    {
//        TreeNode n = new TreeNode(array);
//        if(!s.isEmpty())
//        {
//            if(s.peek().val < array)
//            {
//                s.peek().right = n;
//            }
//            else
//            {
//                TreeNode left = null;
//                while(!s.isEmpty() && s.peek() > array)
//                {
//                    left = s.pop();
//                }
//                if(!s.isEmpty())
//                {
//                    s.peek().right = n;
//                }
//                n.left = left;
//            }
//        }
//        s.push(n);
//    }
//    while(s.size() > 1)
//    {
//        s.pop();
//    }
//    return s.pop();
//}


//public class Solution {
//    public int maxXing(int[][] nums) {
//        if (nums.length == 0 || nums[0].length == 0)
//            return 0;
//        int rowHit = 0;
//        int[] colHit = new int[nums[0].length];
//        int max = 0;
//        for (int i = 0; i < nums.length; i++) {
//            for (int j = 0; j < nums[0].length; j++) {
//                if (nums[i][j] == 0) continue;
//                // get rowHit
//                if (j == 0 || nums[i][j - 1] == 0) {
//                    rowHit = 0;
//                    while (j + rowHit < nums[0].length && nums[i][j + rowHit] == 1)
//                        rowHit ++;
//                }
//                // get colHit
//                if (i == 0 || nums[i - 1][j] == 0) {
//                    colHit[j] = 0;
//                    while (i + colHit[j] < nums.length && nums[i + colHit[j]][j] == 1)
//                        colHit[j] ++;
//                }
//                max = Integer.max(max, colHit[j] + rowHit - 1);
//            }
//        }
//        return max;
//    }
//}

// 思路: use the max heap to store the small half , use the min heap to store the large half
// 确保sie of maxheap is larger or equal to minheap

//public class MedianFinder {
//    PriorityQueue<Integer> min = new PriorityQueue();
//    PriorityQueue<Integer> max = new PriorityQueue(Collections.reverseOrder());
//    // Adds a number into the data structure.
//    public void addNum(int num) {
//        max.offer(num);
//        min.offer(max.poll());
//        if (max.size() < min.size()){
//            max.offer(min.poll());
//        }
//    }
//    
//    // Returns the median of current data stream
//    public double findMedian() {
//        if (max.size() == min.size()) return (max.peek() + min.peek()) /  2.0;
//        else return max.peek();
//    }
//};

@end

//@interface MedianFinder : NSObject
//
//- (void)addNum:(NSNumber *)num;
//- (NSNumber *)findMedian;
//
//@end
//
//@implementation MedianFinder
//{
//    
//}
//
//- (void)addNum:(NSNumber *)num
//{
//
//}
//
//- (NSNumber *)findMedian
//{
//
//}

@end
