PShape red, yellow, green; 
void setup() {
  size(450, 450);
  background(50);
  
  int[] p1 = {210, 50};
  int[] p2 = {250, 50};
  int[] p3 = {210, 130};
  int[] p4 = {230, 170};
  int[] p5 = {145, 310};
  int[] p6 = {305, 310};
  int[] p7 = {350, 310};
  int[] p8 = {30, 350};
  int[] p9 = {120, 350};
  int[] p10 = {420, 350};
  int[] p11 = {50, 390};
  int[] p12 = {400, 390};
  
  
  red = createShape();
  red.beginShape();
  red.fill(250,128,114);
  red.vertex(p8[0], p8[1]);
  red.vertex(p1[0], p1[1]);
  red.vertex(p7[0], p7[1]);
  red.vertex(p6[0], p6[1]);
  red.vertex(p3[0], p3[1]);
  red.vertex(p11[0], p11[1]);
  red.vertex(p8[0], p8[1]);
  red.endShape();
  
  green = createShape();
  green.beginShape();
  green.fill(50,205,50);
  green.vertex(p1[0], p1[1]);
  green.vertex(p2[0], p2[1]);
  green.vertex(p10[0], p10[1]);
  green.vertex(p9[0], p9[1]);
  green.vertex(p5[0], p5[1]);
  green.vertex(p7[0], p7[1]);
  green.vertex(p1[0], p1[1]);
  green.endShape();
  
  yellow = createShape();
  yellow.beginShape();
  yellow.fill(255,255,0);
  yellow.vertex(p11[0], p11[1]);
  yellow.vertex(p3[0], p3[1]);
  yellow.vertex(p4[0], p4[1]);
  yellow.vertex(p9[0], p9[1]);
  yellow.vertex(p10[0], p10[1]);
  yellow.vertex(p12[0], p12[1]);
  yellow.vertex(p11[0], p11[1]);
  yellow.endShape();
  
}
void draw() {
   shape(red, 0, 0);
   shape(green, 0, 0);
   shape(yellow, 0, 0);
}
