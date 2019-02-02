///////7CURVA DE HERMIT


int representation = 0;
int retainedMode = 0;



/**
 * Flock o f Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
Interpolator interpolator;
//flock bounding box
static int flockWidth = 1280;
static int flockHeight = 720;
static int flockDepth = 600;
static boolean avoidWalls = true ;





int initBoidNum = 120; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;


void setup() {
  
  size(1000, 700, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
  
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
    
    
    
  interpolator =  new Interpolator(scene);
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();
  
  
  pushStyle();
 
  if( i ){ 
    strokeWeight(2);
  stroke(255,0,0);
  
  scene.drawPath(interpolator);
  }
  
  if( z ){ 
  strokeWeight(2);
  stroke(0,255,0);
   
  noFill();
    if( frs.length > 0){
    beginShape();
    
    vertex(frs[0].position().x(),frs[0].position().y(),frs[0].position().z());
    
  int c = 0;
 for (int i= 0;i< frs.length;i= i +3){
     c = (i+3)-frs.length;
     if ( c > 0 ){
        if ( c == 2){
           bezierVertex(frs[i].position().x(),frs[i].position().y(),frs[i].position().z(),frs[i].position().x(),frs[i].position().y(),frs[i].position().z(),frs[i].position().x(),frs[i].position().y(),frs[i].position().z());
         
        }
        if ( c == 1){
         bezierVertex(frs[i].position().x(),frs[i].position().y(),frs[i].position().z(),frs[i+1].position().x(),frs[i+1].position().y(),frs[i+1].position().z(),frs[i+1].position().x(),frs[i+1].position().y(),frs[i+1].position().z());
         
        
        }  
     }else{
       bezierVertex(frs[i].position().x(),frs[i].position().y(),frs[i].position().z(),frs[i+1].position().x(),frs[i+1].position().y(),frs[i+1].position().z(),frs[i+2].position().x(),frs[i+2].position().y(),frs[i+2].position().z());
         
          
     }
     
   }
   
  endShape();
  println(); 
    }
  }
  if(b){
      bezier3( frs[0].position().x(),frs[0].position().y(),frs[0].position().z(), frs[1].position().x(),frs[1].position().y(),frs[1].position().z(), frs[2].position().x(),frs[2].position().y(),frs[2].position().z(), frs[3].position().x(),frs[3].position().y(),frs[3].position().z());  
    }
  
  if(b7){
      bezier7( frs[0].position().x(),frs[0].position().y(),frs[0].position().z(), frs[1].position().x(),frs[1].position().y(),frs[1].position().z(), frs[2].position().x(),frs[2].position().y(),frs[2].position().z(), frs[3].position().x(),frs[3].position().y(),frs[3].position().z()
      ,frs[4].position().x(),frs[4].position().y(),frs[4].position().z(), frs[5].position().x(),frs[5].position().y(),frs[5].position().z(), frs[6].position().x(),frs[6].position().y(),frs[6].position().z(), frs[7].position().x(),frs[7].position().y(),frs[7].position().z());  
    } 
  if(h){
      hetmit( frs[0].position().x(),frs[0].position().y(),frs[0].position().z(), frs[1].position().x(),frs[1].position().y(),frs[1].position().z(), frs[2].position().x(),frs[2].position().y(),frs[2].position().z(), frs[3].position().x(),frs[3].position().y(),frs[3].position().z());  
    }
    
  
  popStyle();
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  
   
}

  
void bezier7( float px1,float py1,float pz1,float px2,float py2,float pz2,float px3,float py3,float pz3,float px4,float py4,float pz4,float px5,float py5,float pz5,float px6,float py6,float pz6,float px7,float py7,float pz7,float px8,float py8,float pz8)
      { 
          float step = 0.001;
        for( float u = 0; u < 1; u = u + step ){          
        float b07 = pow(  1-u, 7) ;         
        float b17 =  7*pow(  u, 1)*pow(  1-u, 6) ;
        float b27 = 21*pow(  u, 2)*pow(  1-u, 5) ;
        float b37 = 35*pow(  u, 3)*pow(  1-u, 4) ;
        float b47 = 35*pow(  u, 4)*pow(  1-u, 3) ;    
        float b57 = 21*pow(  u, 5)*pow(  1-u, 2) ;
        float b67 = 7*pow(  u, 6)*pow(  1-u, 1) ;
        float b77 = pow(  u, 7) ;       
         
         float x =  (px1 * b07) + (px2 * b17) + (px3 * b27) + (px4 * b37) + (px5 * b47)+ (px6 * b57)+ (px7 * b67)+ (px8 * b77); 
         float y =  (py1 * b07) + (py2 * b17) + (py3 * b27) + (py4 * b37) + (py5 * b47)+ (py6 * b57)+ (py7 * b67)+ (py8 * b77); 
         float z =  (pz1 * b07) + (pz2 * b17) + (pz3 * b27) + (pz4 * b37) + (pz5 * b47)+ (pz6 * b57)+ (pz7 * b67)+ (pz8 * b77);          
      
  strokeWeight(2);
  stroke(255, 153, 255);
        point(x, y, z);
        }
        
                
      }
void bezier3( float px1,float py1,float pz1,float px2,float py2,float pz2,float px3,float py3,float pz3,float px4,float py4,float pz4)
      { 
        println("entra");
          float step = 0.001;
        for( float u = 0; u < 1; u = u + step ){          
        float b03 = pow(  1-u, 3) ;
        float b13 = 3*u*pow(  1-u, 2) ;
        float b23 =pow(  u, 2)*3 * (1-u);
        float b33 = pow(  u, 3) ;       
         
         float x =  (px1 * b03) + (px2 * b13) + (px3 * b23) + (px4 * b33); 
         float y =  (py1 * b03) + (py2 * b13) + (py3 * b23) + (py4 * b33); 
         float z =  (pz1 * b03) + (pz2 * b13) + (pz3 * b23) + (pz4 * b33);          
      
  strokeWeight(3);
  stroke(0,0,255);
        point(x, y, z);
        }
        
                
      }
 

void hetmit( float px1,float py1,float pz1,float px2,float py2,float pz2,float px3,float py3,float pz3,float px4,float py4,float pz4)
      { 
         float t  = 0.85;
          float s = (1-t)/2;
          
          float m1 = 0.50;
          float m2 = 0.0564;
          
          
          
          float m1x = 1/(2*(1-t)*(px3-px1));
          float m2x = 1/(2*(1-t)*(px4-px2));          
          float m1y = 1/(2*(1-t)*(py3-py1));
          float m2y = 1/(2*(1-t)*(py4-py2));                    
          float m1z = 1/(2*(1-t)*(pz3-pz1));
          float m2z = 1/(2*(1-t)*(pz4-pz2));
          
          
          float step = 0.01;
      for( float u = 0; u <= 1; u = u + step ){
     //     float x = (px1*( ( -s*pow( u, 3) )  +  ( 2*s*pow( u, 2))    - (s*u)   ))   +   (px2*( ( (2-s)*pow( u, 3) )  +  ( (s-3)*pow( u, 2))  + 1 ) )     +  (  px3*(  ((s-2)* pow( u, 3))   +  ( (3-2)*pow( u, 2))    + (u*s)   ))  +  (px4*( (s* pow( u, 3) )  -  ( s*pow( u, 2))      ))     ;
    //float y = (py1*( ( -s*pow( u, 3) )  +  ( 2*s*pow( u, 2))    - (s*u)   ))   +   (py2*( ( (2-s)*pow( u, 3) )  +  ( (s-3)*pow( u, 2))  + 1 ) )     +  (  py3*(  ((s-2)* pow( u, 3))   +  ( (3-2)*pow( u, 2))    + (u*s)   ))  +   (py4*( (s* pow( u, 3) )  -  ( s*pow( u, 2))      ))     ;
     //float z = (pz1*( ( -s*pow( u, 3) )  +  ( 2*s*pow( u, 2))    - (s*u)   ))   +   (pz2*( ( (2-s)*pow( u, 3) )  +  ( (s-3)*pow( u, 2))  + 1 ) )     +  (  pz3*(  ((s-2)* pow( u, 3))   +  ( (3-2)*pow( u, 2))    + (u*s)   ))  +   (pz4*( (s* pow( u, 3) )  -  ( s*pow( u, 2))      ))     ;
     
     
        float x = (px2*( ( 2*pow( u, 3) )  -  ( 3*pow( u, 2))    +1   ))   +   (px3*( ( -2*pow( u, 3) )  +  ( 3*pow( u, 2))  ))     +  (m1*( ( pow( u, 3) )  -  ( 2*pow( u, 2))    +u   ))  +  (m2*( ( pow( u, 3) )  -  ( pow( u, 2))      ))     ;
        float y = (py2*( ( 2*pow( u, 3) )  -  ( 3*pow( u, 2))    +1   ))   +   (py3*( ( -2*pow( u, 3) )  +  ( 3*pow( u, 2))  ))     +  (m1*( ( pow( u, 3) )  -  ( 2*pow( u, 2))    +u   ))  +  (m2*( ( pow( u, 3) )  -  ( pow( u, 2))      ))     ;
        float z = (pz2*( ( 2*pow( u, 3) )  -  ( 3*pow( u, 2))    +1   ))   +   (py3*( ( -2*pow( u, 3) )  +  ( 3*pow( u, 2))  ))     +  (m1*( ( pow( u, 3) )  -  ( 2*pow( u, 2))    +u   ))  +  (m2*( ( pow( u, 3) )  -  ( pow( u, 2))      ))     ;
      
  strokeWeight(2);
  stroke(255, 255, 0);
point(x, y, z);
    
  }
      }     
void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.interpolateTo(avatar);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fitBallInterpolation();
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.zoom(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}
boolean z =  false;
boolean i =  false;
boolean h =  false;
boolean b =  false;
boolean b7 =  false;
void keyPressed() {
  int index ;
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();  
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case '+':
    index = int(random(0,initBoidNum));
          
    frs  =  (Frame[]) append((frs), flock.get(index).frame );
    
    interpolator.addKeyFrame(flock.get(index).frame);
    
    
    
    break;
    
  case 'f':
    if( representation == 0)
      representation = 1;
    else
      representation = 0;
    break;
    
  case 'r':
  
    if( retainedMode == 0)
      retainedMode = 1;
    else
      retainedMode = 0; 
    break;   
  case 'i':
  
   if( i)
      i = false;
    else
      i = true; 
    break;  
  case 'z':
  
    if( z)
      z = false;
    else
      z = true; 
    break; 
  case 'h':
  
    if( h)
      h = false;
    else{
      h = true;
     //frs = null;     
     
      if(frs.length < 4){
      for( int i = 0; i < 4; i++ ){
        
          index = int(random(0,initBoidNum));
          
         interpolator.addKeyFrame(flock.get(index).frame);
          frs  =  (Frame[]) append((frs), flock.get(index).frame );
      }  
      }
  }
    break; 
  case 'b':
  
    if( b){
      b = false;}
    else{
      b = true;
     //frs = null;     
     
      if(frs.length < 4){
      for( int i = 0; i < 4; i++ ){
        
          index = int(random(0,initBoidNum));
          
         interpolator.addKeyFrame(flock.get(index).frame);
          frs  =  (Frame[]) append((frs), flock.get(index).frame );
      }  
      }
  }
    break;
    
  case '7':
  
    if( b7){
      b7 = false;}
    else{
      b7 = true;
     //frs = null;     
     
      if(frs.length < 8){
      for( int i = 0; i < 8; i++ ){
        
          index = int(random(0,initBoidNum));
          
         interpolator.addKeyFrame(flock.get(index).frame);
          frs  =  (Frame[]) append((frs), flock.get(index).frame );
      }  
      }
    }
    break;
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  }
}

Frame[] frs = { }; 
