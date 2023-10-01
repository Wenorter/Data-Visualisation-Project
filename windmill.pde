//======================================================
//Group 47: Dark Blue - "Jacob"
//Group Assignment 2C - Data Visualisation Project
//======================================================
//Description: Visualiser that displays current weather.
//======================================================

//Sprites
PImage grass, building;
float[] rotationSpeeds = new float[4]; // store speeds of rotation in degrees per frame for each quadrant
float[] angles = new float[4]; //store current angles of rotation for each quadrant
float randPos, randSize;
color darkGray; // Define a dark gray color

//Json Data from: https://www.visualcrossing.com/weather-history/SYDNEY
String myAPIKey = "62TUPMTCN32ZUUQM46Z68U7E8";
String JsonDataWeatherURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/SYDNEY?unitGroup=metric&elements=datetime%2Cname%2Caddress%2Ctemp%2Cwindspeedmean%2Cwinddir&include=current&key="+myAPIKey+"&contentType=json";

//Json data from Building 11 Sensors
String JsonDataWindSpeedURL = "https://eif-research.feit.uts.edu.au/api/json/?rFromDate=2023-09-20T17%3A19%3A32.149&rToDate=2023-10-01T16%3A19%3A32.149&rFamily=weather&rSensor=WS";
String JsonDataWindDirURL = "https://eif-research.feit.uts.edu.au/api/json/?rFromDate=2023-09-20T17%3A19%3A32.149&rToDate=2023-10-01T16%3A19%3A32.149&rFamily=weather&rSensor=WD";

String location;
float temperature, windDir, windSpeed;

//Wind Direction
int circleDiameter = 256; // Diameter can be changed
float arrowAngle, arrowRadians;

//Wind Turbines
int numTurbines = int(random(4,6));
windTurbine[] turbines = new windTurbine[numTurbines]; //
Button playButton, pauseButton; //Button is a local class
boolean isPlaying = true; // Initially starts in a playing state
boolean isClockRunning = true; // Variable that controls whether time passes
int hours = 0, minutes = 0, seconds = 0;

//Slider
PImage img;       // Image object
float imgX, imgY; // Current position of the image
float imgScale = 1.0; // Current scale of the image
Slider slider;    // Zoom/Out slider

void setup() {
  
  //Data
  importJsonData();
  size(1000, 1000);
  
  //Sprites
  grass = loadImage("./images/grass.png");
  //textureMode(REPEAT);
  grass.resize(1000, 1000);  
  building = loadImage("./images/building.png");
  
  //Slider
  // Initial position of the image
  imgX = width / 2;
  imgY = height / 2;
  
  // Initialize the slider
  slider = new Slider(50, height - 150, 400, 10, 1.0, 2.0, 1.0);
  
  //Turbines
  setupTurbines();
  
  textAlign(CENTER, CENTER); // Set text alignment to center
  textSize(35); // Set text size
  darkGray = color(250); // Define a dark gray color (adjust the value as needed)
  
  //random position and size is getting assigned every setup
  randPos = random(0.8, 1.2);
  randSize = random(50, 70);
}

void draw() {
  background(20);
  drawSlider();
  // Display and animate turbines
  for (int i = 0; i < numTurbines; i++) {
    turbines[i].displayTurbine();
    if (isPlaying) {
      turbines[i].rotateBlade();
    }
  }
  
  //Update angles based on rotation speeds
  for (int i = 0; i < 4; i++) {
    angles[i] += rotationSpeeds[i];
    windDirection(); // Calling the function needs no inputs,
  }
  // Display Play and Pause buttons
  

  drawGUI(); 
  playButton.display();
  pauseButton.display();
  
  imageMode(CENTER); // perfectly centers the building sprite;
  image(building, width/2, height/2);
}

void importJsonData(){
  
  //Temperature collected from weather station
  JSONObject weatherEntries = loadJSONObject(JsonDataWeatherURL);
  JSONObject currentConditions = weatherEntries.getJSONObject("currentConditions");
  
  location = weatherEntries.getString("address");
  temperature = currentConditions.getFloat("temp");
  
  //Building 11 Sensors
  //Wind Speed
  JSONArray sensorWSEntries = loadJSONArray(JsonDataWindSpeedURL);
  JSONArray lastSensorWSEntry = sensorWSEntries.getJSONArray(sensorWSEntries.size()-1);
  windSpeed = lastSensorWSEntry.getFloat(1); //get first element
  
  //Wind Direction
  JSONArray sensorDWEntries = loadJSONArray(JsonDataWindDirURL);
  JSONArray lastSensorDWEntry = sensorDWEntries.getJSONArray(sensorDWEntries.size()-1);
  windDir = lastSensorDWEntry.getFloat(1); //get first element
  
  arrowAngle = windDir-90; // -90 for offset as the positive axis of the Y coordinate is going down instead of up in traditional math,
  arrowRadians = radians(arrowAngle); // keep this conversion to radians   
}

