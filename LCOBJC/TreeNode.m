//
//  TreeNode.m
//  LCOBJC
//
//  Created by andy on 30/10/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

@end

@implementation ListNode

@end

@implementation NestedListNode

@end

@implementation RandomListNode

@end

@implementation Interval

@end


@implementation UndirectedGraphNode

@end

@implementation DoublyLinkedListNode

@end

@implementation SegmentTreeNode

@end

@interface PriorityQueue()
// array 是index = 1 开始，index = 0 这个位置不用,存占位
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation PriorityQueue

- (NSMutableArray *)array
{
    if(!_array){
        _array = [NSMutableArray array];
        [_array addObject:@(NSNotFound)];// 暂居位置
    }
    return _array;
}

- (void)addObject:(id<QYCompareable>)object
{
    [_array addObject:object];
    [self _swimup];
}

- (id<QYCompareable>)poll
{
    if(_array.count <= 1){
        @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    }
    
    id<QYCompareable> res = _array[1];
    _array[1] = [_array lastObject];
    [_array removeLastObject];
    [self _sink];
    
    return res;
}

- (NSInteger)count
{
    return _array.count - 1;
}

- (void)_swimup
{
    NSInteger k = _array.count;
    while(k > 1 && [_array[k] compare: _array[k / 2]] == NSOrderedDescending){
        [_array exchangeObjectAtIndex:k withObjectAtIndex:k / 2];
        k = k / 2;
    }
}

- (void)_sink
{
    NSInteger j = 1;
    while (2 * j <= _array.count) {
        NSInteger k = 2 *j;
        if(j < _array.count && [_array[j] compare:_array[j + 1]] == NSOrderedAscending){
            j++;
        }
        if([_array[k] compare:_array[j + 1]] != NSOrderedDescending) // 不小于
            break;
        [_array exchangeObjectAtIndex:j withObjectAtIndex:k];
        j = k;
    }
}

@end

@implementation PriorityNode

@end
