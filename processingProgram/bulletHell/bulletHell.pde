//Bullet hell game for arduino coursework
//Created by Walter Wu on 28/10/17


Player player;
Enemy enemy;
boolean gameOver;
final int playerSize = 40;
final int enemySize = 10;
final int enemyMoveScale = 2;
final int enemyMoveDelay = 100;
final int bulletNum = 20;
final int bulletSize = 10;


void setup() {
  fill(255);
  size(1600, 1200);
  background(0);
  noStroke();
  player = new Player();
  enemy = new Enemy();
  gameOver = false;
}

void draw() {
  if(!gameOver){
    background(0);
    player.draw();
    enemy.draw();
    gameOver = enemy.ifHit(player.getx(),player.gety());
  }
}






class SpaceShip {
  int x, y;

  void draw() {
    update();
    drawShip();
  }

  void update() {
  }
  void drawShip() {
  }
}

class Player extends SpaceShip {
  //for player: x,y are centre of circle
  Player() {
    x = width/2;
    y = height - 50;
  }

  void update() {
    //update position of player
    if (keyPressed && keyCode == LEFT && x > 80) {
      x-=15;
    }
    if (keyPressed && keyCode == RIGHT && x < width - 80) {
      x+=15;
    }
  }

  void drawShip() {
    ellipse(x-playerSize/2, y-playerSize/2, playerSize, playerSize);
  }

  int getx(){
    return x;
  }
  int gety(){
    return y;
  }

}

class Enemy extends SpaceShip {
  //for enemy, x,y will be bottom point of triangle
  boolean hasTarget = false;
  boolean canMove = false;
  int targetx = 0, delayCount = 0;
  ArrayList bullets = new ArrayList();

  Enemy() {
    x = width/2;
    y = 100;
  }

  void update() {
    //update status for both bullets and enemy
    //remove the bullets that are out of screen
    for (int i =0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      if (! bInstance.checkValidity()) {
        bullets.remove(i);
      }
    }
    for (int i =0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      bInstance.draw();
    }

    //shoot every 0.5s
    if (frameCount%30 == 0) {
      shoot();
    }

    //if can move, move enemy towards chosen target, or select new target
    if (canMove) {
      if (abs(targetx-x) < enemyMoveScale) {
        hasTarget = false;
      }
      if (hasTarget) {
        if (targetx > x) {
          x += enemyMoveScale;
          } else if (targetx < x) {
            x -= enemyMoveScale;
          }
          } else {
            //ensure next target point is far away from last one
            if (targetx < 800) {
              targetx = int(random(1100, 1300));
              } else {
                targetx = int(random(300, 500));
              }
              hasTarget = true;
              canMove = false;
            }
            } else {
              delayCount += 1;
              if (delayCount >= enemyMoveDelay) {
                delayCount = 0;
                canMove = true;
              }
            }
          }

          void drawShip() {
            triangle(x, y, x-2*enemySize, y-3*enemySize, x+2*enemySize, y-3*enemySize);
          }

          void shoot() {
            for (int i =0; i<bulletNum; i++) {
              bullets.add(new Bullet(float(x), float(y), random(-2, 3), random(1, 3)));
            }
          }

          boolean ifHit(int playerx,int playery){
            boolean ifhit = false;
            for (int i = 0;i < bullets.size();i++){
              Bullet bInstance = (Bullet) bullets.get(i);
              ifhit = bInstance.ifHit(playerx,playery);
              if (ifhit){
                return true;
              }
            }
            return false;
          }

        }



        class Bullet {
          //for bullets, x,y will be centre of circle
          float x, y, xSpeed, ySpeed;

          Bullet(float startx, float starty, float xspeed, float yspeed) {
            x = startx;
            y = starty;
            xSpeed = xspeed;
            ySpeed = yspeed;
          }

          void draw() {
            update();
            checkValidity();
            drawBullet();
          }

          void update() {
            x += xSpeed;
            y += ySpeed;
          }

          void drawBullet() {
            ellipse(int(x-bulletSize/2), int(y-bulletSize/2), bulletSize, bulletSize);
          }

          boolean checkValidity() {
            if (x < -(bulletSize/2) || x > width+bulletSize/2 || y < -(bulletSize/2) || y > height+bulletSize/2) {
              //bullet has left screen
              return false;
            }
            return true;
          }

          boolean ifHit(int playerx,int playery){
            float distSqr = sq(x-playerx) + sq(y-playery);
            //when distance is less than sum of radius -- hit
            if (distSqr < playerSize + bulletSize){
              return true;
            }
            return false;
          }

        }








        //
