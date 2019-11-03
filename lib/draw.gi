############################################################################
############################################################################
##
##
##  YAGS: Yet Another Graph System
##  C. Cedillo, R. MacKinney-Romero, M.A. Pizana, I.A. Robles 
##  and R. Villarroel-Flores.
##
##  Version 0.0.5
##  2013/Octubre/11
##
##  draw.gi contains the methods to interface with the external program 'draw' 
##  for human-assisted graph drawings.
##

YAGSInfo.Draw:=rec();
YAGSInfo.Draw.Colors:=rec();
YAGSInfo.Draw.Colors.fillColor:="BBBBFF";
YAGSInfo.Draw.Colors.fillHighColor:="FF4444";
if YAGSInfo.Arch=1 then #Unix (default)
   YAGSInfo.Draw.prog:=
        Concatenation(YAGSInfo.Directory,"/bin/draw/application.linux64/draw");
    YAGSInfo.Draw.opts:=[];
elif YAGSInfo.Arch=2 then # Mac OS X
  #
  #Mac binaries do not work in Mac using Linux binaries instead, which is OK.
  #
    #YAGSInfo.Draw.prog:=
    #    Concatenation(YAGSInfo.Directory,"/bin/draw/application.macosx/draw.app/Contents/MacOS/draw");
    #YAGSInfo.Draw.opts:=[];
    YAGSInfo.Draw.prog:=
        Concatenation(YAGSInfo.Directory,"/bin/draw/application.linux64/draw");
    YAGSInfo.Draw.opts:=[];
elif YAGSInfo.Arch=3 then #Windows
   YAGSInfo.Draw.prog:=
        Concatenation(YAGSInfo.Directory,"/bin/draw/application.windows64/draw.bat");
   YAGSInfo.WindowsDirectory:=SplitString(YAGSInfo.Directory,"","/");
   while YAGSInfo.WindowsDirectory[1] <> "cygdrive" do 
      Remove(YAGSInfo.WindowsDirectory,1);
   od;
   Remove(YAGSInfo.WindowsDirectory,1);  
   if Length(YAGSInfo.WindowsDirectory)<1 then 
      Print("#I YAGS: Draw() subsystem may not work:\n");
      Print("#I YAGS: Architecture seems to be Windows, but CYGWIN configuration is unknown\n");
      YAGSInfo.Draw.opts:=[];
   else
      Add(YAGSInfo.WindowsDirectory[1],':');
      YAGSInfo.WindowsDirectory:=
         JoinStringsWithSeparator(YAGSInfo.WindowsDirectory,"\\");
      YAGSInfo.Draw.opts:=
        [Concatenation(YAGSInfo.WindowsDirectory,"\\bin\\draw\\application.windows64\\lib\\")];
   fi;
else
   Print("#I YAGS: Unknown architecture for Draw() subsystem.\n");
   Print("#I YAGS: Trying unix defaults.\n");
   YAGSInfo.Draw.prog:=
        Concatenation(YAGSInfo.Directory,"/bin/draw/application.linux64/draw");
   YAGSInfo.Draw.opts:=[];
fi;

############################################################################
##
#M  SetCoordinates(<G>,<Coord>) 
##
InstallMethod(SetCoordinates,"for graphs",true,[Graphs,IsList],0,
function(G,Coord)  
  #Minimal verification!
  #FIXME: Verify more conditions
  if Length(Coord)<>Order(G) then 
      Print("Usage: SetCoordinates(Graph,CoordinatesList);\n");
      return;
   fi;
   G!.Coordinates:=Coord;
end);

############################################################################
##
#M  Coordinates(<G>) 
##
InstallMethod(Coordinates,"for graphs",true,[Graphs],0,
function(G) 
   if IsBound(G!.Coordinates) then
      return StructuralCopy(G!.Coordinates);
   else 
      return fail; 
   fi;
end);

