import processing.serial.*;
import cc.arduino.*;

Arduino ard;

int leftInPin = 7;
int rightInPin = 8;
int currentStat = 0; //0 means untilted, 1 means left-tilted and 2 means right-tilted

void setup(){
    ard = new Arduino(this, Arduino.list()[0],57600);
    ard.pinMode(leftInPin, ard.INPUT);
    ard.pinMode(rightInPin, ard.INPUT);
    println("Untilted");
    
}

void draw(){
  
    //check if status has changed
    if (ard.digitalRead(leftInPin) == 1 && currentStat != 1){
        currentStat = 1;
        println(currentStat); //left-titlted
    }else if(ard.digitalRead(rightInPin) == 1 && currentStat != 2){
        currentStat = 2;
        println(currentStat);//right-tilted
    }else if (ard.digitalRead(leftInPin) == 0 &&ard.digitalRead(rightInPin) == 0 && currentStat != 0){
        currentStat = 0;
        println(currentStat);//untilted
    }
    
    delay(100);
    //delay in case of massive output
}