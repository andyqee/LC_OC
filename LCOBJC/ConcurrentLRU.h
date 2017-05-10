//
//  ConcurrentLRU.h
//  LCOBJC
//
//  Created by ethon_qi on 25/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConcurrentLRU : NSObject

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (NSNumber *)getValue:(NSNumber *)key;

- (void)setObject:(id)value forKey:(NSString *)key;

- (void)clearAllObjects;

@end
