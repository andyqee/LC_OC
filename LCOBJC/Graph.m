//
//  Graph.m
//  LCOBJC
//
//  Created by ethon_qi on 27/11/2016.
//  Copyright © 2016 andy. All rights reserved.
//

#import "Graph.h"

@interface AGraphNode : NSObject
@property (nonatomic, strong) NSMutableSet *neighbour;
@property (nonatomic, assign) NSInteger indegree;

@end

@implementation AGraphNode

- (instancetype)init {
    self = [super init];
    if(self){
        _neighbour = [NSMutableSet set];
        _indegree = 0;
    }
    return self;
}

@end

@interface StackFrame: NSObject
@property (nonatomic, strong) UndirectedGraphNode *node;
@property (nonatomic, assign) NSInteger currentVisitedNeibourIndex;

- (instancetype)initWith:(UndirectedGraphNode *)node index:(NSInteger)index;

@end

@implementation StackFrame

- (instancetype)initWith:(UndirectedGraphNode *)node index:(NSInteger)index {
    self = [super init];
    if(self){
        _node = node;
        _currentVisitedNeibourIndex = index;
    }
    return self;
}

@end

@implementation Graph

#pragma mark - 133. Clone Graph 1.BFS  2.DFS recursive  3.DFS Iterative

// Clone an undirected graph. Each node in the graph contains a label and a list of its neighbors.
// 刚开始想到和 copy list 相同的办法，这里需要去重
// bfs, 本质上还是遍历，同时用dic 记录node 与 clone Node 的关系
// TODO: Fellow up 不用hashmap 怎么做。 如果图很大怎么弄？

// 这里的话呢 可以用 九章的算法 分三步，表较clear 一些 http://www.jiuzhang.com/solutions/clone-graph/
// 思路: use bfs algorithm to traverse the graph and get all nodes.
// copy nodes, store the old->new mapping information in a hash map
// copy neighbors(edges)

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
            if(dic[neigh] == nil){ // 通过访问和clone 建立的map 关系来判断是否 visited
                UndirectedGraphNode *cloneNeigh = [[UndirectedGraphNode alloc] initWithLabel:node.label];
                dic[neigh] = cloneNeigh; // update dic
                
                [clone.neighbors addObject:cloneNeigh];
                [queue addObject:neigh];//注意如果这里已经访问过了，那么就不需要加入到queue里面了
            }
            [clone.neighbors addObject:dic[neigh]];
        }
    }
    return cloneNode;
}

// DFS 递归实现
// 如何考虑去重复？
// 思路: 首先是需要自己定义node, 将dfs模版添加 添加返回值, 这里去重复直接就用的dic

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

// PAY attention pls

- (UndirectedGraphNode *)cloneGraph_dfs_iterative:(UndirectedGraphNode *)node
{
    //step1 :traverse the graph and get all the node
    //step2 :clone make store in map
    //step3 :add neibour
    if(node == nil){
        return nil;
    }
    NSArray<UndirectedGraphNode *> *nodes = [self getAllNodes:node];//hard part
    NSMutableDictionary<UndirectedGraphNode *, UndirectedGraphNode*> *dic = [NSMutableDictionary dictionary];
    for (UndirectedGraphNode *node in nodes) {
        dic[nodes] = [[UndirectedGraphNode alloc] initWithLabel:node.label];
    }
    for (UndirectedGraphNode *node in nodes) {
        UndirectedGraphNode *cloneGuy = dic[node];
        for(UndirectedGraphNode *neibour in node.neighbors){
            [cloneGuy.neighbors addObject:dic[neibour]];
        }
    }
    return dic[nodes.firstObject];
}

// 难点: graph 的iterative 的DFS 算法 very impressive. Fucking cool!!!!
// TODO: 自定义一个Stack Frame, 包含node,以及当前访问到的 neibour的index，用来记录下一次应该访问第几个。

- (NSArray<UndirectedGraphNode *> *)getAllNodes:(UndirectedGraphNode *)node
{
    NSMutableSet<UndirectedGraphNode *> *set = [NSMutableSet set];
    NSMutableArray<StackFrame *> *stack = [NSMutableArray array];
//    NSMutableArray<UndirectedGraphNode *> *result = [NSMutableArray array];
//    [result addObject:node];
    [set addObject:node];
    StackFrame *frame = [[StackFrame alloc] initWith:node index:-1];
    [stack addObject:frame];
    
    while ([stack count]) {
        StackFrame *frame = stack.lastObject;
        frame.currentVisitedNeibourIndex++;
        
        if(frame.currentVisitedNeibourIndex == frame.node.neighbors.count){// we know we have visited all the neibours and pop the frame from the stack
            [stack removeLastObject];
            continue;
        }
        
        UndirectedGraphNode *neibour = frame.node.neighbors[frame.currentVisitedNeibourIndex];
        if([set containsObject:neibour]){
            continue; // visited before
        }
        //FIXME: 这里不能忘记push stack
        [stack addObject:[[StackFrame alloc] initWith:neibour index:-1]];
//        [result addObject:neibour]; //这里可以不用result,直接通过set return 一个array
        [set addObject:neibour];
    }
    return [set allObjects];
}

