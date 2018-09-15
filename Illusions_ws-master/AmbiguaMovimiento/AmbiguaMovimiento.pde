void shape(int cordX, int cordY, int action){
  noStroke();
  if(action == 1){
    fill(33,80,167);
    ellipse(cordX, cordY, 70, 70);
  }else{
    fill(255);
    ellipse(cordX, cordY, 70, 70);
  }
}
void setup() {
  size(450, 450);
  background(255);
}
void draw() {
   int m = second();
   if(m % 2 == 0){
     shape(100, 100, 1);
     shape(100, 350, 0);
     shape(350, 350, 1);
     shape(350, 100, 0);
   }else{
     shape(100, 100, 0);
     shape(100, 350, 1);
     shape(350, 350, 0);
     shape(350, 100, 1);
    
   }
}
