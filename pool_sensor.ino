#include <WiFlyHQ.h>

const char ssid[] = "Piscine";
const char passphrase[] = "p1scine!";

unsigned char thermometer_pin = A0;

WiFly wifly;

void setup()
{
  Serial.begin(9600);

  if(!wifly.begin(&Serial, NULL)) {
    wifly.terminal();
  }

  if(!wifly.isAssociated()) {
      wifly.join(ssid, passphrase, true);
  }

  wifly.setDeviceID("poolclient");
  wifly.setIpProtocol(WIFLY_PROTOCOL_TCP);

  if(wifly.isConnected()) {
    wifly.close();
  }
  
  pinMode(thermometer_pin, INPUT);
}

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

void loop()
{
  if(wifly.isConnected() == false) {
    wifly.open("192.168.3.4", 8805);
  } else {
    if(wifly.available() < 0) {
      wifly.close();
      previousValue = 0;
    } else {
      int value = analogRead(thermometer_pin);
      float fahrenheit = celsiusToFahrenheit(convertToCelsius(value));
      
      if((int)fahrenheit != previousValue) {
        char responseBuffer[25];
        String response = "{\"temperature\": " + String((int)fahrenheit) + "}";
        response.toCharArray(responseBuffer, 25);
        wifly.write(responseBuffer);
        previousValue = (int)fahrenheit;
      }
    }
  }
  delay(1000);
}