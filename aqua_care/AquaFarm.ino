#include <WiFi.h>
#include <LiquidCrystal_I2C.h>
#include <FirebaseESP32.h>
#include <DHT.h> // Include the DHT library
#include <ESP32Servo.h>  // Include the ESP32Servo library

// WiFi credentials
#define WIFI_SSID "kiranks"
#define WIFI_PASSWORD "10341069876"

// Firebase credentials
#define FIREBASE_HOST "https://aquacare-63a47-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "AIzaSyDvFNeQTYpYzrhHd-o1dE3n2gViab7pqMk"

// Firebase configuration and authentication
FirebaseConfig config;
FirebaseAuth auth;

// Firebase object
FirebaseData firebaseData;

// Ultrasonic sensor pins
#define TRIG_PIN 22
#define ECHO_PIN 23

// pH sensor pin (GPIO 34)
#define PH_SENSOR_PIN 34

// LDR sensor pin (GPIO 32)
#define LDR_PIN 32

// DHT11 sensor configuration
#define DHT_PIN 5 // Pin where DHT11 is connected
#define DHT_TYPE DHT11 // Specify the DHT sensor type
DHT dht(DHT_PIN, DHT_TYPE);

// Water pump and oxygen pump pins
#define WATER_PUMP_PIN 25
#define OXYGEN_PUMP_PIN 26

// Servo motor pin (GPIO 33 for example)
#define FEEDING_SERVO_PIN 15

// Initialize 20x4 LCD display
LiquidCrystal_I2C lcd(0x27, 20, 4);

// Initialize ESP32Servo object
Servo feedingServo;

void setup() {
  Serial.begin(115200);

  // Initialize 20x4 LCD
  Wire.begin(21, 19);  // Set SDA to GPIO 21 and SCL to GPIO 19
  lcd.begin(20, 4);  // Initialize 20x4 LCD
  lcd.backlight();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi...");
  lcd.setCursor(3, 3);
  lcd.print("Connecting to Wi-Fi.");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    lcd.setCursor(6, 1);
    lcd.print("AQUA-FARM");
  }
  Serial.println("Connected to Wi-Fi.");
  
  // Set up Firebase config
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

  // Initialize Firebase
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Set up ultrasonic sensor pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  // Set up pH sensor pin (GPIO 34)
  pinMode(PH_SENSOR_PIN, INPUT);

  // Set up LDR sensor pin (GPIO 32)
  pinMode(LDR_PIN, INPUT);

  // Set up water pump and oxygen pump pins
  pinMode(WATER_PUMP_PIN, OUTPUT);
  pinMode(OXYGEN_PUMP_PIN, OUTPUT);

  // Initialize pumps to off
  digitalWrite(WATER_PUMP_PIN, LOW);
  digitalWrite(OXYGEN_PUMP_PIN, LOW);

  // Initialize DHT11 sensor
  dht.begin();

  // Initialize feeding servo
  feedingServo.attach(FEEDING_SERVO_PIN);
  feedingServo.write(0); // Set the servo to the initial position (0 degrees)

  lcd.clear();
}

