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

// bfs, 本质上还是遍历，同时用dic 记录node 与 clone Node 的关系

- (UndirectedGraphNode *)cloneGraph:(UndirectedGraphNode *)node
{
    if(node == nil){
        return nil;
    }
    //同时也具有标记是否已经访问的作用
    NSMutableDictionary<UndirectedGraphNode *, UndirectedGraphNode*> *dic = [NSMutableDictionary dictionary];

    NSMutableArray<UndirectedGraphNode *> *queue = [NSMutableArray array];
    [queue addObject:node];
    UndirectedGraphNode *cloneNode = [[UndirectedGraphNode alloc] initWithLabel:node.label];
    dic[node] = cloneNode;
    
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

//除了dfs 和bfs 之外，还可以使用 union find 的方法
// dfs bfs 在解决这个问题的时候有什么优劣？和是数的结构有关。
// detect cycle

//注意：这里面有
//构建tree的时候, 每一条边的lastObject 也要加入到 edges 吗？这个疑惑暴露了对于build 一个graph理解还是不深刻的
//忽略了directed graph 和undirected graph 在add edge 这个环节的差异。
//这里需要 判断两个，1 是否有环 1 是否联通，我只想到了第一个啊
//

// Make sure there is no cycle in the graph - this has to be a none-cyclic graph;
// Make sure every node is reached - this has to be a connected graph;

// !!关键是这行代码 && child != from[node], 以及最后验证all connected

- (BOOL)validTree:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)n
{
    //traversal Node
    NSDictionary *graph = [self buildGraph:edges];// time: number of edges
    
    NSMutableSet *visited = [NSMutableSet set];
    NSMutableArray *queue = [NSMutableArray array];
    NSMutableDictionary *from = [NSMutableDictionary dictionary];
    
    [queue addObject:edges[0][0]]; //
    
    while ([queue count]) {// number of vertix + number of edges5yujh j
        NSNumber *node = [queue firstObject];
        [queue removeObjectAtIndex:0];
        
        [visited addObject:node];
        NSArray *children = graph[node];
        for (NSNumber *child in children) {
            if([visited containsObject:child] && child != from[node]){
                return NO;
            }
            [queue addObject:child];
            from[child] = node;
        }
    }
    
    return [visited count] == n;
}

- (BOOL)validTreeDFS:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)n
{
    NSDictionary<NSNumber *, NSMutableArray *> *graph = [self buildGraph:edges];
    NSMutableSet *visited = [NSMutableSet set];
    if([self detectCycleDFS:edges[0][0] parent:nil graph:graph visited:visited]){
        return NO;
    }
    // step2 ：如何验证all connected graph, 所有的点是否已经被访问过
    return [visited count] == n;
}

//detect cycle, 需要传入两个node
//关键是要 区别from的那个parent node

