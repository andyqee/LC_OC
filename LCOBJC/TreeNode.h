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
