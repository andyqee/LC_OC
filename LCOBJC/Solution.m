//
//  Solution.m
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Solution.h"
#import "TreeNode.h"

@implementation Solution

@end



@interface NSString (FBSort)

- (NSString *)sorted;
@end

@implementation Solution (String)

- (NSInteger)romanToInt:(NSString *)str
{
    NSDictionary<NSString *, NSNumber *> *dic = @{@"I" : @1,
                          @"V" : @5,
                          @"X" : @10,
                          @"L" : @50,
                          @"C" : @100,
                          @"D" : @500,
                          @"M" : @1000};
    NSInteger result = 0;
    for (NSInteger i = 0; i < str.length; i++) {
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        result += dic[ch].integerValue;
        
        if (i > 0 && dic[[str substringWithRange:NSMakeRange(i, 1)]].integerValue >  dic[[str substringWithRange:NSMakeRange(i-1, 1)]].integerValue) {
            result += [str substringWithRange:NSMakeRange(i, 1)].integerValue - 2 * [str substringWithRange:NSMakeRange(i-1, 1)].integerValue; // 需要减2倍
        }
    }
    return result;
}

- (NSInteger)compareVersion:(NSString *)str1 str:(NSString *)str2
{
    NSArray<NSString *> *pair = [str1 componentsSeparatedByString:@"."];//如果11. 这个字符串split之后第二个就是空字符串
    NSArray<NSString *> *pair2 = [str2 componentsSeparatedByString:@"."];
    
    if ([[pair firstObject] isEqualToString:[pair2 firstObject]]) {
        if ([[pair lastObject] isEqualToString:[pair2 lastObject]]) {
            return 0;
        } else {
            return [pair lastObject].integerValue > [pair2 lastObject].integerValue ? 1 : -1;
        }
    } else {
        return [pair firstObject].integerValue > [pair2 firstObject].integerValue ? 1 : -1;
    }
}

#pragma mark - Simplify Path

//各种corner case
//关键: 是处理 .. 需要pop

- (NSString *)simplifyPath:(NSString *)path
{
    if ([path length] == 0) {
        return nil;
    }
    
    NSArray<NSString *> *paths = [path componentsSeparatedByString:@"/"];
    NSMutableArray *res = [NSMutableArray array];
    
    for(NSString *p in paths){
        if(!([p isEqualToString:@"."] || [p isEqualToString:@""])){
            [res addObject:p];
        } else if([p isEqualToString:@".."]){
            if ([res count] > 0) {
                [res removeLastObject];
            }
        }
    }
    NSString *sp = [res componentsJoinedByString:@"/"]; //"res 是空数组，这里是返回nil
    return [NSString stringWithFormat:@"/%@",sp];
}

// 这种方法估计面试官不同意
// split the array 
// travese the array in reverse order
// append to mutableString
// 各种corner case

// What constitutes a word?
// A sequence of non-space characters constitutes a word.
// Could the input string contain leading or trailing spaces?
// Yes. However, your reversed string should not contain leading or trailing spaces.
// How about multiple spaces between two words?
// Reduce them to a single space in the reversed string.

