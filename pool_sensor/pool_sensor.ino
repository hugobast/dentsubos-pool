#include <SPI.h>
#include <WiFly.h>
#include "LowPower.h"

char * ssid = "Piscine";
char * pass = "p1scine!";
char * server = "192.168.3.4";
int port = 8805;

unsigned char thermometer_pin = A0;

WiFlyClient client;

float convertToCelsius(int value) {
  if(value < 340) {
    return -5.0 + (value - 120.0) / (340 - 120) * (15.0 + 5.0) + 3.5;
  } else if(value < 500) {
    return 15.0 + (value - 340.0) / (500 - 340) * (30 - 15.0) + 3.5;
  } else if(value < 660) {
    return 30.0 + (value - 500.0) / (660 - 500) * (50 - 30) + 3.5;
  } else {
    return 50.0 + (value - 660.0) / (790 - 660) * (75 - 50) + 3.5;
  }
}

float celsiusToFahrenheit(float celsius) {
  return celsius * 9/5 + 32;
}

int previousValue = 0;

void setup()
{
  LowPower.powerSave(SLEEP_2S, ADC_OFF, BOD_OFF, TIMER2_OFF);
  
  Serial.begin(9600);
  WiFly.setUart(&Serial);
  WiFly.begin();
  WiFly.join(ssid, pass, true);
}

void loop()
{
  LowPower.powerSave(SLEEP_2S, ADC_OFF, BOD_OFF, TIMER2_OFF);

  int value = analogRead(thermometer_pin);
  float fahrenheit = celsiusToFahrenheit(convertToCelsius(value));
  
  if((int)fahrenheit != previousValue) {
    client.connect(server, port);
    String response = "{\"temperature\": " + String((int)fahrenheit) + "}";
    client.println(response);
    previousValue = (int)fahrenheit;
    client.stop();
  }
}
