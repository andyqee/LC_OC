//
//  CircularBuffer.h
//  LCOBJC
//
//  Created by ethon_qi on 14/1/2017.
//  Copyright © 2017 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircularBuffer : NSObject

- (instancetype)initWithCapacity:(NSInteger)n;

- (void)produce:(NSObject *)e;

- (NSObject *)comsume;

@end

//Create the data structure for a component that will receive a series of numbers over the time and, when asked, returns the median of all received elements.
//
//(Median: the numerical value separating the higher half of a data sample from the lower half. Example: if the series is
// 
// 2, 7, 4, 9, 1, 5, 8, 3, 6
// 
// then the median is 5.)
//
//Model the data structure for a component that would have these two methods:
//
//
//@interface SampleHandler {
//    - (void)addNumber:(NSNumber*)number;
//    - (NSNumber*)median;
//}
//Justify your decisions. Calculate the complexity of each method.

@interface addAndSearchMedian : NSObject

- (void)addNumber:(NSNumber*)number;
- (NSNumber*)median;

@end
