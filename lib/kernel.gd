#1
##  Categories and data Types:

##  #FIXME: Next Version should allow to define new categories dynamically.
##  each category then should come with a name, a tester, a functor and lattice info. 
##

###############################################################################
##
#C  Graphs()
##
##  `Graphs' is the most general graph category in {\YAGS}. This category contains
##  all graphs that can be represented in {\YAGS}. A graph in this category may 
##  contain loops, arrows and edges (which in {\YAGS} are exactly the same as two opposite 
##  arrows between some pair of vertices). This graph category has no parent category.
##
##  \beginexample
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=Graphs);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=SimpleGraphs);  
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  \endexample
##
DeclareCategory("Graphs",IsObject);

###############################################################################
##
#C  LooplessGraphs()
##
##  `LooplessGraphs' is a graph category in {\YAGS}. A graph in this category may 
##  contain arrows and edges but no loops. The parent of this category is `Graphs'.
##
##  \beginexample
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=Graphs);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=LooplessGraphs);  
##  Graph( Category := LooplessGraphs, Order := 3, Size := 3, Adjacencies := 
##  [ [ 2 ], [ 1 ], [ 2 ] ] )
##  \endexample
##
DeclareCategory("LooplessGraphs",Graphs);

###############################################################################
##
#C  UndirectedGraphs()
##
##  `UndirectedGraphs' is a graph category in {\YAGS}. A graph in this category may 
##  contain edges and loops, but no arrows. The parent of this category is `Graphs'.
##
##  \beginexample
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=Graphs);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=UndirectedGraphs);
##  Graph( Category := UndirectedGraphs, Order := 3, Size := 3, Adjacencies := 
##  [ [ 1, 2 ], [ 1, 3 ], [ 2 ] ] )
##  \endexample
##
DeclareCategory("UndirectedGraphs",Graphs);

###############################################################################
##
#C  OrientedGraphs()
##
##  `OrientedGraphs' is a graph category in {\YAGS}. A graph in this category may 
##  contain arrows, but no loops or edges. The parent of this category is `LooplessGraphs'.
##
##  \beginexample
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=Graphs);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=OrientedGraphs);
##  Graph( Category := OrientedGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [  ], [ 2 ] ] )
##  \endexample
##
DeclareCategory("OrientedGraphs",LooplessGraphs);

###############################################################################
##
#C  SimpleGraphs()
##
##  `SimpleGraphs' is a graph category in {\YAGS}. A graph in this category may 
##  contain edges, but no loops or arrows. The category has two parents: `LooplessGraphs' 
##  and `UndirectedGraphs'.
##
##  \beginexample
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=Graphs);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]:GraphCategory:=SimpleGraphs);  
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  \endexample
##
DeclareCategory("SimpleGraphs",LooplessGraphs and UndirectedGraphs);
InstallTrueMethod(SimpleGraphs,LooplessGraphs and UndirectedGraphs);

BindGlobal("DefaultGraphCategory",SimpleGraphs);
###############################################################################
##
#F  SetDefaultGraphCategory( <Catgy> )
##  
##  Sets the default graph category to <Catgy>. The default graph
##  category is used when constructing new graphs when no other graph category 
##  is indicated. New graphs are always forced to comply with the `TargetGraphCategory', 
##  so loops may be removed, and arrows may replaced by edges or viceversa, depending on 
##  the category that the new graph belongs to.
##  
##  The available graph categories are:  `SimpleGraphs', `OrientedGraphs', 
##  `UndirectedGraphs', `LooplessGraphs', and `Graphs'.
##  
##  \beginexample
##  gap> SetDefaultGraphCategory(Graphs);
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]);
##  Graph( Category := Graphs, Order := 3, Size := 4, Adjacencies := 
##  [ [ 1, 2 ], [ 1 ], [ 2 ] ] )
##  gap> SetDefaultGraphCategory(LooplessGraphs);
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]);  
##  Graph( Category := LooplessGraphs, Order := 3, Size := 3, Adjacencies := 
##  [ [ 2 ], [ 1 ], [ 2 ] ] )
##  gap> SetDefaultGraphCategory(UndirectedGraphs);
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]);    
##  Graph( Category := UndirectedGraphs, Order := 3, Size := 3, Adjacencies := 
##  [ [ 1, 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> SetDefaultGraphCategory(SimpleGraphs);    
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> SetDefaultGraphCategory(OrientedGraphs);
##  gap> GraphByWalks([1,1],[1,2],[2,1],[3,2]);  
##  Graph( Category := OrientedGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [  ], [ 2 ] ] )
##  \endexample
##
DeclareGlobalFunction("SetDefaultGraphCategory");
BindGlobal("AvailableGraphCategories",
   [SimpleGraphs,OrientedGraphs,UndirectedGraphs,LooplessGraphs,Graphs]);

