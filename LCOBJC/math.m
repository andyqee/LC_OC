//
//  math.m
//  LCOBJC
//
//  Created by ethon_qi on 20/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "math.h"

//FIXME: 数学相关的，考虑数字溢出，精度，是否和正负相关，能不能是0
//

@implementation math

// 对romanToInt 的规则不是很了解

// IV = 1 + 5 - 1 * 2, VI = 1 + 5, 左➕右减
// invalid input check, 如果str contains some invalid string, throw exception

- (NSInteger)romanToInt:(NSString *)str
{
    NSAssert(str.length > 0, @"invalid str");
    
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
        if(!dic[ch]){
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"balala" userInfo:nil];
        }
        result += dic[ch].integerValue;
        //关键如果后面符号比前面的大，需要减去前面的digit的两倍
        if (i > 0 && dic[ch].integerValue > dic[[str substringWithRange:NSMakeRange(i-1, 1)]].integerValue) {
            result =- 2 * dic[[str substringWithRange:NSMakeRange(i-1, 1)]].integerValue; // 需要减2倍
        }
    }
    return result;
}

//TODO:

// 从左到右边 解析字符串, 关键是构建下面的表,

//int[] values = {1000,900,500,400,100,90,50,40,10,9,5,4,1};
//String[] strs = {"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"};
//
//StringBuilder sb = new StringBuilder();
//
//for(int i=0;i<values.length;i++) {
//    while(num >= values[i]) {
//        num -= values[i];
//        sb.append(strs[i]);
//    }
//}
//return sb.toString();
//}

//- (NSString *)IntToRoman:(NSInteger)num
//{
//    
//}

// http://www.cnblogs.com/grandyang/p/5619296.html

#pragma mark - perfect square 

// 方法1 ：binary search log(num) 
// 0 算不算
// 缩短范围
// https://discuss.leetcode.com/topic/49339/o-1-time-c-solution-inspired-by-q_rsqrt
// 判断是否是 一个数的平方数字，
// method1: binary search 1.left bounds 1. right num / 2 + 1
// 方法1

- (BOOL)isPerfectSquare:(NSInteger)num
{
    if(num < 0){
        return NO;
    }
    NSInteger l = 1;
    NSInteger r = num / 2 + 1;
    while(l <= r){
        NSInteger mid = (r - l) / 2 + l;
        NSInteger product = mid * mid; // 可能会溢出 问题
        if(product == num){
            return YES;
        } else if(product < num) {
            r = mid - 1;
        } else {
            l = mid + 1;
        }
    }
    return NO;
}

// 数学方法  O（sqrt（n））
// 1 = 1
// 4 = 1 + 3
// 9 = 1 + 3 + 5
// 16 = 1 + 3 + 5 + 7
// 25 = 1 + 3 + 5 + 7 + 9
// 36 = 1 + 3 + 5 + 7 + 9 + 11
// ....
// 1+3+...+(2n-1) = (2n-1 + 1)n/2 = n*n

- (BOOL)isPerfectSquareMath:(NSInteger)num
{
    NSInteger i = 1;
    while (num > 0) {
        num = num - i;
        i += 2;
    }
    return num == 0;
}

//  牛顿法
//  boolean isPerfectSquare(int num) {
//       if (num < 1) return false;
//       long t = num / 2;
//       while (t * t > num) {
//         t = (t + num / t) / 2;
//       }
//       return t * t == num;
//     }

 /** a/b = e^(ln(a))/e^(ln(b)) = e^(ln(a)-ln(b)) **/

// 这种算法精度有限制

#pragma mark - 高频 [R]
// multiplication, division and mod operator

- (NSInteger)divide:(NSInteger)dividend divisor:(NSInteger)divisor
{
    if(dividend == 0) return 0;
    if(divisor == 0) return NSIntegerMax;

    double t1 = log(ABS(dividend));
    double t2 = log(ABS(divisor));
    NSInteger res = ceil(exp(t1-t2));
    if((dividend > 0 && divisor < 0 ) || (dividend < 0 && divisor > 0 )) res = -res;
    return res;
}

