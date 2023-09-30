//================================================
//Group 47: Dark Blue - "Jacob"
//Group Assignment 2C - Data Visualisation Project
//================================================
//Description: Visualiser that displays current weather,
//================================================

//Offsets
float offset = 70;
float textOffset = 35;
//float bearingOffset = 8;

PImage grass, building;
float[] rotationSpeeds = new float[4]; // Array to store speeds of rotation in degrees per frame for each quadrant
float[] angles = new float[4]; // Array to store current angles of rotation for each quadrant
float randPos, randSize;
color darkGray; // Define a dark gray color

//Json Data from: https://www.visualcrossing.com/weather-history/SYDNEY
String myAPIKey = "62TUPMTCN32ZUUQM46Z68U7E8";
String JsonDataURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/SYDNEY?unitGroup=metric&elements=datetime%2Cname%2Caddress%2Ctemp%2Cwindspeedmean%2Cwinddir&include=current&key="+myAPIKey+"&contentType=json";
String location;
float temperature, windDir, windSpeedMean;

void setup() {
  importJsonData();
  size(1000, 1000);
  
  //Sprites
  grass = loadImage("./images/grass.png");
  grass.resize(1000, 1000);
  
  building = loadImage("./images/building.png");
  
  // Set initial windmill speeds and angles for each quadrant
  rotationSpeeds[0] = radians(windSpeedMean); // Q1
  rotationSpeeds[1] = radians(windSpeedMean); // Q2
  rotationSpeeds[2] = radians(windSpeedMean); // Q3
  rotationSpeeds[3] = radians(windSpeedMean); // Q4
  
  angles[0] = 0; // Initial angle for Q1
  angles[1] = 0; // Initial angle for Q2
  angles[2] = 0; // Initial angle for Q3
  angles[3] = 0; // Initial angle for Q4
  
  textAlign(CENTER, CENTER); // Set text alignment to center
  textSize(35); // Set text size
  darkGray = color(250); // Define a dark gray color (adjust the value as needed)
  
  //random position and size is getting assigned every setup
  randPos = random(0.8, 1.2);
  randSize = random(50, 70);
  
}

void draw() {
  background(grass);
 
  
  //title
  fill(20);
  rect(0, 0, width*2, 180);
  fill(255);
  textSize(20);
  text("Group 47: Dark Blue", 100, 30);
  text("Group Assignment 2C - Data Visualisation Project", 220, 60);
   
  // Draw dividing lines for quadrants
  stroke(0);
  line(width / 2, 100, width / 2, height-100); // Vertical line
  line(100, height / 2, width-100, height / 2); // Horizontal line
   
  //Weather info
  fill(20);
  rect(height-30, height, width*2, 180);
  fill(255);
  textSize(20);
  text("Location: " + location, 100, height-60);
  text("Temp °C: " + temperature, 85, height-30);
  
  text("Wind Speed: " + windSpeedMean + " km/h", width-120, height-60);
  text("Wind Direction " + windDir + "°", width-120, height-30);
  
  // Draw compass direction labels
  fill(darkGray); // Dark gray fill
  textSize(35);
  text("N", width / 2, 60); // North (top)
  text("S", width / 2, height - 60); // South (bottom)
  text("E", width - 60, height / 2); // East (right)
  text("W", 60, height / 2); // West (left)
  
  // Draw windmills in each quadrant with respective rotation speeds and angles
  drawWindmill((width / 4), height / 4, randSize, 50, angles[0]); // Q1
  drawWindmill(width / 4 * 3, height / 4, randSize, 50, angles[1]); // Q2
  drawWindmill(width / 4, height / 4 * 3, randSize, 50, angles[2]); // Q3
  drawWindmill(width / 4 * 3, height / 4 * 3, randSize, 50, angles[3]); // Q4
  
  image(building, (width/2)-90, (height/2)-100);

  //Update angles based on rotation speeds
  for (int i = 0; i < 4; i++) {
    angles[i] += rotationSpeeds[i];
  }
}

void importJsonData(){
  
  JSONObject weatherEntries = loadJSONObject(JsonDataURL);
  location = weatherEntries.getString("address");
  JSONArray days = weatherEntries.getJSONArray("days");
  JSONObject mostRecentDay = days.getJSONObject(0);
    
  temperature = mostRecentDay.getFloat("temp");
  windDir = mostRecentDay.getFloat("winddir");
  windSpeedMean = mostRecentDay.getFloat("windspeedmean");
    
}

void drawWindDirection(){
  pushMatrix();
  circle(width/1.35, height-45, 50);
  line(width/1.35, height-45, 0, 0);
  popMatrix();
}

void drawWindmill(float x, float y, float size, float length, float angle) {
  stroke(20);
  strokeWeight(4);

  // Draw windmill blades
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    translate(x, y-(size/2)); // Translate to the windmill's position
    rotate(angle + TWO_PI / 4 * i);
    line(0, 0, 0, -length);
    popMatrix();
  }

  // Draw windmill base
  strokeWeight(2);
  fill(200);
  rectMode(CENTER);
  rect(x, y + length / 2, size / 10, size * 2);
}