############################################################################
##
#F  GraphCategory( [ <G>, ... ] );
##
##  For internal use. Returns the minimal common category to a list of graphs.
##  If the list of graphs is empty, the default category is returned.
## 
##  The partial order (by inclusion) among graph categories is as follows: 
##  %%FIXME: Wrong spacing in the pdf manual.
##  $$
##  `SimpleGraphs' \<  `UndirectedGraphs' \< `Graphs',
##  $$
##  $$
##  `OrientedGraphs' \< `LooplessGraphs' \< `Graphs',
##  $$
##  $$
##  `SimpleGraphs' \< `LooplessGraphs' \< `Graphs'
##  $$
##   
##  \beginexample
##  gap> g1:=CompleteGraph(2:GraphCategory:=SimpleGraphs);  
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := 
##  [ [ 2 ], [ 1 ] ] )
##  gap> g2:=CompleteGraph(2:GraphCategory:=OrientedGraphs);
##  Graph( Category := OrientedGraphs, Order := 2, Size := 1, Adjacencies := 
##  [ [ 2 ], [  ] ] )
##  gap> g3:=CompleteGraph(2:GraphCategory:=UndirectedGraphs);
##  Graph( Category := UndirectedGraphs, Order := 2, Size := 3, Adjacencies := 
##  [ [ 1, 2 ], [ 1, 2 ] ] )
##  gap> GraphCategory([g1,g2,g3]);
##  <Operation "Graphs">
##  gap> GraphCategory([g1,g2]);   
##  <Operation "LooplessGraphs">
##  gap> GraphCategory([g1,g3]);
##  <Operation "UndirectedGraphs">
##  \endexample
##
DeclareGlobalFunction("GraphCategory"); #common graph ctgy or default.

############################################################################
##
#F  TargetGraphCategory( [ <G>, ... ] );
##
##  For internal use. Returns the graph category indicated in the <options stack> if any, 
##  otherwise if the list of graphs provided is not empty, returns the minimal common graph 
##  category for the graphs in the list, else returns the default graph category.
##
##  The partial order (by inclusion) among graph categories is as follows: 
##  $$`SimpleGraphs' \<  `UndirectedGraphs' \< `Graphs',$$
##  $$`OrientedGraphs' \< `LooplessGraphs' \< `Graphs'$$  
##  $$`SimpleGraphs' \< `LooplessGraphs' \< `Graphs'$$
##   
##  This function is internally called by all graph constructing operations in {\YAGS} to decide the 
##  graph category that the newly constructed graph is going to belong. New graphs are always 
##  forced to comply with the `TargetGraphCategory', so loops may be removed, and arrows may 
##  replaced by edges or viceversa, depending on the category that the new graph belongs to.
##  
##  The <options stack> is a mechanism provided by {\GAP} to pass implicit parameters 
##  and is used by `TargetGraphCategory' so that the user may indicate the graph 
##  category she/he wants for the new graph.
##
##  \beginexample
##  gap> SetDefaultGraphCategory(SimpleGraphs);             
##  gap> g1:=CompleteGraph(2);                              
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := 
##  [ [ 2 ], [ 1 ] ] )
##  gap> g2:=CompleteGraph(2:GraphCategory:=OrientedGraphs);
##  Graph( Category := OrientedGraphs, Order := 2, Size := 1, Adjacencies := 
##  [ [ 2 ], [  ] ] )
##  gap> DisjointUnion(g1,g2);
##  Graph( Category := LooplessGraphs, Order := 4, Size := 3, Adjacencies := 
##  [ [ 2 ], [ 1 ], [ 4 ], [  ] ] )
##  gap> DisjointUnion(g1,g2:GraphCategory:=UndirectedGraphs);
##  Graph( Category := UndirectedGraphs, Order := 4, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1 ], [ 4 ], [ 3 ] ] )
##  \endexample
##  
##  In the previous examples, `TargetGraphCategory' was called internally exactly once for 
##  each new graph constructed with the following parameters:
##  
##  \beginexample
##  gap> TargetGraphCategory();
##  <Operation "SimpleGraphs">
##  gap> TargetGraphCategory(:GraphCategory:=OrientedGraphs);
##  <Operation "OrientedGraphs">
##  gap> TargetGraphCategory([g1,g2]);                       
##  <Operation "LooplessGraphs">
##  gap> TargetGraphCategory([g1,g2]:GraphCategory:=UndirectedGraphs);
##  <Operation "UndirectedGraphs">
##  \endexample
##
DeclareGlobalFunction("TargetGraphCategory"); # option or graph or default ctgy.

###############################################################################
##
#O  in( <G>, <Catgy> )
##
##  Returns `true' if graph <G> belongs to category <Catgy> and `false' otherwise.
##
InstallMethod(\in,"for graph categories", true, [Graphs,IsOperation],0, 
function(x,f)
  if f in AvailableGraphCategories then
    return f(x); 
  else
    TryNextMethod();
  fi;
end);

DeclareRepresentation( "IsGraphStdRep",IsAttributeStoringRep , ["GraphCategory","AdjMatrix"] );
GraphFamily:=NewFamily("GraphFamily");
GraphType:=NewType(GraphFamily,Graphs and IsGraphStdRep);

##
##  Attributes and Properties:
##
############################################################################
##
#A  AdjMatrix( <G> )
##
##  Returns the adjacency matrix of graph <G>.
##
##  \beginexample
##  gap> AdjMatrix(CycleGraph(4));
##  [ [ false, true, false, true ], [ true, false, true, false ], 
##    [ false, true, false, true ], [ true, false, true, false ] ]
##  \endexample
##  
DeclareAttribute("AdjMatrix",Graphs);

############################################################################
##
#A  Order(<G>)
##
##  Returns the number of vertices, of graph <G>.
##
##  \beginexample
##  gap> Order(Icosahedron);
##  12
##  \endexample
##  
DeclareAttribute("Order",Graphs);

############################################################################
##
#A  Size(<G>)
##
##  Returns the number of edges of graph <G>.
##
##  \beginexample
##  gap> Size(Icosahedron);
##  30
##  \endexample
##  
DeclareAttribute("Size",Graphs);