- (BOOL)detectCycleDFS:(NSNumber *)node parent:(NSNumber *)parent graph:(NSDictionary *)graph visited:(NSMutableSet *)visited
{
    NSArray *children = graph[node];
    [visited addObject:node];
    
    for(NSNumber *child in children) { //dfs 有返回值，不能直接return，这样的话会导致children 只会被调用一次。
        if(([visited containsObject:child] && child != parent) ||
           (![visited containsObject:child] && [self detectCycleDFS:child parent:node graph:graph visited:visited])){ // 注意第二个判断条件，容易遗漏
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)buildGraph:(NSArray<NSArray<NSNumber *> *> *)edges
{
    //construct graph
    NSMutableDictionary<NSNumber *, NSMutableArray *> *graph = [NSMutableDictionary dictionary];//也可以用二维数组，但是数组的初始化没办法弄，因为要指定空间，所以用dic更适合
    for (NSArray *edge in edges) {
        NSNumber *startNode = [edge firstObject];
        NSNumber *endNode = [edge lastObject];
        if(graph[startNode]){
            [graph[startNode] addObject:endNode];
        } else {
            graph[startNode] = [NSMutableArray arrayWithObject:endNode];
        }
        //!!!, 如果是有向图这里就不需要了。很重要的一点是这里需要将end 也作为key进行存储
        if(graph[endNode]){
            [graph[endNode] addObject:startNode];
        } else {
            graph[endNode] = [NSMutableArray arrayWithObject:startNode];
        }
    }
    return graph;
}

//验证all the node reachable
//no cycle
//三种解法：

// union found

//vector<int> nodes(n,0);
//for(int i=0; i<n; i++) nodes[i] = i;
//for(int i=0; i<edges.size(); i++){
//    int f = edges[i].first;
//    int s = edges[i].second;
//    while(nodes[f]!=f) f = nodes[f];
//    while(nodes[s]!=s) s = nodes[s];
//    if(nodes[f] == nodes[s]) return false;
//    nodes[s] = f;
//}
//return edges.size() == n-1;

// http://www.cnblogs.com/grandyang/p/5257919.html
// https://www.cs.princeton.edu/~rs/AlgsDS07/01UnionFind.pdf

- (BOOL)validTree:(NSInteger)n edges:(NSArray<NSArray<NSNumber *> *> *)edges
{
    NSMutableArray<NSNumber *> *root = [NSMutableArray arrayWithCapacity:n];
    //quick union
    for(NSInteger i = 0; i < n; i++){
        [root addObject:@(i)];
    }
    
    for(NSInteger j = 0; j < edges.count; j++){
        NSNumber *start = [edges[j] firstObject];
        NSNumber *second = [edges[j] firstObject];
        
        //find root
        while ([start compare: root[start.integerValue]] != NSOrderedSame) {
            start = root[start.integerValue];
        }
        while ([second compare: root[second.integerValue]] != NSOrderedSame) {
            second = root[second.integerValue];
        }
        if([start compare:second] == NSOrderedSame){
            return NO; //有环
        }
    }
    return edges.count == n -1;
}

// detect cycle, cyclic digraph
// 1 ---->4
// |
// |
// 2

//207. Course Schedule
// 这题是关于 有向图 环检测的问题

- (BOOL)canFinish:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses
{
    NSDictionary<NSNumber *, NSArray *> *graph = [self buildDirectedGraph:edges];
    NSMutableSet *visited = [NSMutableSet set];
    
    NSMutableSet *onStack = [NSMutableSet set];
    for(NSNumber *vertex in [graph allKeys]){ //这里要从input degree 为0 的点进行traversal, 这里需要visited来标记是因为 不同的的node它们的child 可能是同个，这样就会出现重复traversal 的情况，所以这里需要visited来标记
        if(![visited containsObject:vertex] && [self detectCycleDFS:vertex graph:graph visited:visited onStack:onStack]){
            return NO;
        }
    }
    return YES;
}

// digraph 不需要parent， 需要onstack 来track当前的traversal 中是否有环
- (BOOL)detectCycleDFS:(NSNumber *)node graph:(NSDictionary *)graph visited:(NSMutableSet *)visited onStack:(NSMutableSet *)onStack
{
    [visited addObject:node];
    [onStack addObject:node];//这个关键, 这个算是prevOrder
    
    for (NSNumber *child in graph[node]) {
        if([onStack containsObject:child] || [self detectCycleDFS:child graph:graph visited:visited onStack:onStack]){
            return YES;
        }
    }
    [onStack removeObject:node];
    return NO;
}

// BFS is a little complex
// 这个方法优点复杂, 不是很理解
// 这里的检测是依赖于 每次设置完vertex 之后 检测整个图里面是否有indreee == 0 的如果没有，就必定有环
// 这背后的理论如何证明

// need repeat
- (BOOL)canFinishBFS:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses
{
    NSDictionary<NSNumber *, NSArray *> *graph = [self buildDirectedGraph:edges];
    NSMutableDictionary<NSNumber *, NSNumber *> *indegreeMap = [self degreeMap:graph];
    
    for (NSInteger i = 0; i < numCourses; i++) {
        NSInteger j = 0;
        for (; j < numCourses; j++)
            if (!indegreeMap[@(j)]) break;
        if (j == numCourses) return false; // 没有0 indgree 的必定有环
        indegreeMap[@(j)] = @(-1);
        for(NSNumber *neigh in graph[@(j)]){
            indegreeMap[neigh] = @(indegreeMap[neigh].integerValue - 1);
        }
    }
    return YES;
}

- (NSDictionary *)buildDirectedGraph:(NSArray<NSArray<NSNumber *> *> *)edges
{
    //construct graph
    NSMutableDictionary<NSNumber *, NSMutableArray *> *graph = [NSMutableDictionary dictionary];//也可以用二维数组，但是数组的初始化没办法弄，因为要指定空间，所以用dic更适合
    for (NSArray *edge in edges) {
        NSNumber *startNode = [edge firstObject];
        NSNumber *endNode = [edge lastObject];
        if(graph[endNode]){
            [graph[endNode] addObject:startNode];
        } else {
            graph[endNode] = [NSMutableArray arrayWithObject:startNode];
        }
        //!!!, 如果是有向图这里就不需要了。很重要的一点是这里需要将end 也作为key进行存储
    }
    return graph;
}

- (NSMutableDictionary *)degreeMap:(NSDictionary<NSNumber *, NSArray *> *)graph
{
    NSMutableDictionary *degreeMap = [NSMutableDictionary dictionary];
    for(NSNumber *key in [graph allKeys]){
        degreeMap[key] = @(graph[key].count);
    }
    return degreeMap;
}

//207. Course Schedule 2

// 这个和找cycle 的区别在哪里,
// 这道题首选要检查的就是是否有环
// It must be a DAG directed acyclic graph？
// 这个topological sort
// 对于拓扑排序，算法这本书有非常好的讲解
// preorder           put the vertex on a queue before the recursive call
// postorder          put the vertex on a queue after the recursive call
// reverse post order put vertex on stack after the recursive calls 这个就是拓扑排序

//both involve examining all the edges and all the verices and thus tak time proportional to O（v + e）

- (NSArray *)findOrder:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses
{
    NSDictionary<NSNumber *, NSArray *> *graph = [self buildDirectedGraph:edges];
    NSMutableSet *visited = [NSMutableSet set];
    NSMutableArray *result = [NSMutableArray array];
    
    if(![self canFinish:edges count:numCourses]){
        return nil;
    } // 也可以将这个逻辑写在拓扑排序里面
    
    for(NSNumber *vertex in [graph allKeys]){
        if (![visited containsObject:vertex]) {
            [self topoSort:graph vertex:vertex visited:visited result:result];
        }
    }
    return [[result reverseObjectEnumerator] allObjects];
}

- (void)topoSort:(NSDictionary *)graph vertex:(NSNumber *)vertex visited:(NSMutableSet *)visited result:(NSMutableArray *)result
{
    [visited addObject:vertex];
    for (NSNumber *neigh in graph[vertex]) {
        if(![visited containsObject:vertex]){
            [self topoSort:graph vertex:neigh visited:visited result:result];
        }
    }
    [result addObject:vertex];
}

@end