//TODO:需要考虑的点:

// 注意: 1.corner case : divisor == 0, 以及 divisor == -1 可能导致溢出
//      2.convert to non-negetive 处理
//      3. s = b ，然后和 compare  with a and b <<1, 如果小的话，并且还需要一个count 来记录 b 扩大的多少倍
// 15 / 3 divide 15 by 3

// 如果需要小数，就有点复杂了

- (NSInteger)divideMethod2:(NSInteger)dividend divisor:(NSInteger)divisor
{
    if (divisor == 0 || (dividend == INT_MIN && divisor == -1)) //这个细节要注意, 正数的最大值，但是 divisor 为-1， 也会溢出
        return NSIntegerMax;
    
    NSInteger a = ABS(dividend);
    NSInteger b = ABS(divisor);
    double res = 0;
    while(b <= a){
        NSInteger dvs = b;
        NSInteger count = 1;
        while(a >= (dvs << 1)){
            dvs = dvs << 1;
            count <<= 1;
        }
        a = a - dvs;
        res = res + count;
    }
    if((dividend > 0 && divisor < 0 ) || (dividend < 0 && divisor > 0 )) res = -res;
    return res;
}

// Fellow up 带有小数点如何处理

//- (NSString *)divideFloat:(NSInteger)dividend divisor:(NSInteger)divisor
//{
//    if (divisor == 0 || (dividend == INT_MIN && divisor == -1)) //这个细节要注意, 正数的最大值，但是 divisor 为-1， 也会溢出
//        return [@(NSIntegerMax) description];
//    
//    NSInteger a = ABS(dividend);
//    NSInteger b = ABS(divisor);
//
//    while(b <= a){
//        NSInteger dvs = b;
//        NSInteger count = 1;
//        while(a >= (dvs << 1)){
//            dvs = dvs << 1;
//            count <<= 1;
//        }
//        a = a - dvs;
//        res = res + count;
//    }
//    if((dividend > 0 && divisor < 0 ) || (dividend < 0 && divisor > 0 )) res = -res;
//    return [@(res) description];
//}


#pragma mark - 168. Excel Sheet Column Title

//     1 -> A
//     2 -> B
//     3 -> C
//     ...
//     26 -> Z
//     27 -> AA
//     28 -> AB

//TODO: 思路: 1. 每次循环需要 n 减去 1
//           2. 每次要插入的都是 mod, 低的到高的都是余数
//           这种问题 可以利用 27， 26， 1， 这种边界case 来举例分析

// log (n) / log (26)

- (NSString *)convertToTitle:(NSInteger)n
{
    if(n < 1){
        return nil;
    }
    NSArray *map = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
    NSMutableString *str = [NSMutableString string];
    
    while(n > 0){
        n = n - 1; // !!! 因为前面的字符到数字的映射不是从0 开始, 这个是写在里面
        NSInteger m = n % 26;
        [str insertString:map[m] atIndex:0];
//        [str appendString:map[m]]; // 这里高效的办法是 append 最后 返回reverse
        n = n / 26;
    }
    return str;
}

- (NSInteger)convertToInt:(NSString *)n
{
    NSAssert(n.length >= 1, @"");
    
    NSArray *map = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
    NSInteger res = 0;
    for(NSInteger i = 0; i < n.length; i++){
        NSString *ch = [n substringWithRange:NSMakeRange(i, 1)];
        NSInteger idx = [map indexOfObject:ch] + 1;
        res = res * 26 + idx;
    }
    return res;
}

// 171 上面这道题反过来做

// 通过统计1的个数, 下面有三种方法
// 关键的思路是: 统计其中一个个数是否为1