void windDirection() {
  fill(20, 20, 20, 20);
  stroke(0);
  circle(width/2, height/2, circleDiameter);

  float circleRadius = circleDiameter / 2; // formulas for point on the circle and point half the diameter out of the circle but it probably shouldn't exceed 50 pixels, this is just for positioning.
  float arrowX1 = width/2 + sin(arrowRadians) * circleRadius;
  float arrowY1 = height/2 + cos(arrowRadians) * circleRadius;
  float arrowX2 = arrowX1 + sin(arrowRadians) * circleRadius;
  float arrowY2 = arrowY1 + cos(arrowRadians) * circleRadius;

  stroke(234, 166, 59); //pastel orange
  line(arrowX1, arrowY1, arrowX2, arrowY2); // start and end coordinates for the arrow line 
  triangle(arrowX2, arrowY2); // draw the arrow head
}

void triangle(float tipX, float tipY) {
  fill(254, 186, 79); //pastel orange
  pushMatrix();    //push matrix to translate the triangle drawn at 0,0 to the tip of the line so that it rotates around the new matrix at the line's end point
  translate(tipX,tipY);
  rotate(-arrowRadians);
  triangle(0, 0, -10, -20, 10, -20);
  popMatrix();
  noFill();
  stroke(0);  
}

//Wind Turbines
void setupTurbines(){
  frameRate(30);
  // Create turbine
  for (int i = 0; i < numTurbines; i++) {
    float xPos = 1;
    float yPos = 1;
    if ((windDir >= 0) && (windDir < 90)){xPos = random(650,850); yPos = random(250,350);}
    else if ((windDir >= 90) && (windDir < 180)){xPos = random(650,850); yPos = random(650,750);}
    else if ((windDir >= 180) && (windDir < 270)){xPos = random(150,350); yPos = random(650,750);}
    else if ((windDir >= 270) && (windDir < 360)){xPos = random(150,350); yPos = random(350,450);}
    print(windDir + " ");
    turbines[i] = new windTurbine(numTurbines, xPos, yPos);
  }
  
  // Create Play Button
  playButton = new Button((width/2)-150, height - 70, 120, 50, "Play");
  playButton.setAction(new Runnable() {
    public void run() {
      isPlaying = true;
      isClockRunning = true;
    }
  });

  // Create Pause Button
  pauseButton = new Button((width/2)+25, height - 70, 120, 50, "Pause");
  pauseButton.setAction(new Runnable() {
    public void run() {
      isPlaying = false;
      isClockRunning = false;
    }
  });
}

void mouseClicked() {
  // Check if Play or Pause button is clicked
  if (playButton.isClicked(mouseX, mouseY)) {
    isPlaying = true;
    isClockRunning = true;
  } else if (pauseButton.isClicked(mouseX, mouseY)) {
    isPlaying = false;
    isClockRunning = false;
  }
}

class Button {
  float x, y, w, h;
  String label;
  Runnable action;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void setAction(Runnable action) {
    this.action = action;
  }

  void display() {
    // Button display code here
    fill(100);
    rect(x, y, w, h);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20); 
    text(label, x + w / 2, y + h / 2);
  }

  boolean isClicked(float mouseX, float mouseY) {
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }
}

class windTurbine {
  float angle = 0;
  int quantity;
  float xPos;
  float yPos;
  float turbineSize;
  float bladeLength = random(30, 80);
  boolean bladesRotating = true;