#pragma mark - Valid Tree

// 除了dfs 和bfs 之外，还可以使用 union find 的方法
// dfs bfs 在解决这个问题的时候有什么优劣？和是数的结构有关。
// detect cycle

// 注意：这里面有
// 构建tree的时候, 每一条边的lastObject 也要加入到 edges 吗？这个疑惑暴露了对于build 一个graph理解还是不深刻的
// TODO:  忽略了directed graph 和undirected graph 在add edge 这个环节的差异。
// FIXME: 考点: 这里需要 判断两个，1 是否有环 2 是否联通，我只想到了第一个啊。 3. need a dic, to save the parent node of current node
//

// Make sure there is no cycle in the graph - this has to be a none-cyclic graph;
// Make sure every node is reached - this has to be a connected graph;

// FIXME: !!关键是这行代码 && child != from[node], 以及最后验证all connected

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
            if([visited containsObject:child] && child != from[node]){ //关键
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

// detect cycle, 需要传入两个node
// 关键是要 区别from的那个parent node, 正好利用dfs 的性质，因为dfs本身就是从其parent过来的
// DFS  O(v + E)

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

#pragma mark - 207. Course Schedule DFS

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

// TODO: BFS is a little complex
// 思路： 这里的检测是依赖于 每次设置完vertex 之后 检测整个图里面是否有indreee == 0 的如果没有，就必定有环
// need repeat
//

#pragma mark - 207. Course Schedule BFS

- (BOOL)canFinishBFS:(NSArray<NSArray<NSNumber *> *> *)edges count:(NSInteger)numCourses
{
    NSDictionary<NSNumber *, NSArray *> *graph = [self buildDirectedGraph:edges];
    NSMutableDictionary<NSNumber *, NSNumber *> *indegreeMap = [self degreeMap:graph];
    
    for (NSInteger i = 0; i < numCourses; i++) {
        NSInteger j = 0;
        for (; j < numCourses; j++)
            if ([indegreeMap[@(j)] isEqualToNumber: @0]) break;
        if (j == numCourses) return NO; // 没有0 indgree 的必定有环
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

#pragma mark - 207. Course Schedule 2

// 这个和找cycle 的区别在哪里,
// 这道题首选要检查的就是是否有环
// It must be a DAG directed acyclic graph？
// 这个topological sort
// 对于拓扑排序，算法这本书有非常好的讲解
// preorder           put the vertex on a queue before the recursive call
// postorder          put the vertex on a queue after the recursive call
// reverse post order put vertex on stack after the recursive calls 这个就是拓扑排序

//both involve examining all the edges and all the verices and thus tak time proportional to O（v + e）

// TODO: BFS 简单一些

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

//在首次接触这个思考的一个问题是：
//哪个算是头呢，如果进入的这个点 不是头怎么办？ 其实是所有的vertex 都是会扫一遍，也就是在for 循环中调用下面这个函数
//TODO: 对于这个topo 可以改进下，添加检测环的功能.

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

#pragma mark - alien dictionary DFS

// 思路: 1.首先根据words build 一个graph 关系图， compare the first character of words[i] and words[i-1], when they were equal compare the next character of each words, until they are not equal
//      2. traverse the graph to generate topological sort in directed graph
//      3. for invalid input like , it contains cycle in the graph . or graph is not connected. just return the empty string.

//TODO: 需要注意 在进行topological sort 的时候，需要把graph 所有的的 入口 都scane 一遍。
// 这道题和上面那到题目 非常的像
// 我用的DFS 的办法， 也可以用BFS。

- (NSString *)alienDictionary:(NSArray<NSString *> *)words
{
    NSDictionary *graph = [self buildGraphWith:words];
    
    if([self containsCycle:graph]){
        return @"";
    }
    
    NSMutableArray *result = [NSMutableArray array];
    NSMutableSet *visited = [NSMutableSet set];

    for (NSString *key in [graph allKeys]) { //
        if(![visited containsObject:key]){
            [self topologicalSort:graph vertex:key visited:visited result:result];
        }
    }
    //FIXME: 注意! 这里的reuslt ftrew 所以需要reverse一下
    return [[[result reverseObjectEnumerator] allObjects] componentsJoinedByString:@""];
}

// step 1: build graph
// FIXME: 坑 我刚开始的写法，会丢失掉没有参加比较的字符，也就是只出现一次的字符
// how about some char which has not the chance to compare, 也就是遇到不等字符串之后，其后面的字符串如何处理
// BUG1: 在存neibour 的时候这里用的 NSDictionary<NSNumber *, NSArray*> *, 但是这里有个问题是 可能会遇到重复的字符，也被添加到NSArray 中，
// 所以这里需要替换成NSSet

// BUG2: 在找到第一个不等之后，需要break

- (NSDictionary<NSNumber *, NSArray*> *)buildGraphWith:(NSArray<NSString *> *)words
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // 这里需要过滤掉invalid 的words 嘛，比如 emtpy string
    for(NSInteger i = 0; i < words.count - 1; i++){
        NSString *a = words[i];
        NSString *b = words[i + 1];
        for (NSInteger j = 0; j < MAX(a.length, b.length); j++) {
            if(j < MIN(a.length, b.length)) {
                NSRange range = NSMakeRange(j, 1);
                if(![[a substringWithRange:range] isEqualTo:[b substringWithRange:range]]){
                    if(dic[[a substringWithRange:range]]){
                        [dic[[a substringWithRange:range]] addObject:[b substringWithRange:range]];
                    } else {
                        dic[[a substringWithRange:range]] = [@[[b substringWithRange:range]] mutableCopy];//
                    }
                    break; //一旦找到不等，立刻break
                }
            } else { // 对于distint 如何处理，需要确认下, 九章算法也没有考虑
                NSString *longStr = a.length > b.length ? a : b;
                NSString *ch = [longStr substringWithRange:NSMakeRange(j, 1)] ;
                if(!dic[ch]){
                    dic[ch] = [@[] mutableCopy];
                }
            }
        }
        
    }
    return [dic copy];
}

- (BOOL)containsCycle:(NSDictionary *)graph
{
    NSMutableSet *visited = [NSMutableSet set];
    NSMutableSet *onStack = [NSMutableSet set];
    
    for (NSString *key in [graph allKeys]) {
        if(![visited containsObject:key] && [self detectCycle:graph node:key visited:visited onStack:onStack]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)detectCycle:(NSDictionary *)graph node:(NSString *)node visited:(NSMutableSet *)visited onStack:(NSMutableSet *)onStack
{
    [visited addObject:node];
    [onStack addObject:node];
    
    for (NSString *neibor in graph[node]) {
        if([visited containsObject:neibor]){ //这一步应该是需要的吧？？
            continue;
        }
        if([onStack containsObject:neibor] || [self detectCycle:graph node:neibor visited:visited onStack:onStack]){
            return YES;
        }
    }
    [onStack removeObject:node];
    return NO;
}

// 最深的那个vertex 会最先被加入 array 里面，因为dfs最深的那个最先 done

- (void)topologicalSort:(NSDictionary *)graph vertex:(NSString *)vertex visited:(NSMutableSet *)visited result:(NSMutableArray *)result
{
    [visited addObject:vertex];
    for(NSString *neibour in graph[vertex]){
        if([visited containsObject:neibour]){
            continue;
        }
        [self topologicalSort:graph vertex:neibour visited:visited result:result];
    }
    [result addObject:vertex];
}

#pragma mark - alien dictionary 九章里面用了BFS

// https://courses.cs.washington.edu/courses/cse373/06sp/handouts/lecture21.pdf
// https://discuss.leetcode.com/topic/28308/java-ac-solution-using-bfs

- (NSString *)alienDictionary_BFS:(NSArray<NSString *> *)words
{
    NSMutableDictionary<NSString *, NSMutableSet<NSString *> *> *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary<NSString *, NSNumber *> *degree = [NSMutableDictionary dictionary]; //这里可以c array 来压缩
    
    // step1 : build graph and indegree
    for (NSInteger i = 0; i < words.count - 1; i++) {
        NSString *a = words[i];
        NSString *b = words[i + 1];
        for(NSInteger j = 0; j < MIN(a.length, b.length); j++){
            NSString *c = [a substringWithRange:NSMakeRange(j, 1)];
            NSString *d = [b substringWithRange:NSMakeRange(j, 1)];
            if(![c isEqualToString:d]){
                if(dic[c]){
                    dic[c] = [NSMutableSet setWithObject:d];
                } else if(![dic[c] containsObject:d]){ //neibour 里面还没有 d
                    [dic[c] addObject:d];
                    degree[d] = @(degree[d].integerValue + 1);
                }
                break; // FIXME: 这里一定要及时break！！ 因为后面的比较会比较没有意义
            }
        }
    }
    
    NSMutableArray *queue = [NSMutableArray array];
    //step 2 : find all the node which indegree is 0, that means it has no dependency
    for (NSString *node in degree.allKeys) {
        if([degree[node] isEqualToNumber:@0]){
            [queue addObject:node];
        }
    }
    //step 3: 去边运动, 找到indegree 为0 的node, 然后降低neibour的的indgree
    NSMutableString *sortedStr = [NSMutableString string];
    while ([queue count]) {
        NSString *node = [queue firstObject];
        [queue removeObjectAtIndex:0];
        [sortedStr appendString:node];
        
        //decrement the indegree of it's neibour,and add the node which indegree is zero
        for(NSString *neibo in dic[node]){
            degree[neibo] = @(degree[neibo].integerValue - 1);
            if([degree[neibo] isEqualToNumber:@0]){ //在选择加入到 queue 里面的时候，选择先讲indegree == 0 的点进去
                [queue addObject:neibo];
            }
        }
    }
    // step 4 就是校验 是不是所有的node 都输出了,如果不是说明有环
    return (sortedStr.length == degree.count) ? [sortedStr copy] : @"";
}

#pragma mark - 329. Longest Increasing Path in a Matrix

// 两种解法: DFS 和 带记忆搜索的DFS 算是DP吧

// DFS 解法

- (NSInteger)longestIncreasingPath:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    NSMutableOrderedSet *path = [NSMutableOrderedSet orderedSet];
    
    NSInteger leng = 0;
    for (NSInteger i = 0; i < matrix.count; i++) {
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            [self longestIncreasingPath:matrix path:path i:i j:j length:&leng];
        }
    }
    return leng;
}

static int dx[4] = {0, 0, -1, 1};
static int dy[4] = {1, -1, 0, 0};

- (void)longestIncreasingPath:(NSArray<NSArray<NSNumber *> *> *)matrix path:(NSMutableOrderedSet<NSNumber *> *)paths i:(NSInteger)i j:(NSInteger)j length:(NSInteger *)length
{
    if(i < 0 || j < 0 || i >= matrix.count || j >= matrix.firstObject.count ||
       (paths.count != 0 && matrix[i][j].integerValue <= paths.lastObject.integerValue) || [paths containsObject:matrix[i][j] ]) {
        return;
    }
    
    [paths addObject:matrix[i][j]];
    *length = MAX(*length, paths.count);

    for (int k = 0; k < 4; k++) { // 用这种解法替换上面这种粗暴的写法
        [self longestIncreasingPath:matrix path:paths i:i + dx[k] j:j + dy[k] length:length];
    }
    [paths removeObject:matrix[i][j]];
}

// TODO: 掌握带记忆 DP & DFS 带记忆搜索, 和word search 也挺像的, 注意搜索的step,可以用数组的办法。word break 也用到这种方法
// Do DFS from every cell
// Compare every 4 direction and skip cells that are out of boundary or smaller
// Get matrix max from every cell's max
// Use matrix[x][y] <= matrix[i][j] so we don't need a visited[m][n] array
// The key is to cache the distance because it's highly possible to revisit a cell

- (NSInteger)longestIncreasingPath_DP:(NSArray<NSArray<NSNumber *> *> *)matrix
{
    NSMutableArray<NSMutableArray<NSNumber *> *> *dp = [NSMutableArray array];
    for (NSInteger i = 0; i < matrix.count; i++) {
        NSMutableArray *sub = [NSMutableArray array];
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            [sub addObject:@0];
        }
        [dp addObject:sub];
    }
    NSInteger maxLen = 0;
    for (NSInteger i = 0; i < matrix.count; i++) {
        for(NSInteger j = 0; j < matrix.firstObject.count; j++){
            maxLen = MAX(maxLen, [self longestIncreasingPath:matrix table:dp i:i j:j]);
        }
    }
    return maxLen;
}

// 第一遍写带记忆的版本 这里在搜索的时候，需要考虑单调性，所以不担心有重复搜索的问题，不需要去重
// 状态转移方程: table[i][j] 用来表示以matrix[i][j] 开头的序列的最大长度

- (NSInteger)longestIncreasingPath:(NSArray<NSArray<NSNumber *> *> *)matrix
                        table:(NSMutableArray<NSMutableArray<NSNumber *> *> *)table
                            i:(NSInteger)i
                                 j:(NSInteger)j
{
    if (table[i][j].integerValue > 0) { // 记忆
        return table[i][j].integerValue;
    }
    NSInteger m = matrix.count;
    NSInteger n = matrix.firstObject.count;
    NSInteger maxLen = 0;
    for (int k = 0; k < 4; k++) { // 用这种解法替换上面这种粗暴的写法
        NSInteger x = i + dx[k];
        NSInteger y = i + dy[k];

        if(x >= 0 && x < m && y >= 0 && y < n && matrix[x][y].integerValue > matrix[i][j].integerValue){//一直单调递增不需要去重
            maxLen = MAX(1 + [self longestIncreasingPath:matrix table:table i:x j:y], maxLen);
        }
    }
    table[i][j] = @(maxLen);
    
    return maxLen;
}

@end