- (BOOL)isPowerOfTwo:(NSInteger)n
{
    if(n <= 0){
        return NO;
    }
    // count 1
    NSInteger numberOfOne = 0;
    while (n && numberOfOne <= 1) {
        if((n & 1) == 1){
            numberOfOne++;
        }
        n = n >> 1;
    }
    return numberOfOne == 1;
}

// 下面这个方法也很巧妙
// 10种个数 http://www.exploringbinary.com/ten-ways-to-check-if-an-integer-is-a-power-of-two-in-c/

//int isPowerOfTwo (unsigned int x)
//{
//    return ((x != 0) && !(x & (x - 1)));
//}

// 数学的方法

//int isPowerOfTwo (unsigned int x)
//{
//    while (((x % 2) == 0) && x > 1) /* While x is even and > 1 */
//        x /= 2;
//    return (x == 1);
//}

// 这里可以扩展到k，把3 换成k 就行了
//https://discuss.leetcode.com/topic/33536/a-summary-of-all-solutions-new-method-included-at-15-30pm-jan-8th
- (BOOL)isPowerOfThree:(NSInteger)n
{
    while (((n % 3) == 0) && n > 1) {
        n /= 3;
    }
    return n == 1;
}


//191. Number of 1 Bits
// TODO: 这个可以和上面的用同样的方法，统计1的个数

- (NSInteger)hammingWeight:(NSInteger)n
{
    NSInteger count = 0;
    NSInteger b = 0;
    while (n != 0) {
        b = n >> 1;
        if(n != b << 1){
            count++;
        }
        n = b;
    }
    return count;
}

#pragma mark - 224. Basic Calculator [H]

// Stack Math
// Hide Similar Problems (M) Evaluate Reverse Polish Notation (M) Basic Calculator II (M) Different Ways to Add Parentheses (H) Expression Add Operators

// 会不会有多位数
// 需要用stack，其实和 decode string

// 什么时候终止？
// 遇到不同字符串的处理，数字 ？ 符号  ）呢？
// 思路: 需要处理的有 1.数字有很多位  2.遇到 + - 设置 sign  3.“（” push stack， reset result 和sign  4.遇到“）” 就pop
// 技巧: 变量 sign 来标记 + 还是 -

//public static int calculate(String s) {
//    int len = s.length(), sign = 1, result = 0;
//    Stack<Integer> stack = new Stack<Integer>();
//    for (int i = 0; i < len; i++) {
//        if (Character.isDigit(s.charAt(i))) {
//            int sum = s.charAt(i) - '0';
//            while (i + 1 < len && Character.isDigit(s.charAt(i + 1))) {
//                sum = sum * 10 + s.charAt(i + 1) - '0';
//                i++;
//            }
//            result += sum * sign;
//        } else if (s.charAt(i) == '+')
//            sign = 1;
//        else if (s.charAt(i) == '-')
//            sign = -1;
//        else if (s.charAt(i) == '(') { // 说明计算还没有结束
//            stack.push(result);
//            stack.push(sign);
//            result = 0;
//            sign = 1;
//        } else if (s.charAt(i) == ')') { //本次计算结束LE
//            result = result * stack.pop() + stack.pop();
//        }
//        
//    }
//    return result;
//}

// FIXME: OBJC 版本没有写完

//- (NSInteger)calculate:(NSString *)str
//{
//    NSMutableArray<NSString *> *stack = [NSMutableArray array];
//    NSInteger sign = 1;
//    NSInteger result = 0;
//    
//    for (NSInteger i = 0; i < str.length; i++) {
//        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
//        if([ch isEqualToString:@" "]){
//            continue;
//        }
//        if([stack.lastObject isEqualToString:@"+"]) {
//            sign = 1;
//        } else if([stack.lastObject isEqualToString:@"-"]) {
//            sign = -1;
//        } else if([ch isEqualToString:@"("]) {
//            [stack addObject:@(result)];
//            [stack addObject:@(sign)];
//            result = 0;
//            sign = 1;
//        } else if([ch isEqualToString:@")"]) {
//            result = result * stack.lastObject.integerValue;
//            [stack removeLastObject];
//            result += stack.lastObject.integerValue;
//            [stack removeLastObject];
//        } else { // 数字
//            
//        }
//    }
//    return stack.lastObject.integerValue;
//}

