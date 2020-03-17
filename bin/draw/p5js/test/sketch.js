
var filename = "drawgraph";
var extFilename = "raw";

var x;
var y;
var vx;
var vy;
var fx;
var fy;
var deltat=0.05;
var len=50;
var k=5;
var rep=20;
var atte=0.2;
var dynamics = false;
var repulsion = false;

var sel = -1;

var arrowposition=0.8;
var arrowangle;
var arrowlen=10.0;
var auxangle;
var arrowx;
var arrowy;

var num ;
var numHigh;
var vertexColoring={}; 
var vertexColoringSize=0;  
var edgeColoring={};
var edgeColoringSize=0;
var vars;
var adj;
var minx;
var maxx;
var miny;
var maxy;
var theScale=1;
var canvasWidth = 600; //default canvas width
var canvasHeight = 600;//default canvas height
var centerX=canvasWidth/2;
var centerY=canvasHeight/2;
var cx=centerX;
var cy=centerY;
var deltascale=1.05;
var strokeweight=1.5;
var strokewextra=8;
var radius=6;
var mradius=16;
var bgcolor="#FFFFFF";
//var helpcolor="#BBBBBB";
var helpcolor;
var fillcolor="#BBBBFF";
var fillhighcolor="#FF4444";
var circpencolor="#444444";
var linepencolor="#444444"; 
var textcolor="#000000";
var help = false;
var labels = false;
var fit=false;
var move=false;
var mx0,my0;
var helpstring=" H - toggle this help message\n F - fit graph into window\n L - toggle labels on/off\n D - toggle dynamics on/off\n R - toggle repulsion on/off\n S - save & quit\n ESC - quit without saving";

var lines;
   
function preload(){
   lines = loadStrings(filename + "." + extFilename);
   //console.log(lines);
}

function setup() {
  // put setup code here
  //in order to fill some variables with the result of some processing function, p5js requires you to fill
  //such variable here, in the setup function
  arrowangle=radians(20.0);
  helpcolor=color(187,187,187,200);


  //console.log(lines);

  var cnv = createCanvas(canvasWidth, canvasHeight);       
  cnv.mouseWheel(mouseWheelListener);
  cnv.mouseReleased(mouseReleasedListener);
  cnv.mousePressed(mousePressedListener);

  importgraph();
  fill(fillcolor);
  strokeWeight(strokeweight);
  textAlign(CENTER,CENTER);
  textSize(10);    
}

function draw() {

     background(255);          
     //rotate(PI/12);
     //translate(200,200);
     if(sel>=0){
       x[sel]=(mouseX-cx)*theScale;
       y[sel]=(mouseY-cy)*theScale;
     }
     if(move){
       cx=cx+(mouseX-mx0);mx0=mouseX;
       cy=cy+(mouseY-my0);my0=mouseY;
     }
     if(fit){
      fitgraph(); //<>//
    }
    if(dynamics){    	
       forceDynamics();
       vertexPositions();
    } 
    drawGraph();
    if(help){
      fill(helpcolor);
        rect(0,0,252,191);
      fill(textcolor);
      textAlign(LEFT,TOP);
      textSize(16);
        text(helpstring,10,10);
      fill(fillcolor);
      textAlign(CENTER,CENTER);
      textSize(10);
    }
}



