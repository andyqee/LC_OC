//
//  CircularBuffer.m
//  LCOBJC
//
//  Created by ethon_qi on 14/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import "CircularBuffer.h"

@interface CircularBuffer()
@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, assign) NSInteger tail;
@property (nonatomic, assign) NSInteger head;

@property (nonatomic, strong) NSMutableArray *container;

@end

@implementation CircularBuffer

- (instancetype)initWithCapacity:(NSInteger)n
{
    NSAssert(n >= 1, @"capacity should not less than 1");
    if(self = [super init]){
        _capacity = n;
        _container = [NSMutableArray arrayWithCapacity:n];
        for (NSInteger i = 0; i < n; i++) {
            [_container addObject:@0]; //
        }
        //
        _tail = 0; // track read, 用来track最后当前读的位置
        _head = 0; // track produce 用来track当前写的位置
    }
    return self;
}

- (void)produce:(NSObject *)e
{
    NSAssert(e, @"should not be nil");
    
    _head = (_head + 1) % _capacity;
    if(_head == _tail){
        @throw [NSException exceptionWithName:@"Over flow expcetion" reason:@"Buffer overflow exception" userInfo:nil];
    }
    [_container insertObject:e atIndex:_head];
}

- (NSObject *)comsume
{
    if(_head == _tail){
        @throw [NSException exceptionWithName:@"underflow expcetion" reason:@"Buffer underflow exception" userInfo:nil];
    }
    NSObject *e = [_container objectAtIndex:_tail];
    _tail = (_tail + 1) % _capacity;
    
    return e;
}

@end


//思路: 1 max heap for small half
//     2. min heap for large half
//     3. if the diff of size of the two heap is large than 1, pop the top node ,and insert it back to the small heap

// Red & black tree ? self balance ?, 应该更佳合适

// 295. Find Median from Data Stream
@implementation addAndSearchMedian

//- (void)addNumber:(NSNumber*)number
//{
//
//}
//
//- (NSNumber*)median
//{
//
//}


@end
