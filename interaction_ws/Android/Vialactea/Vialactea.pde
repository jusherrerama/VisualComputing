
import ketai.sensors.*;

  KetaiSensor sensor;
import peasy.*;

float accelerometerX, accelerometerY, accelerometerZ;

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

//PLANETS 
Planet sun;
Planet Mercury;
Planet Venus;
Planet Earth;
Planet Mars;
Planet Jupiter;
Planet Saturn;
Planet Uranus;
Planet Neptune;
Planet Pluto; 

//RADIO KM
//float  sun_rad =432450 ;
float  sun_rad =432450 ;
float  Mercury_rad = 2440;
float  Venus_rad =6052 ;
float  Earth_rad =6378 ;
float  Mars_rad =3397 ;
float  Jupiter_rad =71492 ;
float  Saturn_rad =60268 ;
float  Uranus_rad =25559 ;
float  Neptune_rad =24746 ;
float  Pluto_rad =51160 ;

//Distancia KM 
float  sun_dis =0 ;
float  Mercury_dis = 57910000;
float  Venus_dis =108200000 ;
float  Earth_dis =149600000 ;
float  Mars_dis =227940000 ;
float  Jupiter_dis =778330000 ;
float  Saturn_dis =1429400000 ;
float   Uranus_dis = (2870990000L) ;
float   Neptune_dis =4504300000L ;
float   Pluto_dis =5913520000L;

// ROTACION EJE DIAS
float  sun_rot  = 34.4 ;
float  Mercury_rot = 58.6 ;
float  Venus_rot =-243;
float  Earth_rot = 0.9970833333;
float  Mars_rot =1.025833333 ;
float  Jupiter_rot =0.41;
float  Saturn_rot =0.42625 ;
float  Uranus_rot =0.7458333333 ;
float  Neptune_rot =0.67125 ;
float  Pluto_rot =-6.39 ;

// ROTACION ORBITAL DIAS 
float  sun_orb =  0;
float  Mercury_orb =  87.97;
float  Venus_orb = 224.7 ;
float  Earth_orb = 365.256;
float  Mars_orb =686.98 ;
float  Jupiter_orb =4331.93616 ;
float  Saturn_orb =10760.44176 ;
float  Uranus_orb =30685.15656 ;
float  Neptune_orb =30685.15656 ;
float  Pluto_orb =90780.72624 ;

// inclinacion orbital
float  sun_inc =0;
float  Mercury_inc = 0.12217;
float  Venus_inc = 0.05917 ;
float  Earth_inc = 0;
float  Mars_inc =0.03229 ;
float  Jupiter_inc =0.02286 ;
float  Saturn_inc =0.04346 ;
float  Uranus_inc =0.01344 ;
float  Neptune_inc = 0.03089 ;
float  Pluto_inc  =0.29932 ;

//Escalas
//RADIO KM
float rad_scale(float v ){ return v/1000; }//1000
//DISTANCIA KM
float dis_scale(float v ){ return v/3000000; }//1000000
// angulo periodo rotacion sobre su eje
float inv_scale(float v ){ return 1/v / 100; } 
// angulo periodo rotacion oorbital sobre el sol
float inv_scale2(float v ){ return 1/v ; } 


PeasyCam cam;

