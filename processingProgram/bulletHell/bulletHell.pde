//Bullet hell game for arduino coursework
//Created by Walter Wu on 28/10/17

int gridSize = 5;
ArrayList bullets = new ArrayList();
Player player;
Enemy enemy;


void setup(){
  fill(255);
  size(1600, 1200);
  background(0);
  noStroke();
  player = new Player();
  enemy = new Enemy();
}

void draw(){
  background(0);
  player.draw();
  enemy.draw();
}


class SpaceShip{
  int x,y;

  void draw(){
    update();
    drawShip();
  }

  void update(){
  }

  void drawShip(){
  }

}


class Player extends SpaceShip{
  //for player: x,y are centre of circle
  Player(){
    x = width/2/gridSize;
    y = height/gridSize - 10;
  }

  void update(){
    //update position of player
    if (keyPressed && keyCode == LEFT && x > 16) {
      x-=3;
    }
    if (keyPressed && keyCode == RIGHT && x < width/gridSize - 16) {
      x+=3;
    }
  }

  void drawShip(){

    ellipse((x-4)*gridSize,(y-4)*gridSize,8*gridSize,8*gridSize);
  }

  void ifHit(){

  }
}


class Enemy extends SpaceShip{
  boolean hasTarget = false;
  int targetx = 0,targety = 0;

  Enemy(){
    x = width/2/gridSize;
    y = 10;
  }

  void update(){
    //move enemy towards chosen target, or select new target
    if (frameCount%5 == 0){
      if (abs(targety-y)<=1 || abs(targetx-x)<=1){
        hasTarget = false;
      }
      if (hasTarget){
        y += round((targety-y)/abs(targety-y));
        x += round((targetx-x)/abs(targety-y));
        }else{
          int tempx,tempy;
          boolean ifFound = false;
          while (! ifFound){
            tempx = int(random(80,240));
            tempy = int(random(20,40));
            if ((abs(tempx-targetx) > 70 && abs(tempx-targetx) < 140 && abs(tempy-targety)> 8 && abs(tempy-targety) < 15) || (targetx == 0)) {
              targetx = tempx;
              targety = tempy;
              ifFound = true;
              hasTarget = true;
            }
          }
        }
      }
    }

    void drawShip(){
      triangle(x*gridSize,y*gridSize,(x-4)*gridSize,(y-6)*gridSize,(x+4)*gridSize,(y-6)*gridSize);
    }



  }


















  //
