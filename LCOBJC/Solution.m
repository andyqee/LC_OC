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

//- (NSString *)decodeString_i:(NSString *)str
//{
//    if(str.length < 4) {
//        return str;
//    }
//    
//}

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

// - (NSString *)decodeString_r:(NSString *)str
// {

// }

#pragma mark - decode way

// 数子字符串,
// 这题目的关键是对不同数字 0，1，2，6，对应着不同的组合情况，其中0的处理尤其特别
// 注意: 如果第一个字符是0，直接返回0
// FB 重点
// O(n)
// 字符串转换的一定要考虑有哪些 invalid case

- (NSInteger)numDecodings:(NSString *)str
{
    //corner case
    if ([str length] == 0) {
        return 0;
    }
    //check if the first ch is 0
    NSString *ch = [str substringWithRange:NSMakeRange(0, 1)];
    if([ch isEqualToString:@"0"]){
        return 0;
    }
    
    NSMutableArray<NSNumber *> *dp = [NSMutableArray arrayWithCapacity:str.length + 1];
    for(NSInteger i = 0; i <= str.length; i++){
        [dp addObject:@1];//这里初始化应该是1
    }

    for (NSInteger i = 1; i < str.length; i++) {
       NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
       NSString *prev = [str substringWithRange:NSMakeRange(i - 1, 1)];
        
      if(ch.integerValue > 6){
        if(prev.integerValue == 1){
            dp[i+1] = @(dp[i].integerValue + dp[i-1].integerValue);
        } else {
            dp[i+1] = dp[i];
        }      
      } else if(ch.integerValue > 0){
          if(prev.integerValue == 1 || prev.integerValue == 2){
              dp[i+1] = @(dp[i].integerValue + dp[i-1].integerValue);
          } else {
             dp[i+1] = dp[i];
          }
      } else {
          if (prev.integerValue == 1 || prev.integerValue == 2) {
              dp[i+1] = dp[i-1];
          } else {
              return 0;
          }
      }
    }
    return dp[str.length].integerValue;
}

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

@end

@implementation NSString (FBSort) 

- (NSString *)sorted
{
    NSMutableArray *charArray = [NSMutableArray arrayWithCapacity:self.length];
    for (int i=0; i< self.length; ++i) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        [charArray addObject:charStr];
    }
    return [[charArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] componentsJoinedByString:@""];
}

@end

@implementation Solution (Array)


//用queue 来实现

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
