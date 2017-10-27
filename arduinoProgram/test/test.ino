#include "graphics.c"

int leftInPin = 7;
int rightInPin = 9;
int currentStat = 0; //0 means untilted, 1 means left-tilted and 2 means right-tilted

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(leftInPin, INPUT);
  pinMode(rightInPin, INPUT);
  Serial.println("Untilted");
}

void loop() {
  // put your main code here, to run repeatedly:
  int val;

  
//  val = digitalRead(rightInPin); //0 means untilted, 1 means tilted
//  Serial.println(val);
//  delay(500);
  
  if ( digitalRead(leftInPin) == 1 && currentStat != 1){
    //stat changed to left-tilted
    currentStat = 1;
    Serial.println("Left-tilted");
  }else if(digitalRead(rightInPin) == 1 && currentStat != 2){
    //stat changed to right-tilted
    currentStat = 2;
    Serial.println("Right-tilted");
  }else if (digitalRead(leftInPin) == 0 &&digitalRead(rightInPin) == 0 && currentStat != 0){
    //stat changed to untilted
    currentStat = 0;
    Serial.println("Untilted");
  }
  delay(100);
  
}
