//
//  Graph.h
//  LCOBJC
//
//  Created by ethon_qi on 27/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"

@interface Graph : NSObject
- (UndirectedGraphNode *)cloneGraph:(UndirectedGraphNode *)node;

@end
