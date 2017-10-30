//Bullet hell game for arduino coursework
//Created by Walter Wu on 28/10/17


Player player;
Enemy enemy;
boolean gameOver;
final int PLAYER_MOVE_SPEED = 10;
final int PLAYER_SIZE = 40;
final int ENEMY_SIZE = 10;
final int ENEMY_MOVE_SPEED = 2;
final int ENEMY_MOVE_DELAY = 100;
final int BULLET_NUM = 20;
final int BULLET_SIZE = 20;


void setup() {
  size(1600, 1200);
  background(0);
  noStroke();
  player = new Player();
  enemy = new Enemy();
  gameOver = false;
}

void draw() {
  if (!gameOver) {
    background(0);
    player.draw();
    enemy.draw();
    gameOver = enemy.ifHit(player.getx(), player.gety());
  }else{
    fill(125);
    textSize(80);
    textAlign(CENTER);
    text("GAME OVER", width/2,height/2 - 20);
    textSize(40);
    text("Press Enter", width/2,height/2 + 30);
    if (keyPressed && key == ENTER){
      //reset the game
      player = new Player();
      enemy = new Enemy();
      background(0);
      gameOver = false;
    }
  }

}



class SpaceShip {
  int x, y;

  void draw() {
    update();
    drawShip();
  }

  void update() {}
  void drawShip() {
  }
}

class Player extends SpaceShip {
  //for player: x,y are centre of circle
  Player() {
    x = width / 2;
    y = height - 50;
  }

  void update() {
    //update position of player
    if (keyPressed && keyCode == LEFT && x > 80) {
      x -= PLAYER_MOVE_SPEED;
    }
    if (keyPressed && keyCode == RIGHT && x < width - 80) {
      x += PLAYER_MOVE_SPEED;
    }
  }

  void drawShip() {
    fill(250,61,61);
    ellipse(x, y, PLAYER_SIZE, PLAYER_SIZE);
  }

  int getx() {
    return x;
  }
  int gety() {
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
    x = width / 2;
    y = 100;
  }

  void update() {
    updateBullets();
    //shoot every 0.5s
    if (frameCount % 30 == 0) {
      shoot();
    }
    moveEnemy();
  }

  void drawShip() {
    fill(61,77,250);
    triangle(x, y, x - 2 * ENEMY_SIZE, y - 3 * ENEMY_SIZE, x + 2 * ENEMY_SIZE, y - 3 * ENEMY_SIZE);
  }

  void updateBullets(){
    //update status for both bullets and enemy
    //remove the bullets that are out of screen
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      if (! bInstance.checkValidity()) {
        bullets.remove(i);
      }
    }
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      bInstance.draw();
    }
  }

  void moveEnemy(){
    //if can move, move enemy towards chosen target, or select new target
    if (canMove) {
      if (abs(targetx-x) < ENEMY_MOVE_SPEED) {
        hasTarget = false;
      }
      if (hasTarget) {
        if (targetx > x) {
          x += ENEMY_MOVE_SPEED;
        } else if (targetx < x) {
          x -= ENEMY_MOVE_SPEED;
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
      if (delayCount >= ENEMY_MOVE_DELAY) {
        delayCount = 0;
        canMove = true;
      }
    }
  }

  void shoot() {
    for (int i =0; i<BULLET_NUM; i++) {
      bullets.add(new Bullet(float(x), float(y), random(-2, 3), random(1, 3)));
    }
  }

  boolean ifHit(int playerx, int playery) {
    boolean ifhit = false;
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      ifhit = bInstance.ifHit(playerx, playery);
      if (ifhit) {
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
    fill(61,250,115);
    ellipse(int(x), int(y), BULLET_SIZE, BULLET_SIZE);
  }

  boolean checkValidity() {
    if (x < - (BULLET_SIZE / 2) || x > width + BULLET_SIZE / 2 || y < -(BULLET_SIZE / 2) || y > height+BULLET_SIZE / 2) {
      //bullet has left screen
      return false;
    }
    return true;
  }

  boolean ifHit(int playerx, int playery) {
    float distSqr = sq(x - float(playerx)) + sq(y - float(playery));
    //when distance is less than sum of radius -- hit
    if (distSqr < sq(float(PLAYER_SIZE + BULLET_SIZE) / 2)) {
      return true;
    }
    return false;
  }
}








//