############################################################################
##
#A  VertexNames(<G>)
##
##  Return the list of names of the vertices of <G>. The vertices of a graph in {\YAGS} are always 
##  $\{1,2, \ldots, Order(G)\}$, but depending on how the graph was constructed, its vertices may 
##  have also some <names>, that help us identify the origin of the vertices. {\YAGS} will always try 
##  to store meaninful names for the vertices. For example, in the case of the LineGraph, the vertex 
##  names of the new graph are the edges of the old graph.
##
##  \beginexample
##  gap> g:=LineGraph(DiamondGraph);          
##  Graph( Category := SimpleGraphs, Order := 5, Size := 8, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4, 5 ], [ 1, 2, 5 ], [ 1, 2, 5 ], [ 2, 3, 4 ] ] )
##  gap> VertexNames(g);
##  [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 3, 4 ] ]
##  gap> Edges(DiamondGraph);
##  [ [ 1, 2 ], [ 1, 3 ], [ 1, 4 ], [ 2, 3 ], [ 3, 4 ] ]
##  \endexample
##  
DeclareAttribute("VertexNames",Graphs);

############################################################################
##
#P  IsCompleteGraph(<G>)
##
##  Returns `true' if graph <G> is a complete graph, `false' otherwise.
##  In a complete graph every pair of vertices is an edge.
##
DeclareQtfyProperty("IsCompleteGraph",Graphs);

############################################################################
##
#P  IsLoopless(<G>)
##
##  Returns `true' if graph <G> have no loops, `false' otherwise. Loops are edges 
##  from a vertex to itself.
##
DeclareQtfyProperty("IsLoopless",Graphs);

############################################################################
##
#P  IsUndirected(<G>)
##
##  Returns `true' if graph <G> is an undirected graph, `false' otherwise.
##  Regardless of the categories that <G> belongs to, <G> is undirected if 
##  whenever `[x,y]' is an edge of <G>, `[y,x]' is also an egde of <G>.
##
DeclareQtfyProperty("IsUndirected",Graphs);

## FIXME: changing #Q by #P breaks the manual, why???
############################################################################
##
#Q  IsOriented(<G>)
##
##  Returns `true' if graph <G> is an oriented graph, `false' otherwise.
##  Regardless of the categories that <G> belongs to, <G> is oriented if 
##  whenever `[x,y]' is an edge of <G>, `[y,x]' is not.
##
DeclareQtfyProperty("IsOriented",Graphs);

##  Gap already declares "IsSImple" as an operation. 
##  Hence it may not be redefined as a property
############################################################################
##
#P  IsSimple(<G>)
##
##  Returns `true' if graph <G> is a simple graph, `false' otherwise.
##  Regardless of the categories that <G> belongs to, <G> is simple if and only if 
##  <G> is undirected and loopless.
##
##  Returns `true' if the graph <G> is simple regardless of its category.
##
DeclareOperation("IsSimple",[Graphs]);

############################################################################
##
#A  QtfyIsSimple( <G> )
##
##  For internal use. Returns how far is graph <G> from being simple.
##
DeclareAttribute("QtfyIsSimple",Graphs);

############################################################################
##
#O  IsComplete( <G>, <L> )
##
##  Returns `true' if <L> induces a complete subgraph of <G>.
##
##  \beginexample
##  gap> IsComplete(DiamondGraph,[1,2,3]);
##  true
##  gap> IsComplete(DiamondGraph,[1,2,4]);
##  false
##  \endexample
##  
DeclareOperation("IsComplete",[Graphs,IsList]);

############################################################################
##
#O  Vertices( <G> )
##
##  Returns the list [1..Order( <G> )].
##
##  \beginexample
##  gap> Vertices(Icosahedron);
##  [ 1 .. 12 ]
##  \endexample
##  
DeclareOperation("Vertices",[Graphs]);

############################################################################
##
#O  IsEdge( <G>, <x>, <y>)
#O  IsEdge( <G>, [<x>,<y>])
##
##  Returns `true' if [<x>,<y>] is an edge of <G>.
##
##  \beginexample
##  gap> IsEdge(PathGraph(3),1,2);
##  true
##  gap> IsEdge(PathGraph(3),[1,2]);
##  true
##  gap> IsEdge(PathGraph(3),1,3);
##  false
##  gap> IsEdge(PathGraph(3),[1,3]);
##  false
##  \endexample
##  
##  The first form, IsEdge(<G>, <x>, <y>), is a bit faster and hence more 
##  suitable for use in algoritms which make extensive use of this operation.
##  On the other hand, the first form does no error checking at all, and hence,
##  it may produce an error where the second form returns false 
##  (for instance when <x> is not a vertex of <G>). The second form is therefore
##  a bit slower, but more robust.
##  
##  \beginexample
##  gap> IsEdge(PathGraph(3),[7,3]);
##  false
##  gap> IsEdge(PathGraph(3),7,3);  
##  Error, List Element: <list>[7] must have an assigned value in
##    return AdjMatrix( G )[x][y]; called from 
##  <function "unknown">( <arguments> )
##   called from read-eval loop at line 4 of *stdin*
##  you can 'return;' after assigning a value
##  brk>
##  \endexample
##  
DeclareOperation("IsEdge",[Graphs,IsInt,IsInt]);

############################################################################
##
#O  Adjacency( <G>, <x> )
##
##  Returns the adjacency list of vertex <x> in <G>.
##
##  \beginexample
##  gap> g:=PathGraph(3);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> Adjacency(g,1);           
##  [ 2 ]
##  gap> Adjacency(g,2);
##  [ 1, 3 ]
##  \endexample
##  
DeclareOperation("Adjacency",[Graphs,IsInt]);

