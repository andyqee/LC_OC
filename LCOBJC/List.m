//
//  List.m
//  LCOBJC
//
//  Created by andy on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "List.h"

@implementation List

- (void)reorderList:(ListNode *)head
{
    //找到中间的 然后对right 半部分的add 到stack 中，遍历到最后，然后pop 出来
    if(!head || !head.next){
        return;
    }
    // step 1 find mid node of linkedlist
    ListNode *midNode = [self findMidle:head];
    // step 2 reverse right half list 
    ListNode *reversedList = [self reverseList:midNode.next]; //传入的是mid 后面那个

    [self mergeList:head rightHalf:reversedList];
}

- (ListNode *)findMidle:(ListNode *)head
{
    ListNode *slow = head;
    ListNode *fast = head.next; //初始化的时候 fast 是 next 当只有一个点的时候，返回的是自身，这里fast 设置为head.next就是为了跳过while 检测
    while(fast && fast.next){ //判断的时候 添加fast.next
        fast = fast.next.next;
        slow = slow.next;
    }
    return slow;
}

- (ListNode *)reverseList:(ListNode *)head
{
    ListNode *newHead;
    while(head){
        ListNode *temp = head.next;//change it. 因为要更新，所以先保存
        head.next = newHead;
        newHead = head;
        head = temp;
    }
    return newHead;
}

//如果是偶数个的话 left half 的最后一个 和right half 的最后一个是相同的
// case: 1-2-3-4
// case; 1-2-3

- (void)mergeList:(ListNode *)left rightHalf:(ListNode *)right
{
    while(right && right.next){
        ListNode *temp = right; //保存 插入的列表的 头
        right = right.next; // 
        temp.next = left.next;
        left.next = temp;
        left = left.next.next;
    }
}

// dived and conquer heap 
// 有点合并排序的感觉
// solution A: K > 1
// solution A: 使用priority queue. 但是OC 没有priority queue 不太好实现

// http://bangbingsyb.blogspot.jp/2014/11/leetcode-merge-k-sorted-lists.html
// http://www.jiuzhang.com/solutions/merge-k-sorted-lists/

- (ListNode *)mergeKList:(NSArray<ListNode *> *)listNodeArray
{
    if([listNodeArray count] == 0){
        return nil;
    }
    //return [self mergeList_recurisive:listNodeArray left:0 right:listNodeArray.count - 1];
    return [self mergeList_I:[listNodeArray mutableCopy]];
}

//和合并排序有点像
//space O(k) T = O(nkLogK)

- (ListNode *)mergeList_recurisive:(NSArray<ListNode *> *)listNodeArray left:(NSInteger)left right:(NSInteger)right
{
    if(left == right){
        return listNodeArray[left];
    }

    NSInteger mid = (right - left) / 2 + left;
    
    ListNode *mergeNode1 = [self mergeList_recurisive:listNodeArray left:left right:mid];
    ListNode *mergeNode2 = [self mergeList_recurisive:listNodeArray left:mid+1 right:right];
    return [self mergeList:mergeNode1 withList:mergeNode2];// T(k) = 2 * T(k/2) + 2n * k/2  = nk log(k)
}

- (ListNode *)mergeList_I:(NSMutableArray<ListNode *> *)listNodeArray
{
    NSInteger left = 0;
    NSInteger right = listNodeArray.count - 1;
    while(right > 0){
        left = 0;
        while(left < right) {
            listNodeArray[left] = [self mergeList:listNodeArray[left] withList:listNodeArray[right]];
            left++;
            right--;
        }
    }
    return [listNodeArray firstObject];
}

//merge sorted array

- (ListNode *)mergeList:(ListNode *)node1 withList:(ListNode *)node2
{
    ListNode *newHead = nil;
    ListNode *tail = [ListNode new];

    while(node1 && node2){
        if(node1.val < node2.val){
            tail.next = node1;
            node1 = node1.next;
        } else if(node1.val >= node2.val){
            tail.next = node2;
            node2 = node2.next;
        }
        if(!newHead){
            newHead = tail.next;
        }
        tail = tail.next;
    }
    tail.next = node1 ?: node2;

    return newHead;
}

//without using extra space
// case node nil， 单点 链表 双点
// 这种方式，如果链表 是偶数个的，其返回的是第一个的点

- (BOOL)hasCycle:(ListNode *)node
{
    ListNode *slow = node;
    ListNode *fast = node.next;
    
    while(fast && fast.next){
        if(fast == slow){
            return YES;
        }
        fast = fast.next.next;
        slow = slow.next;
    }
    return NO;
}
//

- (ListNode *)detectNode:(ListNode *)node
{
    ListNode *slow = node;
    ListNode *fast = node.next;
    ListNode *entry = node;
    
    while(fast && fast.next){
        fast = fast.next.next;
        slow = slow.next;
        
        while(entry != slow){
            entry = entry.next;
            slow = slow.next;
        }
        return entry;
    }
    return nil;
}

// 删除重复节点. 两种方法，这里面竟然可以递归

- (ListNode *)deleteDuplicates:(ListNode *)listNode
{
    ListNode *curr = listNode;
    while (curr && curr.next) {
        if(curr.val == curr.next.val){
            curr.next = curr.next.next;
        } else {
            curr = curr.next;
        }
    }
    return curr;
}

- (ListNode *)deleteDuplicates_r:(ListNode *)listNode
{
    if(listNode == nil || listNode.next == nil){
        return listNode;
    }
    listNode.next = [self deleteDuplicates_r:listNode.next];
    return (listNode.val == listNode.next.val) ? listNode.next : listNode;
}

//方法1: Hash Map
// loop 1. copy all the nodes
// loop 2. assign next and random pointers 

- (RandomListNode *)copyRandomList:(RandomListNode *)head
{
    if(head == nil){
        return nil;
    }
    NSMutableDictionary<RandomListNode *, RandomListNode *> *dic = [NSMutableDictionary dictionary];
    RandomListNode *p = head;
    while(p){
        RandomListNode *node = [RandomListNode new];
        node.label = p.label;
        dic[p] = node;
        p = p.next;
    }

    p = head;
    while(p != nil){
        dic[p].next = dic[p.next];
        dic[p].random = dic[p.random];
        p = p.next;
    }
    return dic[head];
}

- (RandomListNode *)copyRandomLis_ondic:(RandomListNode *)head
{
    if(head == nil) {
        return nil;
    }
    [self copyNext:head];
    [self copyRandom:head];
    return [self splitList:head];
}

// assign random pointer for the copy nodes

- (void)copyRandom:(RandomListNode *)head
{
    RandomListNode *p = head;
    while(p){
        if(p.next.random){
            p.next.random = p.random.next;
        }
        head = p.next.next;
    }
}

// make copy of each node
- (void)copyNext:(RandomListNode *)head
{
    RandomListNode *p = head;
    RandomListNode *next = head;

    while(p){
        next = p.next;
        RandomListNode *node = [RandomListNode new];
        p.next = node;
        node.next = next;
        p = next;
    }
}

- (RandomListNode *)splitList:(RandomListNode *)head
{
    RandomListNode *p = head;
    RandomListNode *cloneHead = p.next;
// 1   ->   1'   ->   2   ->   2'
// p     cloneI

    while (p) {
        RandomListNode *cloneIter = p.next;
        p.next = p.next.next;
        cloneIter.next = p.next.next; // may be nil 最后一个是nil
        p = p.next;
    }
    
    return cloneHead;
}

@end
