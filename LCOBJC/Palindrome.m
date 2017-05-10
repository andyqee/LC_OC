//
//  Palindrome.m
//  LCOBJC
//
//  Created by ethon_qi on 7/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import "Palindrome.h"

@interface NSString (FBI)

- (NSString *)reversed;

@end

@implementation NSString (FBI)

- (NSString *)reversed
{
    NSMutableString *str = [NSMutableString string];
    
    for (NSInteger i = self.length - 1; i > 0; i--) {
        NSString *ch = [self substringWithRange:NSMakeRange(i, 1)];
        [str appendString:ch];
    }
    return [str copy];
}

@end

@implementation Palindrome

#pragma mark - 5. Longest Palindromic Substring

// 返回长度也是用这种办法

// ....abcd.....
//  i - j < 2    ji  这种和dp[i][j] 和 dp[j+1][i-1] 没有关系
// time n^2 space n^2
// dp[i][j] represent if the substring with range (i - 1, j -1) is a palindrome

// Fellow up: if we need to count how many palindromic substring ?
// the one solution is to use additional table[i][j] to represent the count

//FIXME: table[i][j] = table[i][j-1] + table[i-1][j] - table[i-1][j-1] + (dp[i][j] == YES ? 1 : 0)

// Fellow up : 如果要算distint ,那就用 Set 去重
// http://www.geeksforgeeks.org/find-number-distinct-palindromic-sub-strings-given-string/
// http://www.geeksforgeeks.org/count-palindrome-sub-strings-string/

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

// TODO: 优先考虑这个办法 半径法, 中心从两边扩散, 需要讨论奇偶 [R]

- (NSString *)longestPalindromeMethod2:(NSString *)str
{
    if (str.length < 2) {
        return str;
    }
    //odd and even len of string should be processed seperately
    
    NSRange range = NSMakeRange(0, 1);
    
    for (NSInteger i = 0; i < str.length - 1; i++) {
        NSRange r1 = [self scanString:str startAtIndex:i index:i];// odd
        range = (r1.length > range.length) ? r1 : range;
        NSRange r2 =[self scanString:str startAtIndex:i index:i + 1]; //even
        range = (r2.length > range.length) ? r2 : range;
    }
    return [str substringWithRange:range];
}

// 这里如果改写下，也可以变成获取palindrome的数目

- (NSRange)scanString:(NSString *)str startAtIndex:(NSInteger)left index:(NSInteger)right
{
    while(left >= 0 && right < str.length){
        NSString *l = [str substringWithRange:NSMakeRange(left, 1)];
        NSString *r = [str substringWithRange:NSMakeRange(right, 1)];
        if (![l isEqualToString:r]) {
            break;
        }
        left--;
        right++;
    }
    return NSMakeRange(left, right - left - 1);
}

#pragma mark - 409. Longest Palindromen [E]

//- (NSInteger)lengthOfLongestPalindrome:(NSString *)str
//{
//    if (str.length < 2) {
//        return str.length;
//    }
//    
//    //step 1: build char -frequency map
//    
//    //step 2: over loop
//    
//    //step 3 : count the total number of even , we need add the max number of odd frequncy
//    
//}

#pragma mark - 214. Shortest Palindrome [H]

// FIXME: solution: 1. find the longest palindrome substring start with the first char
// palidrome string has a specail chracters that str == str.reversed
// So here we

- (NSString *)shortestPalindrome:(NSString *)str
{
    if(str.length < 2){
        return str;
    }
    // create reversed version
    NSString *reversed = [str reversed];
    NSInteger n = str.length;
    // FXIME: toIndex 是不包含该index 所对应的字符
    while (n >= 0) {
        if([[str substringToIndex:n] isEqualToString:[reversed substringFromIndex:str.length - n]]){
            break;
        }
        n--;
    }
    n++;
    
    NSMutableString *mstr = [[reversed substringToIndex:str.length - n] mutableCopy];
    [mstr appendString:str];
    
    return [mstr copy];
}

// 336. Palindrome Pairs
// 这道题目运用到的思路 和上面那道题有一些类似，在构建map 的key
// 举个例子:  "abcc"  "ba"
// TODO: 关键思路: 拆分 "abcc" = "ab" + "cc" ,如果我们发现 “cc” 是回文。那么就用左边的部分reverse 去map 里面找，变会找到 ba。 这样就会找到pair 了。
// 这里要注意顺序

//- (NSArray<NSNumber *> *)palindromePairs:(NSArray<NSString *> *)strs
//{
//    
//}

//266. Palindrome Permutation
//TODO: 思路: 这题的思路和 409. Longest Palindromen 非常像，统计字符的奇偶, if it contains more 1 odd frequency of char , it can not construct a Palindrome.
// 这里还用到一个技巧。 一加 一减， 最终过滤除odd frequentcy 的字符

//if(set.contains(c)) {
//    set.remove(c);
//} else {
//    set.add(c);
//}

//266. Palindrome Permutation ii
//TODO: 

//- (NSArray<NSArray *> *)permutPalindrome:(NSString *)str
//{
//    NSMutableDictionary<NSString *, NSNumber *> *map = [NSMutableDictionary dictionary];
//    // step 1: construct freq
//    for (NSInteger i = 0; i < str.length - 1; i++) {
//        NSString *r = [str substringWithRange:NSMakeRange(i, 1)];
//        if(map[r]){
//            map[r] = @(map[r].integerValue + 1);
//        } else {
//            map[r] = @0;
//        }
//    }
    // step : according the dic, build a new string array
    // step 3: handle mid. 因为mid, 如果奇数的个数大于1 就不能构建回文, mid 可能是空字符串
    // step 4 构建permutation
    
//    NSMutableArray *array = [NSMutableArray array];
//    [self _permut:[nums mutableCopy] index:0 result:array];
//    return array;
//}

//- (void)_permut:(NSMutableArray<NSNumber *> *)nums index:(NSInteger)index result:(NSMutableArray *)result
//{
//    
//}

#pragma mark - 9. Palindrome Number
// TODO: 双指针, 技巧性强

// 不能用额外的空间
// TODO: 思路 1. n >= 0, 需要计算数字的位数, 这种办法比较弱 下面是比较酷炫的办法
// 应该用快慢指针的思路
// 312213 得到 312 也就是前半段之后呢？用总的除以 前半段 之后的mod 就是后半段。？
// 不竟其然，在while的过程中 构建出了 有半部分的 reversed 版本。 技巧性很强
// 然后开始比较。

// Variable revhalf is the reversed 2nd half(x has even number of digits), or 2nd half with the middle digit(if x has odd number of digits)

//bool isPalindrome(int x) {
//    if(x < 0) return false;
//    int revhalf = 0, slow = x, fast = x;
//    while(fast){
//        revhalf = revhalf * 10 + slow % 10;
//        slow /= 10;
//        fast /= 100;
//    }
//    return slow == revhalf || slow == revhalf / 10;
//}

//public boolean isPalindrome(int x) {
//    if (x<0 || (x!=0 && x%10==0)) return false;
//    int rev = 0;
//    while (x>rev){
//        rev = rev*10 + x%10;
//        x = x/10;
//    }
//    return (x==rev || x==rev/10);
//}

// 递归版本的实现

//bool isPalindrome(int x, int &y) {
//    if (x < 0) return false;
//    if (x == 0) return true;
//    if (isPalindrome(x/10, y) && (x%10 == y%10)) {
//        y /= 10;
//        return true;
//    } else {
//        return false;
//    }
//}
//bool isPalindrome(int x) {
//    return isPalindrome(x, x);
//}

@end