- (void)reverseWords:(NSMutableString *)str
{
    if ([str length] == 0) {
        return;
    }
    
    [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *temp = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *new = [NSMutableString string];
    for (NSInteger i = [temp count] -1 ; i >= 0; i--) {
        if (![temp[i] isEqualToString:@" "]) {
            if (i >= 0) {
                [new appendString:temp[i]];
            }
            [new appendString:@" "];
        }
    }
    str = new;
}

//Furthermore, you may assume that the original data does not contain any digits and that digits are only for those repeat numbers, k. For example, there won't be input like 3a or 2[4].
// 上面这句话是要问面试官的
// 异常case 1 “” 2 [] 等, 比如[] 结构是否对成，另外就是有没有 空格 里面有没有数字，考虑各种异常case的
// 1[] 应该返回什么？
// 1[a]

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
            [numStack removeLastObject];

            NSString *preStr = [strStack lastObject];
            [strStack removeLastObject];

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

#pragma mark - decode way

// 数子字符串,
// 这题目的关键是对不同数字 0，1，2，6，对应着不同的组合情况，其中0的处理尤其特别
// 注意: 如果第一个字符是0，直接返回0
// FB 重点
// O(n)
// 字符串转换的一定要考虑有哪些 invalid case

- (NSInteger)numDecodings_optimizeSpace:(NSString *)str
{
    if ([str length] == 0) {
        return 0;
    }
    //check if the first ch is 0
    if ([str hasPrefix:@"0"]) {
        return 0;
    } //用这个就可以不用写下面这种呕心的饭食
//    NSString *ch = [str substringWithRange:NSMakeRange(0, 1)];
//    if([ch isEqualToString:@"0"]){
//        return 0;
//    }
    
    NSInteger fn = 1;
    NSInteger fn_1 = 1;
    NSInteger fn_2 = 1;

    for (NSInteger i = 1; i < str.length; i++) {
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *prev = [str substringWithRange:NSMakeRange(i - 1, 1)];
        
        if(ch.integerValue > 6){
            if(prev.integerValue == 1){
                fn = fn_1 + fn_2;
            } else {
                fn = fn_1;
            }
        } else if(ch.integerValue > 0){
            if(prev.integerValue == 1 || prev.integerValue == 2){
                fn = fn_1 + fn_2;
            } else {
                fn = fn_1;
            }
        } else { //0
            if (prev.integerValue == 1 || prev.integerValue == 2) {
                fn = fn_2; //这里是fn_2
            } else {
                return 0;
            }
        }
        //update
        fn_2 = fn_1;
        fn_1 = fn;
    }
    return fn_1;
}

#pragma mark - decode way prefer way

//九章的解法，更简洁,巧妙些
- (NSInteger)numDecodingsMethod2:(NSString *)str
{
    if ([str length] == 0) {
        return 0;
    }
    // invalid case
    NSString *ch = [str substringWithRange:NSMakeRange(0, 1)];
    if([ch isEqualToString:@"0"]){
        return 0;
    }
    
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:str.length + 1];
    for(NSInteger i = 0; i <= str.length; i++){
        [dp addObject:@1];//这里初始化应该是1
    }
    
    for (NSInteger i = 2; i <= str.length; i++) {
        NSString *oneDigit = [str substringWithRange:NSMakeRange(i - 1, 1)];
        dp[i] = oneDigit.integerValue != 0 ? dp[i-1] : @(0); //如果不为数字字符，这里应该是0

        NSString *twoDigit = [str substringWithRange:NSMakeRange(i - 2, 2)];
        if (twoDigit.integerValue >= 10 && twoDigit.integerValue <= 26) {
            dp[i] = @(dp[i].integerValue + dp[i-2].integerValue);
        }
    }
    return dp[str.length].integerValue;
}

// Read N Characters Given Read4

//- (NSInteger)readFromString:(NSMutableString *)buffer count:(NSInteger)count
//{
//    NSInteger len = 0;
//    BOOL endOfFile = NO;
//    while(len < count || !endOfFile){
//        NSInteger num = [self read:buffer];
//        len += num;
//        if(num < 4){
//            endOfFile = YES;
//        }
//    }
//    while(len > count){
//        [buffer deleteCharactersInRange:NSMakeRange(count, len - count)];
//    }
//    return buffer.length;
//}

//属于比较繁琐的问题，主要是耐心和细心

// https://discuss.leetcode.com/topic/30508/easiest-java-solution-with-graph-explanation/2
#pragma mark - Multiply Strings

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

        for(NSInteger j = n - 1; j >= 0; j--) {
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
            [resStr appendString:[res[i] description]];
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

// 关键是 carry, 还有头部清零

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
        [sum appendString:[NSString stringWithFormat:@"%ld", (long)curr]];
        i--;
        j--;
    }
    //这里可以check 下 是否对00 这样的输出结果，直接输出还是trim the zero
    
    NSMutableString *reversed = [NSMutableString string];
    for (NSInteger i = sum.length - 1; i >= 0; i--) {
        NSString *ch = [sum substringWithRange:NSMakeRange(i, 1)];
        if (![ch isEqualToString:@"0"]) {
            [reversed appendString:ch];
        }
    }

    return [reversed length] == 0 ? @"0" : [reversed copy];
}

//method1: backtracking
//- (NSArray<NSNumber *> *)palindromePairs:(NSArray<NSString *> *)strs
//{
//    
//}
#pragma mark - strStr

