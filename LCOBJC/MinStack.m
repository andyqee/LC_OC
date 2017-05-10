//
//  MinStack.m
//  LCOBJC
//
//  Created by ethon_qi on 25/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import "MinStack.h"

// Every time I push the new min, I push the old min first (....,oldmin,newmin)
// Every time I pop, I check if the value is min
// If it is min, I pop twice and update min

@interface MinStack()
@property (nonatomic, strong) NSMutableArray<NSNumber *> *stack;
@property (nonatomic, assign) NSInteger minValue;

@end

@implementation MinStack

- (instancetype)init
{
    if(self = [super init]){
        _stack = [NSMutableArray array];
        _minValue = NSIntegerMax;
    }
    return self;
}

- (NSNumber *)top
{
    if(_stack.count == 0){
        @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    }
    return _stack.lastObject;
}

- (NSNumber *)min
{
    if(_stack.count == 0){
        @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    }
    return @(_minValue);
}

- (void)pop
{
    if(_stack.count == 0){
        @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    }
    
    NSInteger val = _stack.lastObject.integerValue;
    [_stack removeLastObject];
    
    if(val == _minValue){
        _minValue = _stack.lastObject.integerValue;
        [_stack removeLastObject];
    }
}

- (void)push:(NSNumber *)num
{
    if(num.integerValue < _minValue){
        [_stack addObject:@(_minValue)]; //save the min Value
        _minValue = num.integerValue;
    }
    [_stack addObject:num];
}

@end
