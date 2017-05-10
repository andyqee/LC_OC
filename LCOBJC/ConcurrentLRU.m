// //
// //  ConcurrentLRU.m
// //  LCOBJC
// //
// //  Created by ethon_qi on 25/1/2017.
// //  Copyright © 2017 andy. All rights reserved.
// //

// #import "ConcurrentLRU.h"

// @interface ConcurrentLRUNode : NSObject
// @property (nonatomic, strong) ConcurrentLRU *prevNode;
// @property (nonatomic, strong) ConcurrentLRU *nextNode;
// @property (nonatomic, strong) NSNumber *value; //store the key of hash table

// @end

// @implementation ConcurrentLRUNode

// @end

// @interface ConcurrentLRU()
// @property (nonatomic) NSInteger capacity;
// @property (atomic, strong) NSMutableDictionary<NSNumber *, ConcurrentLRU *> *dic;//记录 key - value 这里是LRUNode
// @property (atomic, strong) ConcurrentLRU *head;//记录 key - value
// @property (atomic, strong) ConcurrentLRU *tail;//记录 key - value
// //需要双向链表 linked list track 更新顺序
// //如果达到capacity 需要清理超过capacity 后面的node,这里就需要一个tail node

// @property (nonatomic, strong) dispatch_queue_t queue;

// @end

// @implementation ConcurrentLRU

// - (instancetype)initWithCapacity:(NSInteger)capacity
// {
//     if (self = [super init]) {
//         _capacity = capacity;
//         _dic = [NSMutableDictionary dictionaryWithCapacity:capacity];
        
//         _head = [ConcurrentLRU new];
//         _tail = [ConcurrentLRU new];
//         _head.nextNode = _tail;
//         _tail.prevNode = _head;
        
//         _queue = dispatch_queue_create("com.fbi.lru", DISPATCH_QUEUE_CONCURRENT);
//     }
//     return self;
// }

// //update least recent used

// - (NSNumber *)getValue:(NSNumber *)key
// {
//     ConcurrentLRU *node = _dic[key];
//     if (!node) {
//         return @(NSNotFound);
//     }
//     //更新在list中的位置, 这里在存储的时候，是直接存放的 LURNode 对象，这样就不用traversal 这个list 了
//     [self _removeNode:node];
//     [self _moveToHead:node];
//     return node.value;
// }

// - (void)setObject:(id)value forKey:(NSNumber *)key
// {
//     // 这里可以优化下,先调用get 方法如果找到就直接return 不用走下面的操作
//     if(![[self getValue:key] isEqualToNumber:@(NSNotFound)]){
//         _dic[key] = value;
//         return;
//     }
//     // 如果上面没有找到,就走下面.
//     if ([_dic count] == _capacity) {
//         [_dic removeObjectForKey:_tail.prevNode.value];
//         _tail.prevNode = _tail.prevNode.prevNode;
//         _tail.prevNode.nextNode = _tail;
//     }
    
//     LRUNode *node = [LRUNode new];
//     [self _moveToHead:node];
//     _dic[key] = node;
//     node.value = value;
// }

// - (void)_removeNode:(ConcurrentLRU *)node
// {
//     node.prevNode.nextNode = node.nextNode;
//     node.nextNode.prevNode = node.prevNode;
//     //optinal set nil
//     node.prevNode = nil;
//     node.nextNode = nil;
// }

// // head next 指向真正的list 里面的第一个,如果head 直接指向第一个呢？ 也可以啊

// - (void)_moveToHead:(ConcurrentLRU *)node
// {
//     self.head.nextNode.prevNode = node;
//     node.nextNode = self.head.nextNode;
//     self.head.nextNode = node;
//     node.prevNode = self.head;
// }

// @end


