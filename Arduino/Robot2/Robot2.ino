#include <avr/interrupt.h>  // interrupts library
//motor control program

const int dir1 = 9;
const int pwm1 = 10;
const int dir2 = 11;
const int pwm2 = 12;
const int dir3 = 47;
const int pwm3 = 49;
const int dir4 = 51;
const int pwm4 = 53;

const int throPin = 32;
const int ailePin = 30;
const int elevPin = 28;
const int ruddPin = 26;
const int gearPin = 24;
const int aux1Pin = 22;

//current velocity
float xVel = 0;
float yVel = 0;
float rVel = 0;

long start = -1;
const float maxVel = 500; //units in millimeters per second
const float moveTime = 1.0; //time to get to desired position in seconds


//-----[ Setup ]--------------------------------------------------
void setup() {
  // put your setup code here, to run once:
  pinMode(dir1, OUTPUT);
  pinMode(pwm1, OUTPUT);
  pinMode(dir2, OUTPUT);
  pinMode(pwm2, OUTPUT);
  pinMode(dir3, OUTPUT);
  pinMode(pwm3, OUTPUT);
  pinMode(dir4, OUTPUT);
  pinMode(pwm4, OUTPUT);



  Serial.begin(115200);
  Serial1.begin(115200);
  Serial.print("Ready!\n");
  Serial1.print("Ready!\n");
}

void loop() {
  // put your main code here, to run repeatedly:

  //if we have new xBee serial data
  if(Serial1.available()) {
    float dummy1 = 0;
    float dummy2 = 0;
    float xVel = 0;
    float yVel = 0;
    float dummy3 = 0;
    float dummy4 = 0; 
    
    dummy1 = Serial1.parseFloat(); // Data for Robot 1, not used but has to be parsed
    dummy2 = Serial1.parseFloat();
    xVel = Serial1.parseFloat(); //Data for this Robot
    yVel = Serial1.parseFloat();
    dummy3 = Serial1.parseFloat(); // Data for Robot 3, not used but has to be parsed
    dummy4 = Serial1.parseFloat();
    
    while(Serial1.available() > 0) {
      Serial.print(Serial1.read());
    }
    String str = "Received(xBee): ";
    str = str + xVel + " " + yVel + "\n";
    Serial.print(str);
  
  
  //check if max velocity has been reached
  int newVel = max(xVel, yVel);
  newVel = max(newVel, maxVel);
  float scale = (float) maxVel/newVel;
  xVel = xVel * scale;
  yVel = yVel * scale;

  vectorCalc(xVel, yVel);
  }
  

  //If RC mode is on switch to that sub program
  int gearValue = pulseIn(gearPin, HIGH);
  if(abs(gearValue-1095) < 50) {
    runRC();
  }
}

//-----[ Velocity Calculation ]---------------------------------------

//calculates vectored velocities for each motor then drives motors
void vectorCalc(float xVel, float yVel) {
  //vector calculations
  int vel1 = -(xVel + 0.2286*rVel);
  int vel2 = yVel - 0.2286*rVel; 
  int vel3 = xVel - 0.2286*rVel;
  int vel4 = -(yVel + 0.2286*rVel);
  
  //calculate power to send to motors from their velocities
  int motor1 = velToPow(vel1);
  int motor2 = velToPow(vel2);
  int motor3 = velToPow(vel3);
  int motor4 = velToPow(vel4);

  //scale motor power if over maximum
  int maxMotor = max(motor1, motor2);
  maxMotor = max(maxMotor, motor3);
  maxMotor = max(maxMotor, motor4);
  maxMotor = max(maxMotor, 255);
  float scale = (float) 255/maxMotor;
  motor1 = motor1 * scale;
  motor2 = motor2 * scale;
  motor3 = motor3 * scale;
  motor4 = motor4 * scale;
  
  //drive motors
  digitalWrite(dir1, dir(motor1)); //direction pin, high/low = forward/reverse
  analogWrite(pwm1, abs(motor1)); //pwm pin, motor power magnitude
  digitalWrite(dir2, dir(motor2));
  analogWrite(pwm2, abs(motor2));
  digitalWrite(dir3, dir(motor3));
  analogWrite(pwm3, abs(motor3));
  digitalWrite(dir4, dir(motor4));
  analogWrite(pwm4, abs(motor4));
}

//-----[ Power Calculation ]------------------------------------------

//returns the motor power(0->255) to make the robot move at the input velocity(mm/s)
int velToPow(float vel) {
  //super simple converter, should be a best fit equation of recorded vel/power data
  long power = 0;
  power = vel/2;

  //check for values over 255
  if (power > 255){ power = 255;}
  else if (power < -255){ power = -255;}
  
  return power;
}

bool dir(int val) {
  if(val < 0){ return LOW; }
  return HIGH;
}

//-----[ RC Control ]-------------------------------------------------

//controls the robot through RC until the switch returns to the "Mode 0" position
//updates at roughly 15hz
void runRC() {
  Serial.print("\n***** RC CONTROL ACTIVATED *****\n\n");
  String output = "";
  int aileValue = 1500;
  int elevValue = 1500;
  int ruddValue = 1500;
  int gearValue = 1500;

  //main RC loop
  do{
    aileValue = pulseIn(ailePin, HIGH);
    elevValue = pulseIn(elevPin, HIGH);
    ruddValue = pulseIn(ruddPin, HIGH);
    gearValue = abs(pulseIn(gearPin, HIGH)-1092);
    
    xVel = -(aileValue - 1490)*maxVel/400;
    yVel = (elevValue - 1490)*maxVel/400;
    rVel = -(ruddValue - 1490)*4.3*maxVel/400;

    vectorCalc(xVel, yVel);
    
    output = "";
    output = output + aileValue + "  " + elevValue + "  " + ruddValue + "  " + gearValue;
    //Serial.println(output);
    
  } while(gearValue < 50);

  vectorCalc(xVel, yVel);

  //clear the incoming data buffer so we don't run old data
  while(Serial.available() > 0) {
    float tmp = Serial.parseFloat();
  }
  Serial.print("\n***** CUBE MODE ACTIVATED *****\n\n");
}