function drawGraph(){
    var edgeColor;
    //edges
    for(var i=0;i<num;i++){
      for( var j=i+1;j<num;j++){
        if (adj[i][j] || adj[j][i]){          
            
            if(adj[i][j] && adj[j][i]  && edgeColoring[i + "," + j]!=null){//edge color i<->j
              edgeColor = colors[edgeColoring[i + "," + j]];
            }else if (adj[i][j] && adj[j][i]  && edgeColoring[j + "," + i]!=null){//edge color i<->j              
              edgeColor = colors[edgeColoring[j + "," + i]];
            }else if (adj[i][j] && !adj[j][i] && edgeColoring[i + "," + j]!=null){//edge color i->j
              edgeColor = colors[edgeColoring[i + "," + j]];
            }else if (adj[j][i] && !adj[i][j] && edgeColoring[j + "," + i]!=null){//edge color j->i
              edgeColor = colors[edgeColoring[j + "," + i]];
            } else {
              edgeColor = linepencolor;
            }            
            stroke(edgeColor);
            strokeWeight(strokeweight);
            // i--j (no arrows)
            line(cx+x[i]/theScale,cy+y[i]/theScale,cx+x[j]/theScale,cy+y[j]/theScale);
          if (!adj[j][i]){ // i->j
             auxangle= atan2(y[j]-y[i],x[j]-x[i]);
             arrowx= cx+(arrowposition*x[j]+(1-arrowposition)*x[i])/theScale;
             arrowy= cy+(arrowposition*y[j]+(1-arrowposition)*y[i])/theScale;
             line(arrowx,arrowy,arrowx-arrowlen*cos(auxangle-arrowangle),arrowy-arrowlen*sin(auxangle-arrowangle));
             line(arrowx,arrowy,arrowx-arrowlen*cos(auxangle+arrowangle),arrowy-arrowlen*sin(auxangle+arrowangle));
          }else if (!adj[i][j]){ // j->i
             auxangle= atan2(y[i]-y[j],x[i]-x[j]);
             arrowx= cx+(arrowposition*x[i]+(1-arrowposition)*x[j])/theScale;
             arrowy= cy+(arrowposition*y[i]+(1-arrowposition)*y[j])/theScale;
             line(arrowx,arrowy,arrowx-arrowlen*cos(auxangle-arrowangle),arrowy-arrowlen*sin(auxangle-arrowangle));
             line(arrowx,arrowy,arrowx-arrowlen*cos(auxangle+arrowangle),arrowy-arrowlen*sin(auxangle+arrowangle));
          }
        }
      }
    }
    //vertices
    stroke(circpencolor);
    for(var i=0;i<num;i++){
      if(adj[i][i]){
        noFill();
        ellipse(cx+x[i]/theScale-radius,cy+y[i]/theScale-radius,2.8284*radius,2.8284*radius); //2.8284 = 2*sqrt(2)
      }
      if(vertexColoring[i]!=null){
        fill(colors[vertexColoring[i]]);
      } else {
        fill(fillcolor);
      }
      ellipse(cx+x[i]/theScale,cy+y[i]/theScale,2*radius,2*radius);
      //labels      
      if(labels){
        fill(textcolor); 
        text(str(i+1),cx+x[i]/theScale,cy+y[i]/theScale);
      }
    }
    fill(fillcolor);
}


function mousePressedListener(){
  for(var i =0;i<num;i++){
    if( sq(mouseX-cx-x[i]/theScale) + sq(mouseY-cy-y[i]/theScale) <= 100)
      sel=i;
  }
  if(sel<0){
    move=true;
    mx0=mouseX;
    my0=mouseY;
  }
}

function mouseReleasedListener(){
  sel=-1;
  move=false;
}

function mouseWheelListener(event) {
  var scale1;
  var e = event.deltaY/50;
  
  scale1=theScale/pow(deltascale,e);
  cx=mouseX-(mouseX-cx)*(theScale/scale1);
  cy=mouseY-(mouseY-cy)*(theScale/scale1);
  theScale=scale1;

}

function forceDynamics(){
  var ffx,ffy,d,f,xp,yp;
  var i,j;
  
  for(i=0;i<num;i++){
    ffx=0;ffy=0;
    for(j=0;j<num;j++){
      if(i==j)continue;
      d=sqrt(sq(x[i]-x[j])+sq(y[i]-y[j]));
      if(d==0){
        d=1;//demasiado cerca
        xp=(i<j)?0.7071:(-0.7071);
        yp=(i<j)?0.7071:(-0.7071);
      }else{//proyecciones
        xp=(x[j]-x[i])/d;
        yp=(y[j]-y[i])/d;
      }
      if(adj[i][j] || adj[j][i]){ //resorte
        f=k*(d-len);
        ffx=ffx+f*xp;
        ffy=ffy+f*yp;
      }
      if(repulsion){ //repulsion
        ffx=ffx-rep*xp;
        ffy=ffy-rep*yp;
      }
      //resistencia
      ffx=ffx-atte*vx[i];
      ffy=ffy-atte*vy[i];
    }    
    fx[i]=ffx;
    fy[i]=ffy;
  }
}



function vertexPositions(){
  var ffx,ffy,l,t;
  var i,j;
  for(i=0;i<num;i++){
    if (i!=sel){
      vx[i]=vx[i]+fx[i]*deltat;
      vy[i]=vy[i]+fy[i]*deltat;
      x[i]=x[i]+vx[i]*deltat;
      y[i]=y[i]+vy[i]*deltat;
    }
  } 
}


