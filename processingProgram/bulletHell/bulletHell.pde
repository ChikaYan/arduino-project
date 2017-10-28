//Bullet hell game for arduino coursework
//Created by Walter Wu on 28/10/17

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
    x = width/2;
    y = height - 50;
  }

  void update(){
    //update position of player
    if (keyPressed && keyCode == LEFT && x > 80) {
      x-=15;
    }
    if (keyPressed && keyCode == RIGHT && x < width - 80) {
      x+=15;
    }
  }

  void drawShip(){
    ellipse(x-20,y-20,40,40);
  }

  void ifHit(){

  }
}


class Enemy extends SpaceShip{
  boolean hasTarget = false;
  int targetx = 0;
  int moveScale = 2;

  Enemy(){
    x = width/2;
    y = 100;
  }

  void update(){
    //move enemy towards chosen target, or select new target
    if (abs(targetx-x) < moveScale){
      hasTarget = false;
    }
    if (hasTarget){
      if (targetx > x){
        x += moveScale;
      }else if (targetx < x){
        x -= moveScale;
      }
      }else{
        //ensure next target point is far away from last one
        if (targetx < 800){
          targetx = int(random(1100,1300));
        }else{
          targetx = int(random(300,500));
        }
        hasTarget = true;
      }

    }

    void drawShip(){
      triangle(x,y,x-20,y-30,x+20,y-30);
    }



  }


















  //
