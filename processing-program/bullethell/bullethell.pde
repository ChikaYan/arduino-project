//Bullet hell game for Arduino coursework
//Created by Walter Wu on 28/10/17


import processing.serial.*;
import cc.arduino.*;

Arduino ard;
Player player;
Enemy enemy;
boolean gameOver;
int score;
ArduinoStatus status;

final int LEFT_IN_PIN = 7;
final int RIGHT_IN_PIN = 8;
final int PLAYER_MOVE_SPEED = 5;
final int PLAYER_SIZE = 40;
final int ENEMY_SIZE = 20;
final int ENEMY_MOVE_SPEED = 2;
final int ENEMY_MOVE_DELAY = 100;
final int ENEMY_SHOOT_DELAY = 200;
final int BULLET_NUM = 20;
final int BULLET_SIZE = 20;


enum ArduinoStatus{
  untilted, left_tilted, right_tilted
}


void setup() {
  size(1600, 1200);
  background(0);
  noStroke();
  ard = new Arduino(this, Arduino.list()[0],57600);
  ard.pinMode(LEFT_IN_PIN, ard.INPUT);
  ard.pinMode(RIGHT_IN_PIN, ard.INPUT);
  status = ArduinoStatus.untilted;
  player = new Player();
  enemy = new Enemy();
  score = 0;
  gameOver = false;
}

void draw() {
  if (!gameOver) {
    background(0);
    player.draw();
    enemy.draw();

    //update arduino status
    if (ard.digitalRead(LEFT_IN_PIN) == 1 && status != ArduinoStatus.left_tilted){
        status = ArduinoStatus.left_tilted;
    }else if(ard.digitalRead(RIGHT_IN_PIN) == 1 && status != ArduinoStatus.right_tilted){
        status = ArduinoStatus.right_tilted;
    }else if (ard.digitalRead(LEFT_IN_PIN) == 0 && ard.digitalRead(RIGHT_IN_PIN) == 0 && status != ArduinoStatus.untilted){
        status = ArduinoStatus.untilted;
    }

    score += 1;
    fill(255);
    textSize(30);
    textAlign(LEFT);
    text("Score: " + nf(score,8), width / 16, height / 12);

    gameOver = enemy.ifHit(player.getx(), player.gety());
  } else {

    fill(175);
    textSize(80);
    textAlign(CENTER);
    text("GAME OVER", width / 2, height / 2 - 50);
    textSize(40);
    text("Your Score: " + nf(score,8), width / 2, height / 2);
    text("Press Enter to Restart", width / 2, height / 2 + 50);
    text("Press Space to Upload Your Score to Scoreboard", width / 2, height / 2 + 100);

    if (keyPressed && key == ENTER) {
      //reset the game
      player = new Player();
      enemy = new Enemy();
      background(0);
      score = 0;
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

  void update() {
  }
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
    if (status == ArduinoStatus.left_tilted){
      x -= PLAYER_MOVE_SPEED;
    }else if (status == ArduinoStatus.right_tilted){
      x += PLAYER_MOVE_SPEED;
    }

    //keyboard control:
    // if (keyPressed && keyCode == LEFT && x > 80) {
    //   x -= PLAYER_MOVE_SPEED;
    // }
    // if (keyPressed && keyCode == RIGHT && x < width - 80) {
    //   x += PLAYER_MOVE_SPEED;
    // }
  }

  void drawShip() {
    fill(250, 61, 61);
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
  int targetx = 0, delayCount = 0, colourCode = 0;
  ArrayList bullets = new ArrayList();


  Enemy() {
    x = width / 2;
    y = 100;
  }

  void update() {
    updateBullets();
    //shoot every 0.5s
    if (frameCount % ENEMY_SHOOT_DELAY == 0 || frameCount == 1) {
      shoot();
    }
    moveEnemy();
  }

  void drawShip() {
    fill(61, 77, 250);
    triangle(x, y, x - 2 * ENEMY_SIZE, y - 3 * ENEMY_SIZE, x + 2 * ENEMY_SIZE, y - 3 * ENEMY_SIZE);
  }

  void updateBullets() {
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

  void moveEnemy() {
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
      delayCount ++;
      if (delayCount >= ENEMY_MOVE_DELAY) {
        delayCount = 0;
        canMove = true;
      }
    }
  }

  void shoot() {
    int colourR, colourG, colourB;
    //use colourCode to select different colours for bullets
    switch(colourCode++){
      case 0:
        colourR = 247;
        colourG = 22;
        colourB = 218;
        break;
      case 1:
        colourR = 117;
        colourG = 237;
        colourB = 138;
        break;
      case 2:
        colourR = 117;
        colourG = 237;
        colourB = 230;
        break;
      case 3:
        colourR = 210;
        colourG = 247;
        colourB = 62;
        break;
      default:
        colourR = 0;
        colourG = 0;
        colourB = 0;
        break;
    }
    //reset colourCode
    if (colourCode == 4){
      colourCode = 0;
    }

    for (int i =0; i<BULLET_NUM; i++) {
      bullets.add(new Bullet(float(x), float(y), random(-3, 3), random(2, 3), colourR, colourG, colourB));
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
  int r,g,b;
  Bullet(float startx, float starty, float xspeed, float yspeed, int colourR, int colourG, int colourB) {
    x = startx;
    y = starty;
    xSpeed = xspeed;
    ySpeed = yspeed;
    r = colourR;
    g = colourG;
    b = colourB;
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
    fill(r, g, b);
    ellipse(int(x), int(y), BULLET_SIZE, BULLET_SIZE);
  }

  boolean checkValidity() {
    if (x < - (BULLET_SIZE / 2) || x > width + BULLET_SIZE / 2 || y < -(BULLET_SIZE / 2) || y > height + BULLET_SIZE / 2) {
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