############################################################################
##
#O  Adjacencies( <G> )
##
##  Returns the adjacency lists of graph <G>.
##
##  \beginexample
##  gap> g:=PathGraph(3);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> Adjacencies(g);  
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ]
##  \endexample
##  
DeclareOperation("Adjacencies",[Graphs]);

############################################################################
##
#O  VertexDegree( <G>, <x> )
##
##  Returns the degree of vertex <x> in Graph <G>. 
##
##  \beginexample
##  gap> g:=PathGraph(3);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> VertexDegree(g,1);
##  1
##  gap> VertexDegree(g,2);
##  2
##  \endexample
##  
DeclareOperation("VertexDegree",[Graphs,IsInt]);

############################################################################
##
#O  VertexDegrees( <G> )
##
##  Returns the list of degrees of the vertices in graph <G>.
##
##  \beginexample
##  gap> g:=GemGraph;
##  Graph( Category := SimpleGraphs, Order := 5, Size := 7, Adjacencies := 
##  [ [ 2, 3, 4, 5 ], [ 1, 3 ], [ 1, 2, 4 ], [ 1, 3, 5 ], [ 1, 4 ] ] )
##  gap> VertexDegrees(g);
##  [ 4, 2, 3, 3, 2 ]
##  \endexample
##  
DeclareAttribute("VertexDegrees",Graphs);

############################################################################
##
#O  MaxDegree( <G> )
##
##  Returns the maximum degree in graph <G>.
##
##  \beginexample
##  gap> g:=GemGraph;
##  Graph( Category := SimpleGraphs, Order := 5, Size := 7, Adjacencies := 
##  [ [ 2, 3, 4, 5 ], [ 1, 3 ], [ 1, 2, 4 ], [ 1, 3, 5 ], [ 1, 4 ] ] )
##  gap> MaxDegree(g);
##  4
##  \endexample
##  
DeclareOperation("MaxDegree",[Graphs]);

############################################################################
##
#O  MinDegree( <G> )
##
##  Returns the minimum degree in graph <G>.
##  
##  \beginexample
##  gap> g:=GemGraph;
##  Graph( Category := SimpleGraphs, Order := 5, Size := 7, Adjacencies := 
##  [ [ 2, 3, 4, 5 ], [ 1, 3 ], [ 1, 2, 4 ], [ 1, 3, 5 ], [ 1, 4 ] ] )
##  gap> MinDegree(g);
##  2
##  \endexample
##  
DeclareOperation("MinDegree",[Graphs]);

############################################################################
##
#O  Edges( <G> )
##
##  Returns the list of edges of graph <G> in the case of `SimpleGraphs'.
##
##  \beginexample
##  gap> g1:=CompleteGraph(3);     
##  Graph( Category := SimpleGraphs, Order := 3, Size := 3, Adjacencies := 
##  [ [ 2, 3 ], [ 1, 3 ], [ 1, 2 ] ] )
##  gap> Edges(g1);
##  [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ]
##  \endexample
##  
##  In the case of `UndirectedGraphs', it also returns the loops. While in the 
##  other categories, `Edges' actually does not return the edges, but the loops 
##  and arrows of <G>.
##
##  \beginexample
##  gap> g2:=CompleteGraph(3:GraphCategory:=UndirectedGraphs);
##  Graph( Category := UndirectedGraphs, Order := 3, Size := 6, Adjacencies := 
##  [ [ 1, 2, 3 ], [ 1, 2, 3 ], [ 1, 2, 3 ] ] )
##  gap> Edges(g2);
##  [ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 2 ], [ 2, 3 ], [ 3, 3 ] ]
##  gap> g3:=CompleteGraph(3:GraphCategory:=Graphs);          
##  Graph( Category := Graphs, Order := 3, Size := 9, Adjacencies := 
##  [ [ 1, 2, 3 ], [ 1, 2, 3 ], [ 1, 2, 3 ] ] )
##  gap> Edges(g3);                                 
##  [ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ], [ 3, 1 ], 
##    [ 3, 2 ], [ 3, 3 ] ]
##  \endexample
##
DeclareOperation("Edges",[Graphs]);

##  
##  Functions to create graphs:
##
############################################################################
##
#O  Graph( <Rec> )
##
##  Returns a new graph created from the record <Rec>. The record must provide the field <Category> 
##  and either the field <Adjacencies> or the field <AdjMatrix>.
##  
##  \beginexample
##  gap> Graph(rec(Category:=SimpleGraphs,Adjacencies:=[[2],[1]]));
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := [ [ 2 ], [ 1 ] ] )
##  gap> Graph(rec(Category:=SimpleGraphs,AdjMatrix:=[[false, true],[true, false]]));
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := [ [ 2 ], [ 1 ] ] )
##  \endexample
##  
##  Its main purpose is to import graphs from files, which could have been 
##  previously exported using `PrintTo'.
##  
##  \beginexample
##  gap> g:=CycleGraph(4);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##  [ [ 2, 4 ], [ 1, 3 ], [ 2, 4 ], [ 1, 3 ] ] )
##  gap> PrintTo("aux.g","h1:=",g,";");
##  gap> Read("aux.g");
##  gap> h1;
##  Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##  [ [ 2, 4 ], [ 1, 3 ], [ 2, 4 ], [ 1, 3 ] ] )
##  \endexample
##  
DeclareOperation("Graph",[IsRecord]);