//属于比较繁琐的问题，主要是耐心和细心

// https://discuss.leetcode.com/topic/30508/easiest-java-solution-with-graph-explanation/2

#pragma mark - Multiply Strings [R]

// 这个解决方法 需要很强的观察能力 可以用方法三

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
            
            product = res[i + j + 1].integerValue + mInt * nInt; // 这里的index关系是解题的关键
            res[i + j + 1] = @(product % 10);
            res[i + j] = @(res[i + j].integerValue + product / 10);
        }
    }
    NSMutableString *resStr = [@"" mutableCopy];
    for (NSInteger i = 0; i < [res count]; ++i)
    {
        //trime starting zeros
        if(!(resStr.length == 0 && res[i].integerValue == 0)) {//resStr.length == 0 的意思是一值还没有有效数字加入，skip 之
            [resStr appendString:[res[i] description]];
        }
    }
    return (resStr.length == 0) ? @"0" : [resStr copy];
}

//FIXME: 有问题, 这里更新了res[i+j+1] 之后也会溢出啊

- (NSString *)multiplyStr2:(NSString *)str1 andStr:(NSString *)str2
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
    
    for(NSInteger i = 0; i < m; i++) {
        NSInteger mInt = [str1 substringWithRange:NSMakeRange(m - 1 - i, 1)].integerValue;
        
        for(NSInteger j = 0; j < n; j++) {
            NSInteger nInt = [str2 substringWithRange:NSMakeRange(n - 1 - j, 1)].integerValue;
            
            product = res[i + j].integerValue + mInt * nInt; // 这里的index关系是解题的关键
            res[i + j] = @(product % 10);
            res[i + j + 1] = @(res[i + j + 1].integerValue + product / 10);
        }
    }
    NSMutableString *resStr = [@"" mutableCopy];
    for (NSInteger i = m + n - 1; i >= 0; i--)
    {
        //trime starting zeros
        if(!(resStr.length == 0 && res[i].integerValue == 0)) {//resStr.length == 0 的意思是一值还没有有效数字加入，skip 之
            [resStr appendString:[res[i] description]];
        }
    }
    return (resStr.length == 0) ? @"0" : [resStr copy];
}

// 还有一种解法也非常巧妙, 这是对的

- (NSString *)multiplyStr3:(NSString *)str1 andStr:(NSString *)str2
{
    if (str1.length == 0 || str2.length == 0)
    {
        return nil;
    }
    NSInteger m = str1.length;
    NSInteger n = str2.length;
    
    //step1: use array to store the result even 99 * 99 < 10000, so maximaly 4 digitis
    NSMutableArray<NSNumber *> *res = [NSMutableArray arrayWithCapacity: m + n];
    NSInteger i = m + n;
    while (i > 0) {
        [res addObject:@(0)];
        i--;
    }
    // 123
    // 789
    //   27
    //
    //step2: scane the array from right to left , beacuse the right is the lower digits
    //store the product mInt *nInt to res array
    
    for(NSInteger i = 0; i < m; i++) {
        NSInteger mInt = [str1 substringWithRange:NSMakeRange(m - 1 - i, 1)].integerValue;
        for(NSInteger j = 0; j < n; j++) {
            NSInteger nInt = [str2 substringWithRange:NSMakeRange(n - 1 - j, 1)].integerValue;
            NSInteger product = res[i + j].integerValue + mInt * nInt; // 这里的index关系是解题的关键
            res[i + j] = @(product);
        }
    }

    for (NSInteger i = 0; i < m + n; i++) {
        NSInteger carry = res[i].integerValue / 10;
        res[i] = @(res[i].integerValue % 10);
        if(i < m + n - 1){ // why ? 因为就越界了呀
            res[i + 1] = @(res[i + 1].integerValue + carry);
        }
    }
    
    NSMutableString *resStr = [@"" mutableCopy];
    for (NSInteger i = m + n - 1; i >= 0; i--)
    {
        //trime starting zeros
        if(!(resStr.length == 0 && res[i].integerValue == 0)) {//resStr.length == 0 的意思是一值还没有有效数字加入，skip 之
            [resStr appendString:[NSString stringWithFormat:@"%@",res[i]]];
        }
    }
    return (resStr.length == 0) ? @"0" : [resStr copy];
}

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