function importgraph(){     
   var parts, subparts;
   num=int(lines[0]);
   x=new Array(num).fill(0); y=new Array(num).fill(0);
   fx=new Array(num).fill(0);fy=new Array(num).fill(0);
   vx=new Array(num).fill(0);vy=new Array(num).fill(0);

   adj=new Array(num).fill(0).map(() => new Array(num).fill(0));
      
   //construir coordenadas x,y
   for(var i=0;i<num;i++){     
     parts = split(lines[i+1]," ");
     x[i]=float(parts[0]);
     y[i]=float(parts[1]);
   }
   
   //construir matriz de adyacencia
   for(var i=0;i<num;i++){
     for(var j=0;j<num;j++){
       adj[i][j]=(lines[i+num+1].charAt(j)=='1');
     }
   }   
      
   //coloracion de vertices
   if(lines.length>=2*num+3){     
     //coloraciones posibles
     parts = splitTokens(lines[2*num+1]," ");
     colors=new Array(parts.length);
     for(var i=0; i<colors.length; i++){
       colors[i]="#" + parts[i];//#FF4444     
     }   
     
     //indices de coloracion para cada vertice
     parts = splitTokens(lines[2*num+2]," ");     
     for(var i=0; i<parts.length; i++){
       subparts = split(parts[i],":");
       //put(vertexNumber, index of array of Colors)
       vertexColoring[int(subparts[0])]= int(subparts[1]);       
     }
     vertexColoringSize=parts.length;
   }
   
   //coloracion de aristas
   if(lines.length>=2*num+4){
     //indices de coloracion para cada arista
     parts = splitTokens(lines[2*num+3]," ");
     for(var i=0; i<parts.length; i++){
       subparts = split(parts[i],":");
       //put(edge as string, index of array of Colors)
       edgeColoring[subparts[0]]=int(subparts[1]);
     }
     edgeColoringSize=parts.length;
   }   

   //console.log(edgeColoring);
   //console.log(vertexColoring);
   

}



function exportgraph(){  
    var parts = new Array(2).fill("");
    var bits = new Array(num).fill('');
    var lines=[];
    var index;
    //print("num:"+ num + "\n");    

    if(vertexColoringSize>0 && edgeColoringSize>0){      
      lines = new Array(2*num+4);
      //print("1 lines.length:"+ lines.length);
    } else if(vertexColoringSize>0 && edgeColoringSize==0){
      lines = new Array(2*num+3);
      //print("2 lines.length:"+ lines.length);
    } else {
       lines = new Array(2*num+1);
       //print("3 lines.length:"+ lines.length);
    }
    //print("\n vertexColoring.size():" + vertexColoring.size() + ", edgeColoring.size():" + edgeColoring.size() + "\n");
         
    lines[0]=str(num);
    //coordenadas
     for(var i=0;i<num;i++){
       parts[0]=str(int(cx+x[i]/theScale-centerX));
       parts[1]=str(int(cy+y[i]/theScale-centerY));
       lines[i+1]=join(parts," ");       
     }
     //matriz de adyacencias
     for(var i=0;i<num;i++){
       for(var j=0;j<num;j++){
         if(adj[i][j]){
           bits[j]='1';
         }else{
           bits[j]='0';
         }
       }
       lines[i+num+1]=join(bits,"");
     }    
     
     //coloracion de vertices
     if(vertexColoringSize>0){
       //print("making colors: \n");
       parts= new Array(colors.length);
       for(var i=0; i<colors.length; i++){
         parts[i]=colors[i].substring(1,colors[i].length);
       }
       lines[2*num+1]=join(parts," ");     
       
       //construccion de indices de colores para cada vertice
       parts= new Array(vertexColoringSize);
       index=0;
       for (var e in vertexColoring) {
       	 if(vertexColoring.hasOwnProperty(e)){
       	 	parts[index]=e + ":" + vertexColoring[e];
       	 	index=index+1;
       	 }
       }
       lines[2*num+2]=join(parts," ");             
     }         
     
     //coloracion de aristas     
     if(edgeColoringSize>0){
       //print("making edges: \n");
       //construccion de indices de colores para cada arista
       parts= new Array(edgeColoringSize);
       index=0;       
       for (var e in edgeColoring) {         
       	 if(edgeColoring.hasOwnProperty(e)){
            parts[index]=e + ":" + edgeColoring[e];         
            index=index+1;
         }
       }
       lines[2*num+3]=join(parts," ");
     } 
     //print("saving \n");
     //console.log(lines);
     saveStrings(lines,filename,extFilename);
}


function fitgraph(){
     var l,mx,my;
     if(num<=0){
     }else if(num==1){
       cx=centerX-x[0]/theScale;
       cy=centerY-y[0]/theScale;
     }else{ //<>//
       minx= 1000000; //<>//
       maxx=-1000000;
       miny= 1000000;
       maxy=-1000000;
       for(var i=0;i<num;i++){
         minx=min(x[i],minx);
         miny=min(y[i],miny);
         maxx=max(x[i],maxx);
         maxy=max(y[i],maxy);
       }
       l=max(maxy-miny,maxx-minx);
       theScale=l/(width*0.8);
       mx=minx+(maxx-minx)/2;
       my=miny+(maxy-miny)/2;
       cx=centerX-mx/theScale;
       cy=centerY-my/theScale;
     }
     fit=false;
}


function keyReleased(){
   switch(key){
      case 'd':
      case 'D':
        dynamics=!dynamics;
         break;
      case 'l':
      case 'L':
        labels=!labels;
        radius=mradius-radius;
        break;
      case 'f':
      case 'F':
        fit=true;
        break;
      case 'r':
      case 'R':
        repulsion=!repulsion;
        break;
      case 'h':
      case 'H':
        help=!help;
        break;
      case 's':
      case 'S':
        exportgraph();
        break;
   } 
}