############################################################################
##
#F  GraphByAdjMatrix( <Mat> )
##  
##  Returns a new graph created from an adjacency matrix <Mat>. The matrix <Mat> must
##  be a square boolean matrix.
##  
##  \beginexample
##  gap> m:=[ [ false, true, false ], [ true, false, true ], [ false, true, false ] ];;
##  gap> g:=GraphByAdjMatrix(m);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> AdjMatrix(g);
##  [ [ false, true, false ], [ true, false, true ], [ false, true, false ] ]
##  \endexample
##  
##  Note, however, that the graph is forced to comply with the `TargetGraphCategory'.
##  
##  \beginexample
##  gap> m:=[ [ true, true], [ false, false ] ];;
##  gap> g:=GraphByAdjMatrix(m);                
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := [ [ 2 ], [ 1 ] ] )
##  gap> AdjMatrix(g);                          
##  [ [ false, true ], [ true, false ] ]
##  \endexample
##  
DeclareGlobalFunction("GraphByAdjMatrix");

############################################################################
##
#F  GraphByAdjacencies( <AdjList> )
##
##  Returns a new graph having <AdjList> as its list of adjacencies. The order of the created graph is 
##  `Length(A)', and the set of neighbors of vertex <x> is $A[x]$. 
##  
##  \beginexample
##  gap> GraphByAdjacencies([[2],[1,3],[2]]);      
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  \endexample
##  
##  Note, however, that the graph is forced to comply with the `TargetGraphCategory'.
##  
##  \beginexample
##  gap> GraphByAdjacencies([[1,2,3],[],[]]);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2, 3 ], [ 1 ], [ 1 ] ] )
##  \endexample
##  
DeclareGlobalFunction("GraphByAdjacencies");

############################################################################
##
#F  GraphByCompleteCover( <Cover> )
##
##  Returns the minimal graph where the elements of <Cover> are 
##  (the vertex sets of) complete subgraphs.
##
##  \beginexample
##  gap> GraphByCompleteCover([[1,2,3,4],[4,6,7]]); 
##  Graph( Category := SimpleGraphs, Order := 7, Size := 9, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3, 6, 7 ], [  ], [ 4, 7 ], 
##    [ 4, 6 ] ] )
##  \endexample
##  
DeclareGlobalFunction("GraphByCompleteCover");

############################################################################
##
#F  GraphByRelation( <V>, <Rel> )
#F  GraphByRelation( <n>, <Rel> )
##
##  Returns a new graph created from a set of vertices <V> and a binary relation <Rel>, 
##  where $x\sim y$ iff `<Rel>(x,y)=true'. In the second form, <n> is an integer
##  and $V$ is assumed to be $\{1, 2, \ldots, n\}$.
##
##  \beginexample
##  gap> Rel:=function(x,y) return Intersection(x,y)<>[]; end;;          
##  gap> GraphByRelation([[1,2,3],[3,4,5],[5,6,7]],Rel);               
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> GraphByRelation(8,function(x,y) return AbsInt(x-y)<=2; end); 
##  Graph( Category := SimpleGraphs, Order := 8, Size := 13, Adjacencies := 
##  [ [ 2, 3 ], [ 1, 3, 4 ], [ 1, 2, 4, 5 ], [ 2, 3, 5, 6 ], [ 3, 4, 6, 7 ], 
##    [ 4, 5, 7, 8 ], [ 5, 6, 8 ], [ 6, 7 ] ] )
##  \endexample
##
DeclareGlobalFunction("GraphByRelation");

############################################################################
##
#F  GraphByWalks( <Walk1>, <Walk2>,...)
##
##  Returns the minimal graph such that <Walk1>, <Walk2>, etc are Walks.
##
##  \beginexample
##  gap> GraphByWalks([1,2,3,4,1],[1,5,6]);
##  Graph( Category := SimpleGraphs, Order := 6, Size := 6, Adjacencies := 
##  [ [ 2, 4, 5 ], [ 1, 3 ], [ 2, 4 ], [ 1, 3 ], [ 1, 6 ], [ 5 ] ] )
##  \endexample
## 
##  Walks can be <nested>, which greatly improves the versatility of this function.
##   
##  \beginexample
##  gap> GraphByWalks([1,[2,3,4],5],[5,6]);
##  Graph( Category := SimpleGraphs, Order := 6, Size := 9, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 5 ], [ 1, 2, 4, 5 ], [ 1, 3, 5 ], [ 2, 3, 4, 6 ], [ 5 ] ] )
##  \endexample
##  
##  The vertices in the constructed graph range from 1 to the maximum of the numbers
##  appearing in <Walk1>, <Walk2>, ... etc.
##
##  \beginexample
##  gap> GraphByWalks([4,2],[3,6]);
##  Graph( Category := SimpleGraphs, Order := 6, Size := 2, Adjacencies := 
##  [ [  ], [ 4 ], [ 6 ], [ 2 ], [  ], [ 3 ] ] )
##  \endexample
##
DeclareGlobalFunction("GraphByWalks");

############################################################################
##
#F  GraphByEdges( <L> )
##
##  Returns the minimal graph such that the pairs in <L> are edges.
##
##  \beginexample
##  gap> GraphByEdges([[1,2],[1,3],[1,4],[4,5]]);
##  Graph( Category := SimpleGraphs, Order := 5, Size := 4, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1 ], [ 1 ], [ 1, 5 ], [ 4 ] ] )
##  \endexample
##  
##  The vertices of the constructed graph range from 1 to the maximum of the
##  numbers appearing in <L>.
##  
##  \beginexample
##  gap> GraphByEdges([[4,3],[4,5]]);
##  Graph( Category := SimpleGraphs, Order := 5, Size := 2, Adjacencies := 
##  [ [  ], [  ], [ 4 ], [ 3, 5 ], [ 4 ] ] )
##  \endexample
##
##  Note that `GraphByWalks' has an even greater functionality.
##
DeclareGlobalFunction("GraphByEdges");