// 1. 关键是 carry, 还有头部清零
// 可能会出现 诸如 00 + 000 的case

// TODO: Fellow up  如果扩展到 base 为k 的情况怎么弄？
// 把 2 换成K 就可以了
// 保证性能是 用append, 在str 的尾部

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
        NSInteger p = (i >= 0) ? [str1 substringWithRange:NSMakeRange(i, 1)].integerValue : 0; //技巧, 因为这两个长度不等
        NSInteger q = (j >= 0) ? [str2 substringWithRange:NSMakeRange(j, 1)].integerValue : 0;
        
        NSInteger digit = (p + q + carry) % 2;
        carry = (p + q + carry) / 2;
        [sum appendString:[NSString stringWithFormat:@"%ld", (long)digit]];
        i--;
        j--;
    }
    
    //这里可以check 下 是否对00 这样的输出结果，直接输出还是trim the zero,
    NSMutableString *reversed = [NSMutableString string];
    for (NSInteger i = sum.length - 1; i >= 0; i--) {
        NSString *ch = [sum substringWithRange:NSMakeRange(i, 1)];
        if (!(reversed.length == 0 && [ch isEqualToString:@"0"])) {
            [reversed appendString:ch];
        }
    }
    
    return [reversed length] == 0 ? @"0" : [reversed copy]; //这个也很关键
}

// 66 plus one

// 思路: 我想到的办法 就是用一个carrry 然后从enumberate the arrayt in reverse order and push it back, 然后再和10 想除, 这是zhong 比较通用的办法， 但是没有针对1 优化
// 下面这个办法很酷， 遇到9 直接返回
//void plusone(vector<int> &digits)
//{
//    int n = digits.size();
//    for (int i = n - 1; i >= 0; --i)
//    {
//        if (digits[i] == 9)
//        {
//            digits[i] = 0;
//        }
//        else
//        {
//            digits[i]++;
//            return;
//        }
//    }
//    digits[0] =1;
//    digits.push_back(0);
//    
//}

//- (NSArray *)plusone:(NSArray *)nums
//{
//
//}

// 69. Sqrt(x)
//思路: 可以用二分法

//65. Valid Number [H]
//Difficulty: Hard

//Validate if a given string is numeric.
//
//Some examples:
//"0" => true
//" 0.1 " => true
//"abc" => false
//"1 a" => false
//"2e10" => true
//Note: It is intended for the problem statement to be ambiguous. You should gather all requirements up front before implementing one.

// https://discuss.leetcode.com/topic/9490/clear-java-solution-with-ifs/2

//- (BOOL)validNumber:(NSString *)str
//{
//
//}

- (double)power:(NSInteger)n k:(NSInteger)k
{
    if(n < 0){
        return 1.0 / [self _power:-n k:k];
    } else {
        return [self power:n k:k];
    }
}

- (double)_power:(NSInteger)n k:(NSInteger)k
{
    if(n == 0){
        return 1;
    }
    double v = [self _power:n / 2 k:k];
    if(n % 2 == 0){
        return v * v;
    } else {
        return v * v * k;
    }
}

@end