PImage sunTexture;
PImage moonTexture;
PImage[] textures = new PImage[9];
float x= 0;
float y= 0;
float z= 500;
PImage bg;
void setup() {
  
  sensor = new KetaiSensor(this);
  sensor.start();
  
  
  fullScreen(P3D);  
  bg = loadImage("univ.png");
  bg.resize(width, height);
  
  
  
  
  
  
  sunTexture = loadImage("sun.jpg");
  moonTexture = loadImage("moon.jpg");
  
  textures[0] = loadImage("venus.jpg");
  textures[1] = loadImage("mercury.jpg");
  textures[2] = loadImage("earth.jpg");
  textures[3] = loadImage("mars.jpg");
  textures[4] = loadImage("jupiter.jpg");
  textures[5] = loadImage("Saturn.jpg");
  textures[6] = loadImage("urano.jpg");
  textures[7] = loadImage("neptuno.png");
  textures[8] = loadImage("pluton.png");
  
   
  cam =  new PeasyCam(this, x, y, z, 0); 
  
   //  RADIO,DISTANCIA,VEL ORVITA ,VEL ROT,INCLINACION,IMAGEN 
  sun = new Planet(1, 0, 0,sun_rad,0 , sunTexture);
  
  Mercury = new Planet(rad_scale(Mercury_rad),dis_scale(Mercury_dis  ),inv_scale(Mercury_orb ) ,inv_scale(Mercury_rot ),Mercury_inc, textures[0]);
  
  
  Venus = new Planet(rad_scale(Venus_rad),dis_scale(Venus_dis  ),inv_scale(Venus_orb ) ,inv_scale(Venus_rot ),Venus_inc, textures[1]);
  
  
  Earth = new Planet(rad_scale(Earth_rad),dis_scale(Earth_dis  ),inv_scale(Earth_orb ) ,inv_scale(Earth_rot ),Earth_inc, textures[2]);
  
  
  Mars = new Planet(rad_scale(Mars_rad),dis_scale(Mars_dis  ),inv_scale(Mars_orb ) ,inv_scale(Mars_rot ),Mars_inc, textures[3]);
  
  
  Jupiter = new Planet(rad_scale(Jupiter_rad),dis_scale(Jupiter_dis  ),inv_scale(Jupiter_orb ) ,inv_scale(Jupiter_rot ),Jupiter_inc, textures[4]);
  
  
  Saturn = new Planet(rad_scale(Saturn_rad),dis_scale(Saturn_dis  ),inv_scale(Saturn_orb ) ,inv_scale(Saturn_rot ),Saturn_inc, textures[5]);
  
  
  Uranus = new Planet(rad_scale(Uranus_rad),dis_scale(Uranus_dis  ),inv_scale(Uranus_orb ) ,inv_scale(Uranus_rot ),Uranus_inc, textures[6]);
  
  
  Neptune = new Planet(rad_scale(Neptune_rad),dis_scale(Neptune_dis  ),inv_scale(Neptune_orb ) ,inv_scale(Neptune_rot ),Neptune_inc, textures[7]);
  
  
  Pluto = new Planet(rad_scale(Pluto_rad),dis_scale(Pluto_dis  ),inv_scale(Pluto_orb ) ,inv_scale(Pluto_rot ),Pluto_inc, textures[8]);
  
  
  
  sun.spawnMoons(0,1);
  Earth.spawnMoons(1,1);
  Mars.spawnMoons(2,1);
  /*
  Jupiter.spawnMoons(79,10);
  Saturn.spawnMoons(62,10);
  Uranus.spawnMoons(27,10);
  Neptune.spawnMoons(14,10);
  Pluto.spawnMoons(5,5);
  */
 // cam.setMinimumDistance(50);
  
  
}

