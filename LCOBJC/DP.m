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

// hard
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
            --i; //i 当前值只有等大于top的时候，才更新
        }
    }
    return maxSize;
}

// red, blue or green

#pragma mark - Paint House

- (NSInteger)minCost:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    if (matrix.count == 0) {
        return 0;
    }
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array]; // 这里可以优化成O(k) k is the number of colors
    for (NSInteger i = 0; i < matrix.count; i++) {
        [dp addObject:[matrix[i] mutableCopy]];
    }
//    可以精简成下面几行代码
//    for (int j = 0; j < 3; ++j) {
//        dp[i][j] += min(dp[i - 1][(j + 1) % 3], dp[i - 1][(j + 2) % 3]);
//    }
    for (NSInteger i = 1; i < matrix.count; i++) {
        dp[i][0] = @(MIN(matrix[i-1][1].integerValue, matrix[i-1][2].integerValue) + dp[i][0].integerValue);
        dp[i][1] = @(MIN(matrix[i-1][0].integerValue, matrix[i-1][2].integerValue) + dp[i][1].integerValue);
        dp[i][2] = @(MIN(matrix[i-1][1].integerValue, matrix[i-1][0].integerValue) + dp[i][2].integerValue);
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
            } //不需要比较k个，只需要记录最小的cost 那个，但是这个时候最小cost 的可能和当前的颜色一样，所以也要记录secon min cost
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
// ❌❌❌

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
        for(NSInteger j = 0; j < k; j++){  //❌❌❌ 因为 preMin上面用到过了，所以 这里不能更新了
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

//nums = [3,1,5,8] --> [3,5,8] -->   [3,8]   -->  [8]  --> []
//coins =  3*1*5      +  3*5*8    +  1*3*8      + 1*8*1   = 167
//这个和matrix chain 问题对应的模版是很类似的，左右分块的思路
//第二次做的时候，状态转移方程竟然忘记了
//找出区间 dp[i][j] 之间所有可能性的最大值，然后逐步扩大这个区间。
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

//309. Best Time to Buy and Sell Stock with Cooldown [M2]
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

//func lengthOfLIS(_ nums: [Int]) -> Int {
//    let count = nums.count
//    if count <= 1 {
//        return count
//    }
//    // 注意这里repeating value is 1 不是0
//    var map = [Int](repeating: 1, count: count + 1)
//    map[0] = 0
//    map[1] = 1
//    
//    var res = 1
//    for i in 2...count {
//        for j in 1..<i {
//            if nums[j-1] < nums[i-1] {
//                map[i] = max(map[j] + 1, map[i])
//            }
//        }
//        res = max(map[i], res)
//    }
//    return res
//}

// suppose the longest i s which end up with nums[i] is denoted as dp[i] = MAX(map[j] + 1, 1) j vary form [1, i -1] if
//
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
                dp[i] = @(MAX(dp[j].integerValue, dp[i].integerValue));
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

//func uniquePaths(_ m: Int, _ n: Int) -> Int {
//    // 边界case处理
//    if m <= 1 || n <= 1 {
//        return min(m, n)
//    }
//    var map = [[Int]](repeating: [Int](repeating: 0, count:n + 1), count: m + 1)
//    for i in 1...m {
//        map[i][1] = 1
//    }
//    for j in 1...n {
//        map[1][j] = 1
//    }
//    // 这里一定要注意 m 的范围是不是大于2！！
//    for i in 2...m {
//        for j in 2...n {
//            map[i][j] = map[i][j-1] + map[i-1][j] // map[2][2] = dp[2][1] + dp[1][2]
//        }
//    }
//    return map[m][n]
//}

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


@end