############################################################################
##
#F  IntersectionGraph( <L> )
##
##  Returns the intersection graph of the family of sets <L>. This graph has a 
##  vertex for every set in <L>, and two such vertices are adjacent iff the 
##  corresponding sets have non-empty intersection.
##  
##  \beginexample
##  gap> IntersectionGraph([[1,2,3],[3,4,5],[5,6,7]]);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  \endexample
##
DeclareGlobalFunction("IntersectionGraph");
## #FIXME: Include GraphByEdges?

##
##  New graphs from old graphs:
##
############################################################################
##
#O  CopyGraph( <G> ) 
##
##  Returns a fresh copy of graph <G>. Only the order and adjacency information is copied, 
##  all other known attributes of <G> are not. Mainly used to transform a graph from one category 
##  to another. The new graph will be forced to comply with the `TargetGraphCategory'.
##
##  \beginexample
##  gap> g:=CompleteGraph(4);                         
##  Graph( Category := SimpleGraphs, Order := 4, Size := 6, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] )
##  gap> g1:=CopyGraph(g:GraphCategory:=OrientedGraphs);
##  Graph( Category := OrientedGraphs, Order := 4, Size := 6, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 3, 4 ], [ 4 ], [  ] ] )
##  gap> CopyGraph(g1:GraphCategory:=SimpleGraphs);     
##  Graph( Category := SimpleGraphs, Order := 4, Size := 6, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] )
##  \endexample
##  
DeclareOperation("CopyGraph",[Graphs]); 

############################################################################
##
#O  InducedSubgraph( <G>, <V> )
##
##  Returns the subgraph of graph <G> induced by the vertex set <V>.
##  
##  \beginexample
##  gap> g:=CycleGraph(6);          
##  Graph( Category := SimpleGraphs, Order := 6, Size := 6, Adjacencies := 
##  [ [ 2, 6 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 4, 6 ], [ 1, 5 ] ] )
##  gap> InducedSubgraph(g,[3,4,6]);  
##  Graph( Category := SimpleGraphs, Order := 3, Size := 1, Adjacencies := 
##  [ [ 2 ], [ 1 ], [  ] ] )
##  \endexample
##
##  The order of the elements in <V> does matter.
##
##  \beginexample
##  gap> InducedSubgraph(g,[6,3,4]);  
##  Graph( Category := SimpleGraphs, Order := 3, Size := 1, Adjacencies := 
##  [ [  ], [ 3 ], [ 2 ] ] )
##  \endexample
##
DeclareOperation("InducedSubgraph",[Graphs,IsList]);

############################################################################
##
#O  AddVerticesByAdjacencies( <G>, <NewAdjList> )
##
##  Returns a new graph created from graph <G> by adding as many new vertices 
##  as `Length(<NewAdjList>)'. Each entry in <NewAdjList> is also a list: the list  
##  of neighbors of the corresponding new vertex.
##
##  \beginexample
##  gap> g:=PathGraph(5);
##  Graph( Category := SimpleGraphs, Order := 5, Size := 4, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 4 ] ] )
##  gap> AddVerticesByAdjacencies(g,[[1,2],[4,5]]); 
##  Graph( Category := SimpleGraphs, Order := 7, Size := 8, Adjacencies := 
##  [ [ 2, 6 ], [ 1, 3, 6 ], [ 2, 4 ], [ 3, 5, 7 ], [ 4, 7 ], [ 1, 2 ], [ 4, 5 ] ] )
##  gap> AddVerticesByAdjacencies(g,[[1,2,7],[4,5]]);
##  Graph( Category := SimpleGraphs, Order := 7, Size := 9, Adjacencies := 
##  [ [ 2, 6 ], [ 1, 3, 6 ], [ 2, 4 ], [ 3, 5, 7 ], [ 4, 7 ], [ 1, 2, 7 ], [ 4, 5, 6 ] ] )
##  \endexample
##  
DeclareOperation("AddVerticesByAdjacencies",[Graphs,IsList]);

############################################################################
##
#O  RemoveVertices( <G>, <V> )
##
##  Returns a new graph created from graph <G> by removing the vertices in list <V>.
##
##  \beginexample
##  gap> g:=PathGraph(5);
##  Graph( Category := SimpleGraphs, Order := 5, Size := 4, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 4 ] ] )
##  gap> RemoveVertices(g,[3]);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1 ], [ 4 ], [ 3 ] ] )
##  gap> RemoveVertices(g,[1,3]);
##  Graph( Category := SimpleGraphs, Order := 3, Size := 1, Adjacencies := 
##  [ [  ], [ 3 ], [ 2 ] ] )
##  \endexample
##  
DeclareOperation("RemoveVertices",[Graphs,IsList]);

############################################################################
##
#O  AddEdges( <G>, <E> )
##
##  Returns a new graph created from graph <G> by adding the edges in list <E>.
##
##  \beginexample
##  gap> g:=CycleGraph(4);   
##  Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##  [ [ 2, 4 ], [ 1, 3 ], [ 2, 4 ], [ 1, 3 ] ] )
##  gap> AddEdges(g,[[1,3]]);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 5, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3 ], [ 1, 2, 4 ], [ 1, 3 ] ] )
##  gap> AddEdges(g,[[1,3],[2,4]]);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 6, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] )
##  \endexample
##  
DeclareOperation("AddEdges",[Graphs,IsList]);

