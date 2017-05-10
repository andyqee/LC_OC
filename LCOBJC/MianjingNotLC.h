//
//  MianjingNotLC.h
//  LCOBJC
//
//  Created by ethon_qi on 23/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MianjingNotLC : NSObject

//1.非原题，但不是太难。给一个linkedlist，里面的element都排序好了，但是是一个blackbox，有三个function可以调用。pop()随机pop出最前面或最后面的element，peek()随机偷看最前面或最后面的element，isEmpty()回传linkedlist是不是空了。问设计一个资料结构，list或是array都可以，把linkedlist里面所有的element都拿出来，并保持他们的排序。followup是如果不能用peek()该怎么做。


//就是在象棋棋盘上给你两个点A，B，问一个Knight(大哥说，就是骑马那个哈)最少要几步从A跳到B。露珠从来没玩过国际象棋，于 是问Knight咋走。Turns out只要走任意朝向的L形就好。具体来说，如coordinate是(x,y) 那么在这里的一只knight可以跳到八个position中任何一个: (x- 2,y-1); (x-2,y+1);(x+2,y-1);(x+2,y+1);(x-1,y+2);(x-1,y-2);(x+1,y-2);(x+1,y+2).

// 感觉可以用动态规划

- (NSInteger)minSteps:(NSArray<NSArray *> *)matrix;

// function get_friends(A) 能得到A的所有朋友，求get_friends_of_friends(A)
// 需要去除本身是自己好友的人以及自己

// 口头跑程序，run了好多个case，一开始我把所有和A有关系的“朋友”都找出来了，后来面试官提示只要找A的朋友的朋友（2层）并且找到的不能含A的朋友。就是一个图的搜索，并记录图的深度degree......

// 思路: 两种解决方法 bucket sort, quick select

@end
