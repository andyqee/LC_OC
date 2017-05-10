//
//  List.m
//  LCOBJC
//
//  Created by andy on 14/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "List.h"
#import "TreeNode.h"

@implementation List

- (void)reorderList:(ListNode *)head
{
    //找到中间的 然后对right 半部分的add 到stack 中，遍历到最后，然后pop 出来
    if(!head || !head.next){
        return;
    }
    // step 1 find mid node of linkedlist
    ListNode *midNode = [self findMidle:head];
    // step 2 reverse right half list // 1--> 2 --> 3--->4
    ListNode *reversedList = [self reverseList:midNode.next]; //传入的是mid 后面那个， 也就是3， 因为mid是2的那个node

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

// 1--> 2 --> 3--->4
// 简单容易出错的题目
// 以其中的普通点作为切入点

- (ListNode *)reverseList:(ListNode *)head
{
    ListNode *prev = nil;
    while(head){ // 1.循环是框架
        ListNode *temp = head.next;//2.change it. 因为要更新，所以先保存
        head.next = prev;
        prev = head;// track 前面那个, 这里需要newHead，记录head 前面那个，因为while结束之后，就head 就为nil 了
        head = temp;// 4. 移动到一下步奏
    }
    return prev;
}

- (ListNode *)reverseListReverse:(ListNode *)head
{
    return [self reverseList:head prevHead:nil];
}

//需要使用两个node，传递下去

- (ListNode *)reverseList:(ListNode *)head prevHead:(ListNode *)prevHead
{
    if(head == nil){//TODO: 注意recursive 的break 条件
        return prevHead;
    }
    ListNode *next = head.next;//保存要被更新的那个
    head.next = prevHead;
    return [self reverseList:next prevHead:head];
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

// divide and conquer heap
// 有点合并排序的感觉
// solution A: K > 1
// solution A: 使用priority queue. 但是OC 没有priority queue 不太好实现

// http://bangbingsyb.blogspot.jp/2014/11/leetcode-merge-k-sorted-lists.html
// http://www.jiuzhang.com/solutions/merge-k-sorted-lists/

- (ListNode *)mergeKList_PQ:(NSArray<ListNode *> *)listNodeArray
{
    if([listNodeArray count]){
        return nil;
    }
    
    PriorityQueue *pq = [PriorityQueue new];
    for (ListNode *node in listNodeArray) { // length
        [pq addObject:node];
    }
    ListNode *dummy = [ListNode new];
    ListNode *head = dummy;
    
    while (pq.count) { // log(length) * number of node
        head.next = [pq poll];
        head = head.next;
        
        if(head.next){
            [pq addObject:head.next];
        }
    }
    return dummy.next;
}

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
    ListNode *mergeNode2 = [self mergeList_recurisive:listNodeArray left:mid + 1 right:right];
    return [self mergeList:mergeNode1 withList:mergeNode2];// T(k) = 2 * T(k/2) + 2n * k/2  = nk log(k)
}

// merge two by two

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
// 技巧：构建一个tail 指针用来track 前面那个拍好序的tail 结点，然后把 当前比较得到的小的node，和前面那个拼接起来

- (ListNode *)mergeList:(ListNode *)node1 withList:(ListNode *)node2
{
    ListNode *dummy = [ListNode new];
    ListNode *tail = dummy;

    while(node1 && node2){
        if(node1.val < node2.val){
            tail.next = node1;
            node1 = node1.next;// move the small forward
        } else if(node1.val >= node2.val){
            tail.next = node2;
            node2 = node2.next;
        }
        tail = tail.next; //这里避免在上面两个if 分支写两遍的情况
    }
    tail.next = node1 ?: node2;//这里也非常关键，要不然就会剩下没有拼接的部分了。
    return dummy.next;
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
    
    while(fast != slow){
        if(fast == nil || fast.next ==  nil){
            return nil;
        }
        fast = fast.next.next;
        slow = slow.next;
        
    }
    
    while(entry != slow){
        entry = entry.next;
        slow = slow.next;
    }
    return entry;
}

// 删除重复节点. 两种方法，这里面竟然可以递归
// 如何返回删除后的头结点呢？

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
    return listNode;
}

// 递归版本

- (ListNode *)deleteDuplicates_r:(ListNode *)listNode
{
    if(listNode == nil || listNode.next == nil){
        return listNode;
    }
    listNode.next = [self deleteDuplicates_r:listNode.next];
    return (listNode.val == listNode.next.val) ? listNode.next : listNode;
}

//方法1: Hash Map
// loop 1. copy all the nodes ，1.先创建
// loop 2. assign next and random pointers 2. 然后再进行关系assgin value

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

// First round: make copy of each node,
// and link them together side-by-side in a single list.
// step 1: 1   ->   1'   ->   2   ->   2' 插入clone node
// Create the copy of node 1 and insert it between node 1 & node 2 in original Linked List, create the copy of 2 and insert it between 2 & 3.. Continue in this fashion, add the copy of N afte the Nth node

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

// assign random pointer for the copy nodes

// original->next->arbitrary = original->arbitrary->next;

- (void)copyRandom:(RandomListNode *)head
{
    RandomListNode *p = head;
    while(p){
        if(p.random){
            p.next.random = p.random.next;
        }
        head = p.next.next;
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

#pragma mark - Two pointers

//- (ListNode *)removeNthFromEnd:(ListNode *)head n:(NSInteger)n
//{
//    
//}

@end