- (NSInteger)strStr:(NSString *)haystack needle:(NSString *)needle
{
    //which integer indicate not found index
    // m * n
    // 如果俩枚都是空怎么播
    if (needle.length == 0 || haystack.length == 0) {
        return - 1;
    }
    for (NSInteger i = 0; i <= haystack.length - needle.length; ++i) //这里是 <=
    {
        for (NSUInteger j = 0; j < needle.length; ++j)
        {
            if (![[haystack substringWithRange:NSMakeRange(i+j, 1)] isEqualToString:[needle substringWithRange:NSMakeRange(j, 1)]]) {
                break;
            }
            if (j == needle.length - 1) {
                return i;
            }
        }
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
        if([[str substringWithRange:NSMakeRange(start, 1)] caseInsensitiveCompare:[str substringWithRange:NSMakeRange(end, 1)]] != NSOrderedSame) {
            return NO;
        }
        start++;
        end--;
    }
    return YES;
}

// start from 1 ,这中写法容易TLE 果然是指数级别的,当把n=500 的时候, 内存和cpu都爆了，并且运算了好久。内存一直在涨，说明stack一直在涨

#pragma mark - count and say

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
    NSMutableString *result = [NSMutableString string];
    for(NSInteger i = 1; i < prev.length; i++) {
        if([[prev substringWithRange:NSMakeRange(i , 1)] isEqualToString:curStr]) {
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

// 这里在和前面元素进行比较的时候，也可以通过 i-1 index 进行比较
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

#pragma mark - group Anagrams

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
        NSString *key = [str sorted];// 如果不排序,可以用prime计算hash
        if(dic[key]) {
            [dic[key] addObject:str];
        } else {
            dic[key] = [@[str] mutableCopy];
        }
    }
    return [dic allValues];
}

#pragma mark - 5. Longest Palindromic Substring

// ....abcd.....
//  i - j < 2    ji  这种和dp[i][j] 和 dp[j+1][i-1] 没有关系
// time n^2 space n^2

- (NSString *)longestPalindrome:(NSString *)str
{
    if (str.length < 2) {
        return str;
    }
    NSInteger m = str.length;
    //dp[i][j] used to indicate if the substring with the range [j, i] is a substring
    NSMutableArray<NSMutableArray<NSNumber *> *> *map = [NSMutableArray array];
    for(NSInteger i = 0; i <= m; i++){
        NSMutableArray<NSNumber *> *sub = [NSMutableArray array];
        for(NSInteger j = 0; j <= m; j++){
            [sub addObject:@(i == j)]; //if it's one single char, set YES
        }
        [map addObject:sub];
    }

    NSInteger start = 0;
    NSInteger end = 0;
    //base case
    
    //事实上这里上面 i=j 的判断也可以合并到下面来
    for(NSInteger i = 2; i <= m; i++){ //
        for(NSInteger j = i - 1; j > 0; j--){
            NSString *p = [str substringWithRange:NSMakeRange(i - 1, 1)];
            NSString *q = [str substringWithRange:NSMakeRange(j - 1, 1)];
            if((i - j < 2) || map[i - 1][j + 1].boolValue){
                map[i][j] = @([p isEqualToString:q]);
                if(map[i][j].boolValue && i - j > end - start){
                    end = i;
                    start = j;
                }
            }
        }
    }
    return [str substringWithRange:NSMakeRange(start - 1, end - start + 1)];//注意这里是 start - 1
}


//半径法
//- (NSString *)longestPalindromeMethod2:(NSString *)str
//{
//    if (str.length < 2) {
//        return str;
//    }
//    //odd and even len of string should be processed seperately
//    
//    
//    for (NSInteger i = 0; i < str.length - 1; i++) {
//        [self scanString:str startAtIndex:i withIndex:i];
//        [self scanString:str startAtIndex:i withIndex:i + 1];
//        
//    }
//    return substring
//}

// 这里如果改写下，也可以变成获取palindrome的数目

//- (void)scanString:(NSString *)str startAtIndex:(NSInteger)left withIndex:(NSInteger)right
//{
//    while(left >= 0 && right < str.length){
//        NSString *l = [str substringWithRange:NSMakeRange(left, 1)];
//        NSString *r = [str substringWithRange:NSMakeRange(right, 1)];
//        if([l isEqualToString:r]){
//            left--;
//            right++;
//        }
//    }
//    maxLen = MAX(right - left - 1, maxLen);
//}

// 这个题目还要再写一遍

