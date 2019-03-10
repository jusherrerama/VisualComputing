// Texture from Jason Liebig's FLICKR collection of vintage labels and wrappers:
// http://www.flickr.com/photos/jasonliebigstuff/3739263136/in/photostream/

  
import processing.video.*;
Movie myMovie;

PImage i720;
PImage i4k;
PImage i1080;
PShape can;
float angle;

PShader k3;
PShader k5;
PShader k7;
PShader k9;
PShader k11;
PShader k13;
PShader k15; 

int startTime;

PImage[] images = new PImage[3];
PShader[] kernel = new PShader[7];

void setup() {
  fullScreen(P2D);     
  
  //IMAGES
  images[0] = loadImage("720.png"); 
  images[1] = loadImage("1080.png"); 
  images[2] = loadImage("4k.png");   
  
  //KERNELS
  kernel[0] = loadShader("k3.glsl");
  kernel[1] = loadShader("k5.glsl");
  kernel[2] = loadShader("k7.glsl");
  kernel[3] = loadShader("k9.glsl");
  kernel[4] = loadShader("k11.glsl");
  kernel[5] = loadShader("k13.glsl");
  kernel[6] = loadShader("k15.glsl");
  
  startTime = millis();
  shader(kernel[6]); 
  image(images[1], 0, 0, width, height);         
  println(millis()-startTime); 
  saveFrame("outputImage.png");  
}
