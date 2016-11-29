//
//  Graph.m
//  LCOBJC
//
//  Created by ethon_qi on 27/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Graph.h"

@implementation Graph

//133. Clone Graph

//Clone an undirected graph. Each node in the graph contains a label and a list of its neighbors.

//刚开始想到和 copy list 相同的办法，这里需要去重

// bfs
- (UndirectedGraphNode *)cloneGraph:(UndirectedGraphNode *)node
{
    if(node == nil){
        return nil;
    }
    
    NSMutableDictionary<UndirectedGraphNode *, UndirectedGraphNode*> *dic = [NSMutableDictionary dictionary];

    NSMutableArray<UndirectedGraphNode *> *queue = [NSMutableArray array];
    UndirectedGraphNode *cloneNode = [[UndirectedGraphNode alloc] initWithLabel:node.label];
    dic[node] = cloneNode;

    [queue addObject:node];

    while ([queue count]) {
        UndirectedGraphNode *node = [queue firstObject];
        [queue removeObjectAtIndex:0];
        UndirectedGraphNode *clone = dic[node];

        for(UndirectedGraphNode *neigh in node.neighbors){
            if(dic[neigh] == nil){ // not visited
                UndirectedGraphNode *cloneNeigh = [[UndirectedGraphNode alloc] initWithLabel:node.label];
                dic[neigh] = cloneNeigh; // update dic
                
                [cloneNode.neighbors addObject:cloneNeigh];
                [queue addObject:neigh];//注意如果这里已经访问过了，那么就不需要加入到queue里面了
            }
            [clone.neighbors addObject:dic[neigh]];
        }
    }
    return cloneNode;
}

//dfs
static NSMutableDictionary<UndirectedGraphNode *, UndirectedGraphNode*> *dic;

- (UndirectedGraphNode *)cloneGraph_dfs:(UndirectedGraphNode *)node
{
    if(node == nil){
        return nil;
    }
    if(dic){
        dic = [NSMutableDictionary dictionary];
    }
    
    if(!dic[node]){
        dic[node] = [[UndirectedGraphNode alloc] initWithLabel:node.label];
        for(UndirectedGraphNode *neigh in node.neighbors){
            [dic[node].neighbors addObject:[self cloneGraph_dfs:neigh]];
        }
    }
    return dic[node];
}

@end
