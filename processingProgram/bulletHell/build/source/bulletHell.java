import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class bulletHell extends PApplet {

//Bullet hell game for arduino coursework
//Created by Walter Wu on 28/10/17

int gridSize = 5;
ArrayList bullets = new ArrayList();
Player player;
Enemy enemy;


public void setup(){
  fill(255);
  
  background(0);
  noStroke();
  player = new Player();
  enemy = new Enemy();
}

public void draw(){
  background(0);
  player.draw();
  enemy.draw();
}


class SpaceShip{
  int x,y;

  public void draw(){
    update();
    drawShip();
  }

  public void update(){
  }

  public void drawShip(){
  }

}


class Player extends SpaceShip{
  //for player: x,y are centre of circle
  Player(){
    x = width/2/gridSize;
    y = height/gridSize - 10;
  }

  public void update(){
    //update position of player
    if (keyPressed && keyCode == LEFT && x > 16) {
      x-=3;
    }
    if (keyPressed && keyCode == RIGHT && x < width/gridSize - 16) {
      x+=3;
    }
  }

  public void drawShip(){

    ellipse((x-4)*gridSize,(y-4)*gridSize,8*gridSize,8*gridSize);
  }

  public void ifHit(){

  }
}


class Enemy extends SpaceShip{
  boolean hasTarget = false;
  int targetx = 0,targety = 0;

  Enemy(){
    x = width/2/gridSize;
    y = 10;
  }

  public void update(){
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
            tempx = PApplet.parseInt(random(80,240));
            tempy = PApplet.parseInt(random(20,40));
            if ((abs(tempx-targetx) > 80 && abs(tempx-targetx) < 140 && abs(tempy-targety)> 8 && abs(tempy-targety) < 15) || (targetx == 0)) {
              targetx = tempx;
              targety = tempy;
              ifFound = true;
              hasTarget = true;
            }
          }
        }
      }
    }

    public void drawShip(){
      triangle(x*gridSize,y*gridSize,(x-4)*gridSize,(y-6)*gridSize,(x+4)*gridSize,(y-6)*gridSize);
    }



  }


















  //
  public void settings() {  size(1600, 1200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "bulletHell" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