  public windTurbine(int quantity, float xPos, float yPos) {
    this.quantity = quantity;
    this.xPos = xPos;
    this.yPos = yPos;
  }

public void displayTurbine() {
    this.drawBase();
    this.drawBlade();
  }

private void drawBase() {
    //Base
    stroke(229, 228, 226);
    strokeWeight(10);
    line(xPos, yPos, xPos, yPos - 120);
  }

private void drawBlade() {
    //Blades
    pushMatrix();
    translate(xPos, yPos - 120);
    rotate(angle);
    fill(255); // Green blade color
    stroke(229, 228, 226);
    strokeWeight(2);
    for (int i = 0; i < 3; i++) {
      beginShape();
      vertex(0, -5);
      vertex(bladeLength, 0);
      vertex(0, 5);
      endShape(CLOSE);
      rotate(PI / 1.5); // Rotate for the next blade
    }
    popMatrix();
  }

public void rotateBlade() {
    if (bladesRotating) {

      angle += windSpeed/100;
    }
  }

public void stopBladeRotation() {
    bladesRotating = false;
  }
}

void drawGUI() {
  if (isClockRunning) {
    //Time updates only as time passes
    updateTime();
  }

  String dateTime = nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2) + " " + nf(day(), 2) + "/" + nf(month(), 2) + "/" + year();

  //Top bar
  fill(20);
  rect(0, 0, width, 90);
  fill(255);
  textSize(20);
  text("Group 47: Dark Blue", 100, 30);
  text("Group Assignment 2C - Data Visualisation Project", 220, 60);
  text("Date and Time: " + dateTime, width-180, 30); 
  
  //Bottom bar
  fill(20);
  rect(0, height-90, width, 90);
  fill(255);
  text("Location: " + location, 100, height-60);
  text("Temp °C: " + temperature, 85, height-30);
  text("Wind Speed: " + windSpeed + " km/h", width-120, height-60);
  text("Wind Direction " + windDir + "°", width-120, height-30);
  
  // Draw dividing lines for quadrants
  stroke(0);
  line(width / 2, 100, width / 2, height-100); // Vertical line
  line(100, height / 2, width-100, height / 2); // Horizontal line
    
  // Draw compass direction labels
  fill(darkGray); // Dark gray fill
  textSize(35);
  text("N", width / 2, 60); // North (top)
  text("S", width / 2, height - 60); // South (bottom)
  text("E", width - 60, height / 2); // East (right)
  text("W", 60, height / 2); // West (left)
  
  //cleaning
  textAlign(CENTER, CENTER);  
}

void updateTime() {
  // time update function
  seconds++;
  if (seconds >= 60) {
    seconds = 0;
    minutes++;
    if (minutes >= 60) {
      minutes = 0;
      hours++;
      if (hours >= 24) {
        hours = 0;
      }
    }
  }
}

void initClock() {
  // clock initialization function
  hours = 0;
  minutes = 0;
  seconds = 0;
}

//========================================SLIDER
void drawSlider(){
    //slider
  // Zoom/Out and move the image
  pushMatrix();
  translate(imgX, imgY);
  scale(imgScale);
  imageMode(CENTER);
  image(grass, 0, 0);
  popMatrix();
  
  // Update the slider
  slider.update();
  imgScale = slider.getValue(); // Set the image scale based on the slider value
  
  // Limit the frame's position
  imgX = constrain(imgX, width / 2 - grass.width * imgScale / 2, width / 2 + grass.width * imgScale / 2);
  imgY = constrain(imgY, height / 2 - grass.height * imgScale / 2, height / 2 + grass.height * imgScale / 2);
}

void mouseDragged() {
  if (mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height) {
    float dx = mouseX - pmouseX;
    float dy = mouseY - pmouseY;
    imgX += dx;
    imgY += dy;
  }
}

class Slider {
  float x, y;     // Slider's position
  float w, h;     // Slider's width and height
  float minValue, maxValue; // Slider's minimum and maximum values
  float value;    // Current slider value

  Slider(float x, float y, float w, float h, float minValue, float maxValue, float startValue) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.value = startValue;
  }

  void update() {
    // Draw the slider
    fill(150);
    rect(x, y, w, h);
    
    // Draw the slider handle
    float handleX = map(value, minValue, maxValue, x, x + w);
    fill(234, 166, 59);
    rect(handleX - 10, y - 5, 20, h + 10); // Draw it larger
    
    // Interact with the mouse to change the value
    if (mousePressed && mouseX >= x && mouseX <= x + w && mouseY >= y - 5 && mouseY <= y + h + 5) {
      value = map(mouseX, x, x + w, minValue, maxValue);
      value = constrain(value, minValue, maxValue);
    }
    
    // Display text
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text("Zoom-In/Zoom-Out", x + w / 2, y - 10);
  }

  float getValue() {
    return value;
  }
}
