//================================================
//Group 47: Dark Blue - "Jacob"
//Group Assignment 2C - Data Visualisation Project
//================================================
PFont font;
PImage img1, img2, background;
float scaleFactor = 1.0;
float crosshairOffset = 50;


//Setup
void setup(){
  size(1000, 1000);
  
  drawUI();
  
  // Load your images
  //img1 = loadImage("image1.jpg");
  //img2 = loadImage("image2.jpg");
  
  // Position the images
  //img1.resize(400, 0);
  //img2.resize(400, 0);
  //image(img1, 50, 50);
  //image(img2, 450, 50);
}

//Draw
void draw(){


}

void drawUI(){
  strokeWeight(3);
  line(width/2, crosshairOffset, width/2, height-crosshairOffset);
  line(crosshairOffset, height/2, width-crosshairOffset, height/2);
  background = loadImage("./images/grass.jpg");
}

//Allow to zoom in and out of a specific image using the keyboard or by clicking on the image with the + and - buttons.
void keyPressed() {
  // Check if the "+" or "-" keys were pressed
  if (key == '+' || key == '=') {
    scaleFactor += 0.1; // Zoom in
  } else if (key == '-') {
    scaleFactor -= 0.1; // Zoom out
  }
  
  // Ensure the scale factor stays within a reasonable range
  scaleFactor = constrain(scaleFactor, 0.0, 1.0);
}
