//
//  TreeNode.h
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode : NSObject

@property (nonatomic, strong) TreeNode *left;
@property (nonatomic, strong) TreeNode *right;
@property (nonatomic, assign) NSInteger val;

@end

@interface ListNode : NSObject
@property (nonatomic, assign) NSInteger val;
@property (nonatomic, strong) ListNode *next;

@end

@interface Interval : NSObject
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger end;

@end

@interface TreeLinkNode : NSObject

@property (nonatomic, strong) TreeLinkNode *left;
@property (nonatomic, strong) TreeLinkNode *right;
@property (nonatomic, strong) TreeLinkNode *next;

@property (nonatomic, assign) NSInteger val;

@end

@interface RandomListNode : NSObject<NSCopying>
@property (nonatomic, strong) RandomListNode *random;
@property (nonatomic, strong) RandomListNode *next;

@property (nonatomic, assign) NSInteger label;

@end


@interface UndirectedGraphNode : NSObject<NSCopying>
@property (nonatomic, strong) NSMutableArray<UndirectedGraphNode *> *neighbors;
@property (nonatomic, assign) NSInteger label;

- (instancetype)initWithLabel:(NSInteger)label;

@end

//Doubly Linked List

@interface DoublyLinkedListNode : NSObject
@property (nonatomic, assign) NSInteger val;
@property (nonatomic, strong) DoublyLinkedListNode *next;
@property (nonatomic, strong) DoublyLinkedListNode *prev;

@end
