#include <WiShield.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {192,168,3,11};
unsigned char gateway_ip[] = {192,168,3,1};
unsigned char subnet_mask[] = {255,255,255,0};
const prog_char ssid[] PROGMEM = {"Piscine"};
unsigned char security_type = 3;
const prog_char security_passphrase[] PROGMEM = {"p1scine!"};
prog_uchar wep_keys[] PROGMEM = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d};
unsigned char wireless_mode = WIRELESS_MODE_INFRA;

unsigned char ssid_len;
unsigned char security_passphrase_len;
//---------------------------------------------------------------------------

unsigned char thermometer_pin = 2;
char socket_response[25];

float convert_to_celsius(int value) {
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

float celsius_to_fahrenheit(float celsius) {
  return celsius * 9/5 + 32;
}

void setup()
{
  WiFi.init();
}

void loop()
{
  WiFi.run();
  int value = analogRead(thermometer_pin);
  float celsius = convert_to_celsius(value);
  float fahrenheit = celsius_to_fahrenheit(celsius);
  String("{\"temperature\": " + String((int)fahrenheit) + "}").toCharArray(socket_response, 25);
}
