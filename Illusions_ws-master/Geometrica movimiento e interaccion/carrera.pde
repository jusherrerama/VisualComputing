 
boolean click = false;
 color c = color(239, 35, 69);
  color c2 = color(244, 238, 66);
  color c3 = color(18, 35, 229);
  color c4 = color(60, 229, 18);
float x = 0;
float y = 150;

float y2 = 220;
float speed = 0.7  ;

void setup(){
  size(600,600);
  fond();
} 
 
void draw() {
  if (click){
    
      background(255,255,255);
   }else{
      fond();
   }
  
   move();
   display();
}
void fond(){
  background(255,255,255);
  for(int i =-5; i < 600; i = i + 20){
    fill(0,0,0);
  rect(i, 0, 10, 600); 
  }
}
void move() {
  x = x + speed;
  if (x > width) {
    x = 0;
  }
}
void mouseClicked() {
  click = !click;
}

void display() {  
  fill(c);
  strokeWeight(0);
  rect(x,y,40,20);  
  fill(c);
  rect(x,y2,40,20);
  
  fill(c2);
  rect(x,100,40,20);
  fill(c2);
  rect(x,50,40,20);
  
  fill(c3);
  rect(x,250,40,20);
  fill(c3);
  rect(x,290,40,20);
  
  
  fill(c4);
  rect(x,350,40,20);
  fill(c4);
  rect(x,400,40,20);  
  
}
    
    