- (NSString *)numberToWords:(NSInteger)num
{
    NSArray *THOUSANDS = @[@"", @"Thousand", @"Million", @"Billion"];

    if(num == 0){
        return @"Zero";
    }
    NSMutableString *str = [NSMutableString string];

    NSInteger i = 0;
    while(num != 0){
        if(num % 1000 != 0){ // 不处理 000 个零结尾的
            NSString *temp = [self helper:num % 1000];
            [str insertString:[NSString stringWithFormat:@"%@ %@", temp, THOUSANDS[i]] atIndex:0];
        }
        num /= 1000;
        i++;
    }
    return str;
}

- (NSString *)helper:(NSInteger)num
{
    NSArray *LESS_THAN_20 = @[@"", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", @"Thirteen", @"Fourteen", @"Fifteen", @"Sixteen", @"Seventeen", @"Eighteen", @"Nineteen"];
    NSArray *TENS = @[@"", @"Ten", @"Twenty", @"Thirty", @"Forty", @"Fifty", @"Sixty", @"Seventy", @"Eighty", @"Ninety"];
    
    if(num == 0){
        return @"";
    }
    if(num < 20){
        return LESS_THAN_20[num];
    } else if(num < 100){
        return [NSString stringWithFormat:@"%@ %@", TENS[num / 10], LESS_THAN_20[num % 10]];  
    } else {
        //这里处理100 很巧妙
        NSMutableString *str = [NSMutableString string];
        [str appendString: LESS_THAN_20[num / 100]];
        [str appendString: @" Hundred"];
        if(num % 100){
            [str appendString:@" "];
            [str appendString:[self helper:num % 100]];
        }
        return [str copy];
    }
}

//127. [M]Word Ladder

// http://bangbingsyb.blogspot.jp/2014/11/leetcode-word-ladder-i-ii.html 分析过程

//LeetCode中为数不多的考图的难题。尽管题目看上去像字符串匹配题，但从“shortest transformation sequence from start to end”还是能透露出一点图论中最短路径题的味道。如何转化？
//
//1. 将每个单词看成图的一个节点。
//2. 当单词s1改变一个字符可以变成存在于字典的单词s2时，则s1与s2之间有连接。
//3. 给定s1和s2，问题I转化成了求在图中从s1->s2的最短路径长度。而问题II转化为了求所有s1->s2的最短路径。
//
//无论是求最短路径长度还是求所有最短路径，都是用BFS。在BFS中有三个关键步骤需要实现:
//
//1. 如何找到与当前节点相邻的所有节点。
//这里可以有两个策略：
//(1) 遍历整个字典，将其中每个单词与当前单词比较，判断是否只差一个字符。复杂度为：n*w，n为字典中的单词数量，w为单词长度。
//(2) 遍历当前单词的每个字符x，将其改变成a~z中除x外的任意一个，形成一个新的单词，在字典中判断是否存在。复杂度为：26*w，w为单词长度。
//这里可以和面试官讨论两种策略的取舍。对于通常的英语单词来说，长度大多小于100，而字典中的单词数则往往是成千上万，所以策略2相对较优。
//
//2. 如何标记一个节点已经被访问过，以避免重复访问。
//可以将访问过的单词从字典中删除。
//
//3. 一旦BFS找到目标单词，如何backtracking找回路径？

//me: 这里找到所有的neibor，之后，当再次再找beibor的时候 需要去除重复

// 这里的corner case 比较复杂一些
// if beginWord == endWord return ?
// if beginWord 与 endWord 相差一个字符


//- (NSInteger)ladderLength:(NSString *)beginWord endWord:(NSString *)endWord set:(NSMutableSet<NSString *> *)wordList
//{
//    //corner case
//    if ((beginWord.length == 0 && endWord.length == 0) || [beginWord isEqualToString:endWord]) {
//        return 0;
//    }
//    
//    NSMutableSet *visited = [NSMutableSet set];
//    NSMutableArray *queue = [NSMutableArray array];
//    [queue addObject:beginWord];
//    
//    NSInteger steps = 1;
//    while ([queue count]) {
//        NSInteger count = [queue count];
//        for (NSInteger i = 0; i < count; i++) {
//            NSString *node = [queue firstObject];
//            [queue removeObjectAtIndex:0];
//            [visited addObject:node];
//            
//            if([node isEqualToString:endWord]){
//                return steps;
//            }
//            NSSet<NSString *> *neighbors = [self allNeighbours:node]; //利用set，快速查找
//            if([neighbors containsObject:endWord]){  //这里也可以合并到上面那个逻辑，这样初始化为 steps = 2。现在这种写法可以快速的cut branch
//                return steps + 1; //已经找到
//            }
//            for(NSString *s in neighbors){
//                if([wordList containsObject:s] && ![visited containsObject:s]){
//                    [queue addObject:s];
//                }
//            }
//        }
//        steps++; //下一层 这个framework 和对binary tree 进行按层遍历一个模版
//    }
//    return 0; // NSNotFound
//}
//
//// 这里注意的是endWord 不需要在wordList 里面.
//
//- (NSSet<NSString *> *)allNeighbours:(NSString *)str
//{
//    NSArray *letters = [@"a,b,c,d,e,f,g,h,i,g,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" componentsSeparatedByString:@","];
//    
//    NSMutableSet *neighbours = [NSMutableSet set];
//    for (NSString *letter in letters) {
//        for(NSInteger i = 0; i < str.length; i++){
//            if(![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:letter]){
//                NSMutableString *clone = [NSMutableString stringWithString:str];
//                [clone replaceCharactersInRange:NSMakeRange(i, 1) withString:letter];
//                [neighbours addObject:clone]; // 不会出现重复
//            }
//        }
//    }
//    return neighbours;
//}

// key point:
// 1. endWord 需要加入到wordlist中
// 2. wordlist 的更新，在生成一个，就可以删除在wordlist 中对应的元素

- (NSInteger)ladderLength:(NSString *)beginWord endWord:(NSString *)endWord set:(NSMutableSet<NSString *> *)wordList
{
    //corner case
    if ((beginWord.length == 0 && endWord.length == 0) || [beginWord isEqualToString:endWord]) {
        return 0;
    }

    NSMutableSet *visited = [NSMutableSet set];
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject:beginWord];
    [wordList addObject:endWord]; // key point: 添加end进wordlist
    
    NSInteger steps = 1;
    while ([queue count]) {
        NSInteger count = [queue count];
        for (NSInteger i = 0; i < count; i++) {
            NSString *node = [queue firstObject];
            [queue removeObjectAtIndex:0];
            [visited addObject:node];

            if([node isEqualToString:endWord]){
                return steps;
            }
            NSSet<NSString *> *neighbors = [self allNeighbours:node set:wordList]; //利用set，快速查找
//            if([neighbors containsObject:endWord]){  //注意 这里也可以合并到上面那个逻辑，这样初始化为 steps = 2。现在这种写法可以快速的cut branch
//                return steps + 1; //已经找到。 这三行代码也可以去掉
//            }
            for(NSString *s in neighbors){
                if(![visited containsObject:s]){ //对于访问过的需要去重复
                    [queue addObject:s];
                }
            }
        }
        steps++; //下一层 这个framework 和对binary tree 进行按层遍历一个模版
    }
    return 0; // NSNotFound
}

