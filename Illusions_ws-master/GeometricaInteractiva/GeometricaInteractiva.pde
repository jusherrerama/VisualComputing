int effect = 0;
void wallNoEfect() {
  int wid = 840;
  int size = 800 / 13;
  int sizeLine = 2;
  int posX = 0;
  int posY = 0;
  int colorr = 0;
  for (int i = 0; i < 8; i = i + 1) {
    while (posX <= wid) {
      fill(255, 255, 255);
      if (colorr == 0) {
        fill(0, 0, 0);
        colorr = 1;
      } else {
        fill(255, 255, 255);
        colorr = 0;
      }
      rect(posX, posY, size, size);
      posX = posX + size;
    }
    fill(153);
    rect(0, posY, wid, sizeLine);
    posY = posY + size;
    posX = 0;
  }
}
void wallEfect() {
  int wid = 840;
  int size = 800 / 13;
  int sizeLine = 2;
  int posX = 0;
  int posY = 0;
  int colorr = 0;
  int[] positions = new int[8];
  positions[0] = 0;
  positions[1] = size/4;
  positions[2] = positions[1] + size/4;
  positions[3] = positions[1];
  positions[4] = positions[0];
  positions[5] = positions[1];
  positions[6] = positions[2];
  positions[7] = positions[3];
  for (int i = 0; i < 8; i = i + 1) {
    posX = positions[i];
    fill(255, 255, 255);
    rect(0, posY, posX, size);
    while (posX <= wid) {
      if (colorr == 0) {
        fill(0, 0, 0);
        colorr = 1;
      } else {
        fill(255, 255, 255);
        colorr = 0;
      }
      rect(posX, posY, size, size);
      posX = posX + size;
    }
    fill(153);
    rect(0, posY, wid, sizeLine);
    posY = posY + size;
  }
}

void setup() {
  size(840, 490);
}

void mouseClicked() {
  if (effect == 0) {
    wallNoEfect();
    effect = 1;
  } else {
    effect = 0;
    wallEfect();
  }
}
void draw() {
  if (effect == 0) {
    wallNoEfect();
  } else {
    wallEfect();
  }
}