void draw() {

  background(bg);
  ambientLight(255,255,255);
  pointLight(255, 255, 255, 0, 0, 50);
  sun.show();
  sun.orbit();
  
  Mercury.show();
  Mercury.orbit();
  
  Venus.show();
  Venus.orbit();
  
  Earth.show();
  Earth.orbit();  
  
  Mars.show();
  Mars.orbit();
  
  Jupiter.show();
  Jupiter.orbit();
  
  Saturn.show();
  Saturn.orbit();
  
  Uranus.show();
  Uranus.orbit();
  
  Neptune.show();
  Neptune.orbit();
  
  Pluto.show();
  Pluto.orbit();
  
  //move();
  moveMobil();
  
  
text("Accelerometer: \n" + 
    "x: " + nfp(accelerometerX, 1, 3) + "\n" +
    "y: " + nfp(accelerometerY, 1, 3) + "\n" +
    "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);


}
void moveMobil (){
  //abajo
  if(floor(accelerometerZ)  > 3  ){
  
      cam.rotateY(0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
  }
  
  //arriba
  if(floor(accelerometerZ)  < -2 ){
  
      cam.rotateY(-0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
  }  
  // izquierda
  if(floor(accelerometerY)  < -3 ){
  
      cam.rotateX(-0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
  } 
  //derecha
  if(floor(accelerometerY)  > 3 ){
  
      cam.rotateX(+0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
  }
  
  if (mousePressed) {
   
    if (mouseY < 900 ) {
      
    int alfa = 500;
    
    x = lineRX(cam.getLookAt()[0],cam.getPosition()[0],alfa);
    y = lineRX(cam.getLookAt()[1],cam.getPosition()[1],alfa);
    z = lineRX(cam.getLookAt()[2],cam.getPosition()[2],alfa); 
    
    } else {
     
    int alfa = -500;
    x = lineRX(cam.getLookAt()[0],cam.getPosition()[0],alfa);
    y = lineRX(cam.getLookAt()[1],cam.getPosition()[1],alfa);
    z = lineRX(cam.getLookAt()[2],cam.getPosition()[2],alfa);
    
    }
//    println(x+"--"+y+"--"+z+"--");
  }
  
  
  
  cam.lookAt( x,  y, z,0,00001); 
}

void mousePressed()
{
  println("aaa",mouseY,"--",mouseX);
     int alfa = 200;
    
    if (mouseY > 900 ) {
      alfa = -150;
    }
        
    x = lineRX(cam.getLookAt()[0],cam.getPosition()[0],alfa);
    y = lineRX(cam.getLookAt()[1],cam.getPosition()[1],alfa);
    z = lineRX(cam.getLookAt()[2],cam.getPosition()[2],alfa); 
  
  cam.lookAt( x,  y, z,0,1); 
}


void move(){
  
if(keyPressed){
    if(key == CODED)
  {
    
    if (keyCode == UP)
    {  
      cam.rotateX(-0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
    }
    if (keyCode == DOWN)
    { 
      cam.rotateX(0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
    
    }
    if (keyCode == LEFT)
    { 
      cam.rotateY(0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
    
    }
    if (keyCode == RIGHT)
    { 
      cam.rotateY(-0.1);
      x = cam.getPosition()[0];
      y = cam.getPosition()[1];
      z = cam.getPosition()[2]; 
    }
    
  }else{
     if(key == 'w')
  {
    y = y - 10; 
  }
     if(key == 's')
  {
    y = y + 10; 
  }
     if(key == 'a')
  {
  
    x = x -10; 
  }
     if(key == 'd')
  {
  
    x = x +10; 
  }
     if(key == 't')
  {  
 
    int alfa = -20;
    x = lineRX(cam.getLookAt()[0],cam.getPosition()[0],alfa);
    y = lineRX(cam.getLookAt()[1],cam.getPosition()[1],alfa);
    z = lineRX(cam.getLookAt()[2],cam.getPosition()[2],alfa);
      
  
 

  }
     if(key == 'g')
  {  
    int alfa = 20;
    x = lineRX(cam.getLookAt()[0],cam.getPosition()[0],alfa);
    y = lineRX(cam.getLookAt()[1],cam.getPosition()[1],alfa);
    z = lineRX(cam.getLookAt()[2],cam.getPosition()[2],alfa); 
  } 
  if(key == '9')
  {  
    x = 0;
    y = 0;
    z = 50;
  } 
  cam.lookAt( x,  y, z,0,00001); 
  
  
  
 
    
}
}

}

int dis = 165;
// react to key events
void keyPressed() { 


}

float lineRX(float x1, float x2, int alfa ){
  float xr = x2 + ( (x2-x1) * alfa );     
  return xr;
}
float lineRY( float y1, float y2, int alfa ){ 
  float yr = y2 + ( (y2-y1) * alfa );  
  return yr;
}
float lineRZ(float z1, float z2, int alfa ){ 
  float zr = z2 + ( (z2-z1) * alfa );   
  return zr;
}
