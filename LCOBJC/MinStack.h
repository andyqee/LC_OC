//
//  MinStack.h
//  LCOBJC
//
//  Created by ethon_qi on 25/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinStack : NSObject

- (NSNumber *)top;
- (NSNumber *)min;
- (void)pop;
- (void)push:(NSNumber *)num;

@end
