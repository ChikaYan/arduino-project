
int leftInPin = 7;
int rightInPin = 8;
int currentStat = 0; //0 means untilted, 1 means left-tilted and 2 means right-tilted

void setup() {
  Serial.begin(9600);
  pinMode(leftInPin, INPUT);
  pinMode(rightInPin, INPUT);
  Serial.println("Untilted");//init status
}

void loop() {

  //check if status has changed
  if ( digitalRead(leftInPin) == 1 && currentStat != 1){
    currentStat = 1;
    Serial.println(currentStat); //left-titlted
  }else if(digitalRead(rightInPin) == 1 && currentStat != 2){
    currentStat = 2;
    Serial.println(currentStat);//right-tilted
  }else if (digitalRead(leftInPin) == 0 &&digitalRead(rightInPin) == 0 && currentStat != 0){
    currentStat = 0;
    Serial.println(currentStat);//untilted
  }
  
  delay(100);
  //delay in case of massive output
}
