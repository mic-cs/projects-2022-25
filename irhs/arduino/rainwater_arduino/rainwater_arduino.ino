#include <WiFi.h>

#include <FirebaseESP32.h>
#include <ESP32Servo.h>
#include <LiquidCrystal_I2C.h>

// WiFi credentials
#define WIFI_SSID "kiranks"
#define WIFI_PASSWORD "10341069876"

// Firebase credentials
#define FIREBASE_HOST "https://host.firebasedatabase.app/"
#define FIREBASE_AUTH "xxxx"

// Firebase configuration and authentication
FirebaseConfig config;
FirebaseAuth auth;
FirebaseData firebaseData;

// Sensor Pins
#define TRIG_PIN 22
#define ECHO_PIN 23
#define SOIL_PIN 35
#define RAIN_PIN 34
#define PH_PIN 33
#define WATERPUMP 25
#define PUMP 26
#define SERVO_PIN 15

// LCD Display
LiquidCrystal_I2C lcd(0x27, 20, 4);
Servo rainLidServo;

void setup() {
  Serial.begin(115200);

  // Initialize LCD
  Wire.begin(21, 19);
  lcd.begin(20, 4);
  lcd.backlight();

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi...");
  lcd.setCursor(0, 0);
  lcd.print("Connecting to Wi-Fi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to Wi-Fi.");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Wi-Fi Connected!");

  // Set up Firebase
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Sensor Pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(SOIL_PIN, INPUT);
  pinMode(RAIN_PIN, INPUT);
  pinMode(PH_PIN, INPUT);
  pinMode(WATERPUMP, OUTPUT);
  pinMode(PUMP, OUTPUT);

  // Servo Motor
  rainLidServo.attach(SERVO_PIN);
  rainLidServo.write(0); // Initially keep the lid closed
}

void loop() {
  // Ultrasonic Sensor (Water Level)
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  long duration = pulseIn(ECHO_PIN, HIGH);
  float distance = duration * 0.034 / 2;

  // Soil Moisture Sensor
  int soilMoistureValue = analogRead(SOIL_PIN);

  // Rain Sensor
  int rainValue = analogRead(RAIN_PIN);

  // pH Sensor Reading & Corrected Calibration
  int rawValue = analogRead(PH_PIN);
  float voltage = (rawValue / 4095.0) * 3.3; // Convert ADC to voltage
  float pHValue = 7.0 - ((voltage - 2.5) / 0.18); // Corrected pH conversion

  // Display Data on LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Dist: ");
  lcd.print(distance);
  lcd.print("cm");

  lcd.setCursor(0, 1);
  lcd.print("Soil: ");
  lcd.print(soilMoistureValue);

  lcd.setCursor(0, 2);
  lcd.print("Rain: ");
  lcd.print(rainValue);

  lcd.setCursor(0, 3);
  lcd.print("pH: ");
  lcd.print(pHValue, 2); // Show 2 decimal places

  // Print Data to Serial Monitor
  Serial.print("Distance: "); Serial.print(distance); Serial.println(" cm");
  Serial.print("Soil Moisture: "); Serial.println(soilMoistureValue);
  Serial.print("Rain Sensor: "); Serial.println(rainValue);
  Serial.print("Raw pH Value: "); Serial.println(rawValue);
  Serial.print("Voltage: "); Serial.println(voltage);
  Serial.print("Calibrated pH: "); Serial.println(pHValue);

  // Push Data to Firebase
  Firebase.setFloat(firebaseData, "/Sensor/Distance", distance);
  Firebase.setInt(firebaseData, "/Sensor/Moisture", soilMoistureValue);
  Firebase.setInt(firebaseData, "/Sensor/Rain", rainValue);
  Firebase.setFloat(firebaseData, "/Sensor/PH", pHValue);

  // Control Servo Motor (Rain Lid)
  if (rainValue < 4000) { // Rain detected
    rainLidServo.write(90); // Open the lid
  } else {
    rainLidServo.write(0); // Close the lid
  }

  // Control Water Pump
  if (soilMoistureValue > 4000) {
    digitalWrite(WATERPUMP, LOW);
    digitalWrite(PUMP, LOW);
  } else {
    digitalWrite(WATERPUMP, HIGH);
    digitalWrite(PUMP, HIGH);
  }

  delay(2000); // Delay before next reading
}
