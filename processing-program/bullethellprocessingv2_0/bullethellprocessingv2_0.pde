// Bullet hell game for Arduino coursework
// Created by Walter Wu on 28/10/17

// Following library is used in this program:
// Title: Firmata library for Processing
// Author: soundanalogous
// Date: 8 Nov 2016
// Availabile at https://github.com/firmata/processing/releases/tag/latest

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
final int PLAYER_SIZE = 30;
final int ENEMY_SIZE = 20;
final int ENEMY_MOVE_SPEED = 2;
final int ENEMY_MOVE_DELAY = 100;
final int ENEMY_SHOOT_DELAY = 60;
final int BULLET_NUM = 15;
final int BULLET_SIZE = 20;
final Colour PINK = new Colour(247, 134, 244);
final Colour GREEN = new Colour(117, 237, 138);
final Colour CYAN = new Colour(117, 237, 230);
final Colour YELLOW = new Colour(210,247, 62);
final Colour RED = new Colour(250, 61, 61);
final Colour BLUE = new Colour(61, 77, 250);


void setup() {
  size(1600, 1200);
  background(0);
  noStroke();
  // // ard = new Arduino(this, Arduino.list()[0],57600);
  // ard.pinMode(LEFT_IN_PIN, ard.INPUT);
  // ard.pinMode(RIGHT_IN_PIN, ard.INPUT);
  // status = ArduinoStatus.untilted;
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
    // if (ard.digitalRead(LEFT_IN_PIN) == 1 && status != ArduinoStatus.left_tilted){
    //     status = ArduinoStatus.left_tilted;
    // }else if(ard.digitalRead(RIGHT_IN_PIN) == 1 && status != ArduinoStatus.right_tilted){
    //     status = ArduinoStatus.right_tilted;
    // }else if (ard.digitalRead(LEFT_IN_PIN) == 0 && ard.digitalRead(RIGHT_IN_PIN) == 0 && status != ArduinoStatus.untilted){
    //     status = ArduinoStatus.untilted;
    // }

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
    // if (status == ArduinoStatus.left_tilted){
    //   x -= PLAYER_MOVE_SPEED;
    // }else if (status == ArduinoStatus.right_tilted){
    //   x += PLAYER_MOVE_SPEED;
    // }

    //keyboard control:
    if (keyPressed && keyCode == LEFT && x > 80) {
      x -= PLAYER_MOVE_SPEED;
    }
    if (keyPressed && keyCode == RIGHT && x < width - 80) {
      x += PLAYER_MOVE_SPEED;
    }
  }

  void drawShip() {
    fill(RED.getR(), RED.getG(), RED.getB());
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
    fill(BLUE.getR(), BLUE.getG(), BLUE.getB());
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
    if (!canMove){
      delayCount ++;
      if (delayCount >= ENEMY_MOVE_DELAY) {
        delayCount = 0;
        canMove = true;
      }
      return;
    }
    hasTarget = (abs(targetx-x) > ENEMY_MOVE_SPEED) && (targetx != 0);
    if (!hasTarget){
      targetx = findTargetx(targetx);
      hasTarget = true;
      canMove = false;
      return;
    }
    if (targetx > x) {
      x += ENEMY_MOVE_SPEED;
    } else if (targetx < x) {
      x -= ENEMY_MOVE_SPEED;
    }
  }

  int findTargetx(int previousX){
    //ensure next target point is far away from last one
    if (targetx < 800) {
      return int(random(1000, 1100));
    } else {
      return int(random(500, 600));
    }
  }

  void shoot() {
    Colour bulletColour;
    //use colourCode to select different colours for bullets
    switch((colourCode++) % 4){
      case 0:
        bulletColour = PINK;
        break;
      case 1:
        bulletColour = GREEN;
        break;
      case 2:
        bulletColour = CYAN;
        break;
      case 3:
        bulletColour = YELLOW;
        break;
      default:
        bulletColour = PINK;
        break;
    }

    for (int i =0; i<BULLET_NUM; i++) {
      bullets.add(new Bullet(float(x), float(y), random(-10, 10), random(17, 19), bulletColour.getR(), bulletColour.getG(), bulletColour.getB()));
    }
  }

  boolean ifHit(int playerx, int playery) {
    for (int i = 0; i < bullets.size(); i++) {
      Bullet bInstance = (Bullet) bullets.get(i);
      if (bInstance.ifHit(playerx, playery)) {
        return true;
      }
    }
    return false;
  }
}


class Bullet {
  //for bullets, x,y will be centre of circle
  float x, y, xSpeed, ySpeed;
  int r, g, b;
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
    drawBullet();
  }

  void update() {
    x += xSpeed;
    y += ySpeed;
    //reduce yspeed
    if (ySpeed > 2){
      if (y >= height * 4/5){
        ySpeed = ySpeed * 0.9;
        xSpeed = xSpeed * 0.95;
      }
    }
  }

  void drawBullet() {
    fill(r, g, b);
    ellipse(int(x), int(y), BULLET_SIZE, BULLET_SIZE);
  }

  boolean checkValidity() {
    if (x < -(BULLET_SIZE / 2) || x > width + BULLET_SIZE / 2 || y < -(BULLET_SIZE / 2) || y > height + BULLET_SIZE / 2) {
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


class Colour{
  int R, G, B;

  Colour(int r, int g, int b){
    R = r;
    G = g;
    B = b;
  }
  int getR(){
    return R;
  }
  int getG(){
    return G;
  }
  int getB(){
    return B;
  }
}








//