############################################################################
##
#O  RemoveEdges( <G>, <E> )
##
##  Returns a new graph created from graph <G> by removing the edges in list <E>.
##
##  \beginexample
##  gap> g:=CompleteGraph(4);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 6, Adjacencies := 
##  [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] )
##  gap> RemoveEdges(g,[[1,2]]);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 5, Adjacencies := 
##  [ [ 3, 4 ], [ 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ] )
##  gap> RemoveEdges(g,[[1,2],[3,4]]);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##  [ [ 3, 4 ], [ 3, 4 ], [ 1, 2 ], [ 1, 2 ] ] )
##  \endexample
##  
DeclareOperation("RemoveEdges",[Graphs,IsList]);

## #FIXME: Include AddComplete, AddAdjacencies?

## FIXME: Be more explicit.
############################################################################
##
#A  ConnectedComponents( <G> )
##
##  Returns the connected components of <G>.
##
DeclareAttribute("ConnectedComponents",Graphs);

## FIXME: Be more explicit.
############################################################################
##
#A  NumberOfConnectedComponents( <G> )
##
##  Returns the number of connected components of <G>.
##
DeclareAttribute("NumberOfConnectedComponents",Graphs);

## FIXME: Be more explicit.
############################################################################
##
#O  SpanningForestEdges( <G> )
##
##  Returns the edges of a spanning forest of <G>.
##
DeclareOperation("SpanningForestEdges",[Graphs]);

## FIXME: Be more explicit.
############################################################################
##
#O  SpanningForest( <G> )
##
##  Returns a spanning forest of <G>.
##
DeclareOperation("SpanningForest",[Graphs]);

############################################################################
##
#O  Link( <G>, <x> )
##
##  Returns the subgraph of <G> induced by the neighbors of <x>.
##
##  \beginexample
##  gap> Link(SnubDisphenoid,1);
##  Graph( Category := SimpleGraphs, Order := 5, Size := 5, Adjacencies := 
##  [ [ 2, 5 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 4 ] ] )
##  gap> Link(SnubDisphenoid,3);
##  Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##  [ [ 2, 3 ], [ 1, 4 ], [ 1, 4 ], [ 2, 3 ] ] )
##  \endexample
##  
DeclareOperation("Link",[Graphs, IsInt]);

############################################################################
##
#A  Links( <G> )
##
##  Returns the list of subgraphs of <G> induced by the neighbors of each vertex of <G>.
##
##  \beginexample
##  gap> Links(SnubDisphenoid); 
##  [ Graph( Category := SimpleGraphs, Order := 5, Size := 5, Adjacencies := 
##      [ [ 2, 5 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 4 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 5, Size := 5, Adjacencies := 
##      [ [ 2, 5 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 4 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##      [ [ 2, 3 ], [ 1, 4 ], [ 1, 4 ], [ 2, 3 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##      [ [ 2, 3 ], [ 1, 4 ], [ 1, 4 ], [ 2, 3 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 5, Size := 5, Adjacencies := 
##      [ [ 2, 5 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 4 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 5, Size := 5, Adjacencies := 
##      [ [ 2, 5 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 4 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##      [ [ 3, 4 ], [ 3, 4 ], [ 1, 2 ], [ 1, 2 ] ] ), 
##    Graph( Category := SimpleGraphs, Order := 4, Size := 4, Adjacencies := 
##      [ [ 2, 3 ], [ 1, 4 ], [ 1, 4 ], [ 2, 3 ] ] ) ]
##  \endexample
##  
DeclareAttribute("Links",Graphs);

############################################################################
##
#A  DominatedVertices( <G> )
##
##  Returns the set of dominated vertices of <G>. 
##  
##  A vertex <x> is dominated by another vertex <y> when the closed neighborhood
##  of <x> is contained in that of <y>. However, when there are twin vertices 
##  (mutually dominated vertices), exactly one of them (in each equivalent class 
##  of mutually dominated vertices) does not appear in the returned set.
##
##  \beginexample
##  gap> g1:=PathGraph(3);     
##  Graph( Category := SimpleGraphs, Order := 3, Size := 2, Adjacencies := 
##  [ [ 2 ], [ 1, 3 ], [ 2 ] ] )
##  gap> DominatedVertices(g1);
##  [ 1, 3 ]
##  gap> g2:=PathGraph(2);
##  Graph( Category := SimpleGraphs, Order := 2, Size := 1, Adjacencies := 
##  [ [ 2 ], [ 1 ] ] )
##  gap> DominatedVertices(g2);
##  [ 2 ]
##  \endexample
##  
DeclareAttribute("DominatedVertices",Graphs);

