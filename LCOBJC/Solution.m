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
- (NSUInteger)fbi_hash;

@end

@implementation Solution (String)

- (void)testFuntionRef:(TreeNode *)tree
{
    TreeNode *l = [TreeNode new];
    l.val = 10000;
    
    tree.left = l;
}

- (void)testFuntionReff:(TreeNode **)tree
{
    *tree = [TreeNode new];
    (*tree).val = 10000;
    (*tree).right = [TreeNode new];
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

#pragma mark - Read N Characters Given Read4

// 返回真实的读取的字符，read data from file and store it in buffer
// 思路: while 利用len 标记真实读入的长度，当len < count 或者 endOfFile 还没有结束就一直循环
// 当最终len > count 的时候 就把超出的部分 截断。

// mock read4
- (NSInteger)read4:(NSMutableString *)str
{
    [str appendString:@"1234"];
    return 4;
}

- (NSInteger)readFromString:(NSMutableString *)buffer count:(NSInteger)count
{
    NSInteger len = 0;
    BOOL endOfFile = NO;
    while(len < count || !endOfFile){
        NSInteger num = [self read4:buffer];
        len += num;
        if(num < 4){
            endOfFile = YES;
        }
    }
    while(len > count){
        [buffer deleteCharactersInRange:NSMakeRange(count, len - count)];
    }
    return buffer.length;
}

#pragma mark - Simplify Path

//各种corner case
// TODO: 关键: 1. 是处理 .. 需要pop
//      2.skip 掉 “.” and "/"

- (NSString *)simplifyPath:(NSString *)path
{
    if ([path length] == 0) {
        return nil;
    }
    
    NSArray<NSString *> *paths = [path componentsSeparatedByString:@"/"];
    NSMutableArray *res = [NSMutableArray array];
    
    for(NSString *p in paths){
        if([p isEqualToString:@"."] || [p isEqualToString:@""]){
            continue;
        }
        if([p isEqualToString:@".."]){
            if([res count] > 0){
                [res removeLastObject];
            }
        } else {
            [res addObject:p];
        }
    }
    NSString *sp = [res componentsJoinedByString:@"/"]; //"res 是空数组，这里是返回nil
    return sp.length == 0 ? @"/" : [NSString stringWithFormat:@"/%@",sp]; //这里如果sp 是nil，显示的时候可能是null
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

// 这道题目的挑战在于 inplace

// 如果有一个字母咋办

// 方法就是1. reverse the string
//        2.  reverse word

// FIXME: Fucking boring shit

// @" " 是否返回 @“”

- (NSString *)reverseWordsNotInplace:(NSMutableString *)str
{
    if ([str length] == 0) {
        return nil;
    }
    //step 1
    [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableString *mStr = [NSMutableString string];
    NSArray<NSString *> *strs = [str componentsSeparatedByString:@" "];
    
    for (NSString *s in [[strs reverseObjectEnumerator] allObjects]) {
        if(![s isEqualToString:@""]){
            [mStr appendString:s];
            [mStr appendString:@" "];//这里不能忘记！
        }
    }
    [mStr deleteCharactersInRange:NSMakeRange(mStr.length - 1, 1)]; //remove the last str
    return [mStr copy];
}

// Given s = "the sky is blue",
// return "blue is sky the".

//- (void)reverseWords:(NSMutableString *)str
//{
//    if ([str length] == 0) {
//        return;
//    }
//    //step 1
//    
//}

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

// 思路: google 非fb

// 2[abc]3[cd]ef
// count = 2 numStack strStack

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
        if(sub.integerValue != 0) { // step1: 如果为数字，解析数字
            count = count * 10 + sub.integerValue;
        } else if ([sub isEqual:@"["]) { //step 2: 后面还有需要处理的，所以将数字入stack， 并且将之前拼接好的入stack,create 之后重新设置 currStr ,reset cout
            [numStack addObject:@(count)];
            [strStack addObject:[currStr copy]];
            currStr = [NSMutableString string];
            count = 0;
        } else if ([sub isEqual:@"]"]) { //step 3: 拼接repeat 的字符, 括号作用于结束，pop the previous state
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
// TODO: FB follow up

#pragma mark - decode way prefer way

//九章的解法，更简洁,巧妙些
// DP
// corner case : 字符串为空，第一个字符是0
// general case : 分别判断oneDigit 和 twoDigit
// 初始化为1 , idx start from 2
// Fellow up : 如果不用dp 怎么做？ dived - conquer ?

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

- (NSInteger)numDecodingsMethod3:(NSString *)str
{
    if ([str length] == 0) {
        return 0;
    }
    // invalid case
    NSString *ch = [str substringWithRange:NSMakeRange(0, 1)];
    if([ch isEqualToString:@"0"]){
        return 0;
    }
    NSInteger cur = 1;  //
    NSInteger prev = 1; // base case 1
    
    for (NSInteger i = 2; i <= str.length; i++) {
        NSString *oneDigit = [str substringWithRange:NSMakeRange(i - 1, 1)];
        cur = oneDigit.integerValue != 0 ? cur : 0; //如果不为数字字符，这里应该是0
        
        NSString *twoDigit = [str substringWithRange:NSMakeRange(i - 2, 2)];
        if (twoDigit.integerValue >= 10 && twoDigit.integerValue <= 26) {
            cur = cur + prev;
        }
        prev = cur;
    }
    return cur;
}

// all the result

- (void)decodeway:(NSString *)str
{

}

//method1: backtracking

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
// 注意: 这里拼接的shi count + char

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
        NSString *key = [str sorted];// 如果不排序,可以用prime计算hash, 用计算后的 hash 值作为key
        if(dic[key]) {
            [dic[key] addObject:str];
        } else {
            dic[key] = [@[str] mutableCopy];
        }
    }
    return [dic allValues];
}

- (NSArray<NSArray<NSString *> *> *)groupAnagramsHash:(NSArray<NSString *> *)strs
{
    if(strs == nil) {
        return nil;
    }
    if([strs count] <= 1) {
        return @[strs];
    }
    
    NSMutableDictionary<NSNumber *, NSMutableArray *> *dic = [NSMutableDictionary dictionary];
    for(NSString *str in strs) {
        NSNumber *key = @([str fbi_hash]);// 如果不排序,可以用prime计算hash, 用计算后的 hash 值作为key
        if(dic[key]) {
            [dic[key] addObject:str];
        } else {
            dic[key] = [@[str] mutableCopy];
        }
    }
    return [dic allValues];
}

// 这个题目还要再写一遍

#pragma mark -  273. Integer to English Words [H][R] 需要背
// 技巧性比较强
// 思路: 对英文进行分类 1. <= 20 2. Tens 。3.THOUSANDS
// 如何巧妙的进行状态的转移呢
// 在分析讲解的时候，根据不同的范围进行分析

// analisis : 1. we can analysis the problem start from the number which is small than 1000, we build a helper function to parse it .
//                 and in detial , handle serversal cases for number < 20 , < 100  > 100
//            2. for number large than 1000 we can divide by 1000 and we get the mode which is the lowest 3 digits. and we can handle the model with previous help funtion
//            3. for the we update num = num / 1000 to , and we keep this process iteratively. Here we need to use a count to indicate weather is K 还百万
//
//  注意这个是 先处理最低的三位，然后处理剩下的，每次都是把 值插在最前面

- (NSString *)numberToWords:(NSInteger)num
{
    NSArray *THOUSANDS = @[@"", @"Thousand", @"Million", @"Billion"];// 这里的0占位也狠巧妙

    if(num == 0){
        return @"Zero";
    }
    NSMutableString *str = [NSMutableString string];

    NSInteger i = 0;
    while(num != 0){ // 这个循环对 num 以 1000 为背数 进行 降低
        if(num % 1000 != 0){ // 不处理 000 个零结尾的
            NSString *temp = [self helper:num % 1000];
            [str insertString:[NSString stringWithFormat:@"%@ %@", temp, THOUSANDS[i]] atIndex:0];
        }
        num /= 1000;
        i++;
    }
    return str;
}

// 构建一个helper 来处理1000 一下的

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
    } else { //对100 以上的进行特殊递归处理 逻辑和 上面对 1000 的处理有些类似
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
    
    NSInteger steps = 2;
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
// DFS 试试用回溯方法，那么上面的办法不行了。

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

//MJ Remove Comments

/**
 
*/

// what is the type of input parameter, can we assume it's a nsstring instance with UTF-8 encoding?

- (NSString *)removeComments:(NSString *)token
{
    if(token.length == 0){
        return token;
    }
    
    NSMutableString *str = [NSMutableString string];
    __block BOOL isComment = NO;
    
    [token enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        NSString *trimedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([trimedLine hasPrefix:@"/*"]){
            isComment = YES;
        }
        if(!isComment || ![trimedLine hasPrefix:@"//"]){
            [str appendString:line];
        }
        
        if([line hasPrefix:@"*/"]){
            isComment = NO;
        }
    }];
    return [str copy];
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

- (NSUInteger)fbi_hash
{
    NSUInteger hash = [@"" hash];
    for (int i = 0; i < self.length; ++i) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        hash = hash ^ [charStr hash];
    }
    return hash;
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

@interface NSMutableString (FBI)

- (void)reverseWithRange:(NSRange *)range;

@end

@implementation NSMutableString (FBI)

- (void)reverseWithRange:(NSRange *)range
{

}

@end

