//
//  LRU.h
//  LCOBJC
//
//  Created by andy on 23/12/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRU : NSObject

- (instancetype)initWithCapacity:(NSInteger)capacity;
- (NSNumber *)getValue:(NSNumber *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

@end