############################################################################
##
#F  GraphAttributeStatistics( <OrderList>, <ProbList>, <Attribute> )
##
##  Returns statistics for graph attribute <Attribute>. 
##  For each of the orders <n> in <OrderList> and for each of probability <p> in <ProbList> this 
##  function generates 100 random graphs of order <n> and edge probability <p> and then evaluates 
##  the graph attribute <Attribute> on each of them. The function then return statistical data on 
##  these experiments. The form in which the statistical data is reported depend on a number of 
##  issues and is best explained by examples. 
##  
##  First let us consider the case where <Attribute> is a Boolean attribute 
##  (always returns `true' or `false') and where <OrderList> and <ProbList> consist of a 
##  unique value. In this case, the respective lists may be replaced by the corresponding 
##  unique values on invocation: 
##  
##  \beginexample|unstableoutput
##  gap> GraphAttributeStatistics(10,1/2,IsCliqueHelly);
##  43
##  \endexample
##  
##  This tells us that 43 of the 100 examined random graphs resulted to be clique-Helly;
##  The random sample was constructed using graphs of order 10 and edge probability 1/2.
##  
##  Now we can specify a list of probabilities to be examined:
##  
##  \beginexample|unstableoutput
##  gap> GraphAttributeStatistics(10,1/10*[1..9],IsCliqueHelly);
##  [ 100, 100, 95, 77, 36, 22, 41, 72, 97 ]
##  \endexample
##  
##  The last example tells us that, for graphs on 10 vertices, the property IsCliqueHelly 
##  is least probable to be true for graphs with edge probabilities 5/10 6/10 and 7/10, being 
##  6/10 the probability that reaches the minimum in the random sample. Note that 
##  the 36 in the previous example does not match the 43 in the first one, this is to be 
##  expected as the statistics are compiled from a random sample of graphs. Also, 
##  note that in the previous example, 900 random graphs where generated and examined.
##   
##  We can also specify a list of orders to consider:
##  
##  \beginexample|unstableoutput
##  gap> GraphAttributeStatistics([10,12..20],1/10*[1..9],IsCliqueHelly);
##  [ [ 100, 100, 91, 63, 30, 23, 39, 65, 99 ], [ 100, 98, 81, 35, 4, 2, 20, 63, 98 ]
##      , [ 100, 95, 49, 15, 1, 2, 13, 51, 98 ], [ 99, 82, 39, 3, 0, 2, 9, 42, 97 ], 
##    [ 100, 86, 15, 0, 0, 0, 7, 32, 93 ], [ 100, 69, 5, 0, 0, 0, 3, 24, 90 ] ]
##  gap> Display(last);
##  [ [  100,  100,   91,   63,   30,   23,   39,   65,   99 ],
##    [  100,   98,   81,   35,    4,    2,   20,   63,   98 ],
##    [  100,   95,   49,   15,    1,    2,   13,   51,   98 ],
##    [   99,   82,   39,    3,    0,    2,    9,   42,   97 ],
##    [  100,   86,   15,    0,    0,    0,    7,   32,   93 ],
##    [  100,   69,    5,    0,    0,    0,    3,   24,   90 ] ]
##  \endexample
##  
##  Which tell us that the observed bimodal distribution is even more pronounced when the order 
##  of the graphs considered grows.
##  
##  In the case of a non-Boolean attribute `GraphAttributeStatistics()' 
##  reports the values that <Attribute> took on the sample as well as the number of times 
##  that each of these values where obtained:
##  
##  \beginexample|unstableoutput
##  gap> GraphAttributeStatistics(10,1/2,Diameter);     
##  [ [ 2, 26 ], [ 3, 60 ], [ 4, 8 ], [ 6, 1 ], [ infinity, 5 ] ]
##  \endexample
##  
##  The returned statistics mean that among the 100 generated random 
##  graphs on 10 vertices with edge probability 1/2, there were 26 graphs with diameter 2, 
##  60 graphs of diameter 3, 8 of 4, 1 of 6 and 5 graphs which are not connected.
##  
##  Now it should be evident the format of the returned statistics
##  when we specify a list of probabilities and/or a list of orders to be 
##  considered for a non-Boolean Attribute:
##  
##  \beginexample|unstableoutput
##  gap> GraphAttributeStatistics(10,1/5*[1..4],Diameter);         
##  [ [ [ 3, 3 ], [ 4, 5 ], [ 5, 9 ], [ 6, 3 ], [ 7, 2 ], [ infinity, 78 ] ], 
##    [ [ 2, 8 ], [ 3, 55 ], [ 4, 19 ], [ 5, 3 ], [ infinity, 15 ] ], 
##    [ [ 2, 73 ], [ 3, 26 ], [ 4, 1 ] ], [ [ 2, 100 ] ] ]
##  gap> GraphAttributeStatistics([10,12,14],1/5*[1..4],Diameter);
##  [ [ [ [ 4, 8 ], [ 5, 7 ], [ 6, 3 ], [ infinity, 82 ] ], 
##        [ [ 2, 3 ], [ 3, 64 ], [ 4, 15 ], [ 5, 3 ], [ infinity, 15 ] ], 
##        [ [ 2, 69 ], [ 3, 30 ], [ infinity, 1 ] ], [ [ 2, 100 ] ] ], 
##    [ [ [ 3, 1 ], [ 4, 11 ], [ 5, 13 ], [ 6, 7 ], [ 7, 3 ], [ 8, 2 ], 
##            [ infinity, 63 ] ], 
##        [ [ 2, 8 ], [ 3, 69 ], [ 4, 18 ], [ 5, 2 ], [ infinity, 3 ] ], 
##        [ [ 2, 79 ], [ 3, 21 ] ], [ [ 2, 100 ] ] ], 
##    [ [ [ 3, 1 ], [ 4, 15 ], [ 5, 13 ], [ 6, 5 ], [ 7, 4 ], [ 8, 3 ], 
##            [ infinity, 59 ] ], [ [ 2, 6 ], [ 3, 82 ], [ 4, 9 ], [ infinity, 3 ] ],
##        [ [ 2, 86 ], [ 3, 14 ] ], [ [ 2, 100 ] ] ] ]
##  \endexample
##  
DeclareGlobalFunction("GraphAttributeStatistics");

#E