############################################################################
##
#M  GraphToRaw(<filename>, <G>, <HighlightedRecord> )
#M  GraphToRaw(<filename>, <G>, <Highlighted> )
#M  GraphToRaw(<filename>, <G> )
##
InstallOtherMethod(GraphToRaw,"for graphs",true,[IsString,Graphs],0,
function(filename, G)    
    GraphToRaw(filename, G, []); 
end);

InstallMethod(GraphToRaw,"for graphs",true,[IsString,Graphs,IsList],0,
function(filename,G, highlighted)   
    GraphToRaw(filename,G,rec(       
       (YAGSInfo.Draw.Colors.fillHighColor):= highlighted
    ));
end);

InstallMethod(GraphToRaw,"for graphs",true,[IsString,Graphs,IsRecord],0,
function(filename, G, highlightedRec) 
    local i,j,coord,v,colors,color,colorIndex,coloredVertices;    
    PrintTo(filename,Order(G),"\n");
    if(IsBound(G!.Coordinates)) then 
      coord:=Coordinates(G);
    else
      coord:=List([1..Order(G)],x->[Random([-100..100]),Random([-100..100])]);
    fi;
    for i in [1..Order(G)] do
      AppendTo(filename,coord[i][1], " ");
      AppendTo(filename,coord[i][2],"\n");
    od;
    for i in [1..Order(G)] do 
      for j in [1..Order(G)] do 
         if IsEdge(G,[i,j]) then
            AppendTo(filename,"1"); 
         else 
            AppendTo(filename,"0");
         fi;
      od;
      AppendTo(filename,"\n");
    od;
    #prepare colors and colored vertices
    colors:=Set(Concatenation([YAGSInfo.Draw.Colors.fillColor],RecNames(highlightedRec)));
    colorIndex:=Position(colors, YAGSInfo.Draw.Colors.fillColor);
    coloredVertices:=List([1..Order(G)],i->colorIndex);
    for colorIndex in [1..Size(colors)] do    
       color:=colors[colorIndex];   
       if IsBound(highlightedRec.(color)) then
          for v in highlightedRec.(color) do
            coloredVertices[v] := colorIndex;
          od;
       fi;
    od;
    #insert color names    
    for color in colors do 
        AppendTo(filename,color," ");       
    od;
    AppendTo(filename,"\n");
    #insert colored vertices
    coloredVertices := coloredVertices-1; #zero based index for processing
    for colorIndex in coloredVertices do 
        AppendTo(filename,colorIndex," ");       
    od;
    AppendTo(filename,"\n");
end);

############################################################################
##
#M  GraphUpdateFromRaw(<filename>,<G>)
##
InstallMethod(GraphUpdateFromRaw,"for graphs",true,[IsString,Graphs],0,
function(filename, G)
    local inp,str,n,i,coord,strpair;
    inp:=InputTextFile( filename );
    str:=ReadLine(inp);
    coord:=[];
    n:=Int(Chomp(str));
    for i in [1..n] do 
       str:=ReadLine(inp);
       strpair:=SplitString(str," \n");
       coord[i]:=[Int(strpair[1]),Int(strpair[2])];
    od;
    CloseStream(inp);
    SetCoordinates(G,coord);
end);

############################################################################
##
#M  Draw( <G> )
#M  Draw( <G>, <Highlighted> )
##
InstallOtherMethod(Draw,"for graphs",true,[Graphs],0,
function(G) 
    Draw(G,[]);
end);  
InstallMethod(Draw,"for graphs",true,[Graphs,IsList],0,
function(G,Highlighted)
    local filename,dir,opts;
    filename:="drawgraph.raw";
    GraphToRaw(filename,G,Highlighted);
    dir:=DirectoryCurrent();
    Process(dir,YAGSInfo.Draw.prog,InputTextNone(),OutputTextUser(),YAGSInfo.Draw.opts);
    GraphUpdateFromRaw(filename,G);
end);

#E

