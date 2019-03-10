// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/FGAwi7wpU8c

class Planet {
  float radius;
  float distance;
  Planet[] planets;
  float angle;
  float anglerot;
  float orbitspeed;
  float rotatespeed;
  float inclination;
  char type;
  PVector v;
PImage imgen;
  PShape globe;
  
  
   //  RADIO,DISTANCIA,VEL ORVITA ,VEL ROT,INCLINACION,IMAGEN 
   

  Planet(float r, float d, float o, float rot, float inc, PImage img) {

    v = PVector.random3D();
    imgen = img;
    radius = r;
    distance = d;
    v.mult(distance);
    angle = random(-6, 6);
    anglerot = 0;
    orbitspeed = o;
    rotatespeed = rot;
    inclination = inc; 
    type = 'P';
    if( rotatespeed == -1000 ){
       rotatespeed = 0.01;
       type = 'L';
       anglerot = 0.1;
    }

    noStroke();
    noFill();
    globe = createShape(SPHERE, radius);
    globe.setTexture(img);
  }

  void orbit() {
    
    angle = angle + orbitspeed;
    if(angle > 6.28319 ){
      angle = 0;
    }
    
    
    
    if(type == 'L'){
       
      if(anglerot < -0.122173 ){
        rotatespeed = 0.01; 
      }else if(anglerot > 0.122173){
        rotatespeed = -0.01; 
      }
        anglerot =anglerot + rotatespeed;
    
      
    }else{
      anglerot =anglerot + rotatespeed;
      if(anglerot > 6.28319 ){
        anglerot = 0;
      }
    }
    
    
    if (planets != null) {
      for (int i = 0; i < planets.length; i++) {
        planets[i].orbit();
      }
    }
  }

  void spawnMoons(int total, int level) {
    planets = new Planet[total];
    for (int i = 0; i < planets.length; i++) {
      float r =  28*radius/100 / level;
      float d =  radius*(1.2) ;
      float o = -(0.03703 * ((i ) +1))/level;
      float vr = -1000;//LUNA
      float inc = random(-6, 6);
      
      int index = int(random(0,textures.length));
      planets[i] = new Planet(r,d,o ,vr,inc, moonTexture);
    
   //  RADIO,DISTANCIA,VEL ORVITA ,VEL ROT,INCLINACION,IMAGEN   
  }
    
    
  }




 
  
 
  void show() {
    pushMatrix();
    
    stroke(255); 
rotateX( inclination ); 
    strokeWeight(1);
    if(type == 'P'){
     for(float i =0 ; i <= 7 ;i = i+ 0.001  ){   
        float x  = distance * cos( i );
        float y = distance*1.5 * sin( i );      
        point(x,y,1); 
      }
        
    }
        float x  = distance * cos( angle );
        float y = distance *1.5* sin( angle );      
        

    translate(x,y, 1); 
    

           if( imgen == textures[5]){  
             stroke(112, 104, 85);
strokeWeight(5);  noFill();stroke(204, 102, 0);
ellipse(0, 0, radius*3, radius*3);
ellipse(0, 0, radius*3 -10 , radius*3 -10);
stroke(168, 158, 124);
ellipse(0, 0, radius*3 +10 , radius*3 +10);
ellipse(0, 0, radius*3 +5 , radius*3 +10);
stroke(93, 119, 130);
ellipse(0, 0, radius*3 -5 , radius*3 -5);

    strokeWeight(1);
  }

    translate(0, 0, 0);     
    rotate(anglerot );
    
    fill(255);
    shape(globe); 
   // sphere(radius);
         
 
    if (planets != null) {
      for (int i = 0; i < planets.length; i++) {
        planets[i].show();
      }
    }
    
    
    popMatrix();
  }
}