// 这里注意的是endWord 不需要在wordList 里面.

- (NSSet<NSString *> *)allNeighbours:(NSString *)str set:(NSMutableSet<NSString *> *)wordList
{
    NSArray *letters = [@"a,b,c,d,e,f,g,h,i,g,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" componentsSeparatedByString:@","];

    NSMutableSet *neighbours = [NSMutableSet set];
    for (NSString *letter in letters) {
        for(NSInteger i = 0; i < str.length; i++){
            if(![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:letter]){
                NSMutableString *clone = [NSMutableString stringWithString:str];
                [clone replaceCharactersInRange:NSMakeRange(i, 1) withString:letter];
                
                if ([wordList containsObject:clone]) { // 用这种办法，需要在开始将end wordList
                    [neighbours addObject:clone]; // 不会出现重复
                    [wordList removeObject:clone];
                }
            }
        }
    }
    return neighbours;
}

// find all shortest transformation sequence
// 试试用回溯方法，那么上面的办法不行了。

- (NSArray<NSArray<NSString *> *> *)ladderLength2:(NSString *)beginWord endWord:(NSString *)endWord set:(NSMutableSet<NSString *> *)wordList
{
    NSMutableArray *result = [NSMutableArray array];
    [wordList addObject:endWord];
    [self _ladderLength2:beginWord endWord:endWord set:wordList result:result temp:[@[beginWord] mutableCopy]];
    return result;
}