void loop() {
  // Initialize variables
  String automatic = "off"; // Default value for automatic mode
  String waterPump = "off"; // Default value for manual mode
  String feedingSwitch = "off"; // Default value for feedingSwitch

  // Read the automatic mode from Firebase
  if (Firebase.getString(firebaseData, "/settings/automatic")) {
    automatic = firebaseData.stringData();
    Serial.print("Automatic mode from Firebase: ");
    Serial.println(automatic);
  } else {
    Serial.print("Failed to read '/settings/automatic', reason: ");
    Serial.println(firebaseData.errorReason());
  }

  // Read the feedingSwitch value from Firebase
  if (Firebase.getString(firebaseData, "/settings/feedingSwitch")) {
    feedingSwitch = firebaseData.stringData();
    Serial.print("Feeding Switch value from Firebase: ");
    Serial.println(feedingSwitch);
  } else {
    Serial.print("Failed to read '/settings/feedingSwitch', reason: ");
    Serial.println(firebaseData.errorReason());
  }

  // Read the waterPump setting from Firebase (for manual mode control)
  if (Firebase.getString(firebaseData, "/settings/waterPump")) {
    waterPump = firebaseData.stringData();
    Serial.print("Water pump setting from Firebase: ");
    Serial.println(waterPump);
  } else {
    Serial.print("Failed to read '/settings/waterPump', reason: ");
    Serial.println(firebaseData.errorReason());
  }

  // Control the servo based on the feedingSwitch value
  if (feedingSwitch == "on") {
    feedingServo.write(90);  // Move servo to 90 degrees when feedingSwitch is "on"
    Serial.println("Feeding switch is ON: Servo turned to 90 degrees.");
  } else {
    feedingServo.write(0);  // Keep the servo at 0 degrees when feedingSwitch is "off"
    Serial.println("Feeding switch is OFF: Servo remains at 0 degrees.");
  }

  // Read the ultrasonic sensor value (distance)
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  long duration = pulseIn(ECHO_PIN, HIGH);
  float distance = duration * 0.034 / 2;

  // Read the pH sensor value
  int phValue = (analogRead(PH_SENSOR_PIN));
  float phLevel = map(phValue, 0, 4095, 0, 14);  // Map to pH scale (0-14)

  // Read the LDR sensor value
  int ldrValue = analogRead(LDR_PIN);
  int lightIntensity = map(ldrValue, 0, 4095, 0, 100);  // Light intensity in percentage

  // Read temperature and humidity from DHT11 sensor
  float temperature = dht.readTemperature(); // Temperature in Celsius
  float humidity = dht.readHumidity(); // Humidity percentage

  // Display sensor data on the LCD
  lcd.setCursor(0, 1);
  lcd.print("Dist:");
  lcd.print(int(distance));

  lcd.setCursor(0, 2);
  lcd.print("pH:");
  lcd.print(int(phLevel-7));

  lcd.setCursor(10, 1);
  lcd.print("Light:");
  lcd.print(lightIntensity);
  lcd.print("%");

  lcd.setCursor(10, 2);
  lcd.print("Temp:");
  lcd.print(temperature);

  lcd.setCursor(0, 3);
  lcd.print("Hum:");
  lcd.print(int(humidity));
  lcd.print("%");

  // Push sensor data to Firebase
  Firebase.setFloat(firebaseData, "/Sensor/distance", distance);
  Firebase.setFloat(firebaseData, "/Sensor/phLevel", phLevel-7);
  Firebase.setFloat(firebaseData, "/Sensor/light", lightIntensity);
  Firebase.setFloat(firebaseData, "/Sensor/temperature", temperature);
  Firebase.setFloat(firebaseData, "/Sensor/humidity", humidity);

  // Perform actions based on the mode (automatic or manual)
  if (automatic == "on") {
    Serial.println("Running in Automatic Mode");
    lcd.setCursor(0, 0);
    lcd.print("Automatic mode ON  ");
    lcd.print(automatic);

    // Automatic mode logic: Control pumps based on distance and light intensity
    if (distance > 8) {
      digitalWrite(WATER_PUMP_PIN, HIGH);  // Turn on water pump
      digitalWrite(OXYGEN_PUMP_PIN, LOW);  // Turn off oxygen pump
    }
    if (lightIntensity <= 50) {
      digitalWrite(OXYGEN_PUMP_PIN, HIGH);  // Turn on oxygen pump
      digitalWrite(WATER_PUMP_PIN, LOW);  // Turn off water pump
    }
  } else if (automatic == "off") {
    Serial.println("Running in Manual Mode");
    lcd.setCursor(0, 0);
    lcd.print("Automatic mode OFF ");
    lcd.print(automatic);

    // Manual mode logic: Check if water pump setting is "on" in Firebase
    if (waterPump == "on") {
      digitalWrite(WATER_PUMP_PIN, HIGH);  // Turn on water pump in manual mode
      Serial.println("Water pump turned on in manual mode.");
    } else {
      digitalWrite(WATER_PUMP_PIN, LOW);  // Turn off water pump in manual mode
      Serial.println("Water pump turned off in manual mode.");
    }

    // Ensure oxygen pump is off in manual mode
    digitalWrite(OXYGEN_PUMP_PIN, LOW);
  }

  delay(2000);  // Adjust delay as needed
}
