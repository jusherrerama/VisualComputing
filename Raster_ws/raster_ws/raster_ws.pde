import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint; 
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    rdrawTriangle(); 
}



// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;
float step3 = 0.5;
float step = 0.5;
float step2 = 0.1;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;  

String renderer = P3D;

void setup() {
  size(800, 700, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  rdrawTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

void triangleRaster() {
    pushStyle();
    stroke(0, 255, 0);
    point(round(v1.x()), round(v1.y()));
    stroke(0, 0, 255);
    point(round(v2.x()), round(v2.y()));
    stroke(255, 0, 0);
    point(round(v3.x()), round(v3.y()));
    popStyle();
     
    point(v1.x(), v1.y());
    point(v2.x(), v2.y());
    point(v3.x(), v3.y());
  Vector pv1 = new Vector(v1.x(), v1.y() );  
  Vector pv2 = new Vector(v2.x(), v2.y());  
  Vector pv3 =  new Vector(v3.x(), v3.y());   
  int[] dims = dimentions();
  strokeWeight(0);
  float[] counter = {0,0};
  float[] colorAVG = {0,0,0}; 
  
  for(counter[0] = dims[2]; counter[0]<= dims[0]; counter[0]+=step){
     for(counter[1] = dims[3]; counter[1]<= dims[1]; counter[1]+=step){      
             colorAVG = baricentric(pv1,pv2,pv3,counter);
             tint(255, 126);
             fill(color(round(255*colorAVG[0]), round(255*colorAVG[1]), round(255*colorAVG[2]))   );
            rect(counter[0],counter[1], step, step);  
       }  
     }
    }

int[] dimentions(){
  int[] dim ={0,0,0,0}; 
  dim[0] = round(max(v1.x(), (v2).x(), (v3).x())); 
  dim[1] = round(max(v1.y(), (v2).y(), (v3).y())); 
  dim[2] = round(min(v1.x(), (v2).x(), (v3).x())); 
  dim[3] = round(min((v1).y(), (v2).y(),(v3).y())); 
  return dim;
}


int  matrixDet(Vector a, Vector b, Vector c){
   return round(((b.x() - a.x())*(c.y() - a.y())) - ((b.y() - a.y())*(c.x() - a.x())));
}
float distance(Vector v1, Vector v2,float[] p){
  return ((v1.y()- v2.y())* p[0]) + ((v2.x()-v1.x())*p[1]) + (v1.x()+v2.y() - v2.x()*v1.y());
}
float[] baricentric(Vector pv1, Vector pv2, Vector pv3, float[] p){
  float[] results = {0.0,0.0, 0.0};
  float[] temp1 = {pv1.x(),pv1.y()};
  float[] temp2 = {pv2.x(),pv2.y()};
  float[] temp3 = {pv3.x(),pv3.y()};
  results[0] = distance(pv1, pv2, p) / distance(pv1,pv2, temp3);
  results[1] = distance(pv2, pv3, p) / distance(pv2,pv3, temp1);
  results[2] = distance(pv3, pv1, p) / distance(pv3,pv1, temp2);
  return results;
}
void rdrawTriangle() {
  int low =  -width / 2;
  int high =  width / 2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  Vector pv1 = new Vector(v1.x(), v1.y() );  
  Vector pv2 = new Vector(v2.x(), v2.y());  
  Vector pv3 =  new Vector(v3.x(), v3.y()); 
  
  if (matrixDet(pv1,pv2,pv3) <= 0){
    rdrawTriangle();
  }
}
void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}
void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Vector(0, 0, 1), PI / 100);
  else
    scene.eye().rotate(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
}