- (void)_ladderLength2:(NSString *)beginWord endWord:(NSString *)endWord set:(NSMutableSet<NSString *> *)wordList result:(NSMutableArray<NSArray *> *)result temp:(NSMutableArray *)temp
{
    if([wordList count] == 0 || (result.firstObject && [temp count] > result.firstObject.count)){ // 说明已经进入到下一层级的便利
        return;
    }

    if([beginWord isEqualToString:endWord]){
        [result addObject:[temp copy]];
        return;
    }

    NSSet<NSString *> *neighbours = [self allNeighbours2:beginWord set:wordList];//
    for(NSString *neigh in neighbours){
        [temp addObject:neigh];
        [wordList removeObject:neigh];
        [self _ladderLength2:neigh endWord:endWord set:wordList result:result temp:temp];
        [temp removeLastObject];
        [wordList addObject:neigh];
    }
}

- (NSSet<NSString *> *)allNeighbours2:(NSString *)str set:(NSMutableSet<NSString *> *)wordList
{
    NSArray *letters = [@"a,b,c,d,e,f,g,h,i,g,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" componentsSeparatedByString:@","];

    NSMutableSet *neighbours = [NSMutableSet set];
    for (NSString *letter in letters) {
        for(NSInteger i = 0; i < str.length; i++){
            if(![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:letter]){
                NSMutableString *clone = [NSMutableString stringWithString:str];
                [clone replaceCharactersInRange:NSMakeRange(i, 1) withString:letter];
                if ([wordList containsObject:clone]) { // 用这种办法，需要在开始将end wordList
                    [neighbours addObject:clone]; // 不会出现重复
                }
            }
        }
    }
    return neighbours;
}

@end

@implementation NSString (FBSort) 

- (NSString *)sorted
{
    NSMutableArray *charArray = [NSMutableArray arrayWithCapacity:self.length];
    for (int i = 0; i < self.length; ++i) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        [charArray addObject:charStr];
    }
    return [[[[charArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] reverseObjectEnumerator] allObjects]
            componentsJoinedByString:@""];
}

@end

@implementation Solution (Array)
// 模拟了白板coding，发现容易出现低级错误，数组的边界

- (NSInteger)hIndex:(NSArray<NSNumber *> *)citations
{
    if(citations.count == 0){
        return 0;
    }
    NSInteger count = citations.count;
    NSMutableArray<NSNumber *> *nums = [NSMutableArray arrayWithCapacity:count + 1];
    for (NSInteger i = 0; i <= count ; i++) {
        nums[i] = @0;
    }
    for(NSInteger i = 0; i < count; i++){
        if(citations[i].integerValue >= count){
            nums[count] = @(nums[count].integerValue + 1);
        } else {
            nums[citations[i].integerValue] = @(nums[citations[i].integerValue].integerValue + 1);
        }
    }
    for(NSInteger i = count; i >= 0; i--){
        if(i < count){
            nums[i] = @(nums[i].integerValue + nums[i + 1].integerValue);
        }
        if(nums[i].integerValue >= i){ //注意这里是 >=
            return i;
        }
    }
    return 0;
}

- (NSInteger)hIndex2:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = nums.count - 1;
    NSInteger mid = 0;
    while(left < right){
        mid = (right - left) / 2 + left;
        if(nums[mid].integerValue >= nums.count - mid){
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return nums.count - left;
}
//上面这种方法更佳精简一些

- (NSInteger)hIndexMethod2:(NSArray<NSNumber *> *)nums
{
    NSInteger left = 0;
    NSInteger right = nums.count - 1;
    NSInteger mid = 0;
    while(left < right){
        mid = (right - left) / 2 + left;
        if(nums[mid].integerValue == nums.count - mid){
            return nums.count - left;
        } else if(nums[mid].integerValue > nums.count - mid){
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return nums.count - left;
}

@end

@interface MovingAverage : NSObject

@property (nonatomic, assign) NSInteger sum;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *nums;

@end

@implementation MovingAverage

// count 不能小于1
- (instancetype)initWithCount:(NSInteger)count
{
    if (self = [super init]) {
        _sum = 0;
        NSAssert(count > 0, @"count should larger than 0");
        _size = count;
        _nums = [NSMutableArray array];
    }
    return self;
}

- (float)next:(NSInteger)num
{
    if ([self.nums count] == 3) {
        self.sum -= [self.nums firstObject].integerValue;
        [self.nums removeObjectAtIndex:0];
    }
    [self.nums addObject:@(num)];
    self.sum += num;
    return (float)self.sum / [self.nums count];
}

@end
