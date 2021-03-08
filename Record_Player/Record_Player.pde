/*
 Record_Player - Made by Jack Lusenhop
 Date: March 6th, 2020
 */


// Imports and vars
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim m;
AudioPlayer player;
FFT fft;

int x; // Used to make the circle spin
int radius = 200; // Radius in pixels of the circle

void setup(){
  fullScreen();
  noCursor();
  
  m = new Minim(this);
    
  // Load music
  player = m.loadFile("Jazz Beat.mp3", 1024);
  player.play();
  
  // Initialize audio analyzer
  fft = new FFT(player.bufferSize(), player.sampleRate());
  
  x = 0; 
}

void draw(){
  translate(width/2, height/2);
  background(0);
  
  // Create circle interior
  noStroke();
  fill(200, 0, 0);
  circle(0, 0, 120); // White circle
  fill(255);
  circle(cos(radians(x))*5, sin(radians(x))*5, 110); // Red circle
  fill(0);
  circle(0, 0, 10); // Black circle
  if(player.isPlaying()) x += 2; // Circle only rotates while music is playing

  // Audio Visualization
  fft.forward(player.mix);
  float bands = fft.specSize();
  
  for(int i = 0; i < bands*2; i++){ 
    
    // Starting positions of line
    float start_x = radius*cos(PI*(i+x)/bands);
    float start_y = radius*sin(PI*(i+x)/bands);
    
    // Draw line based on sound
    stroke(255);
    strokeWeight(5);
    if (i < bands){
      // Line based on band length
      line(start_x, start_y, start_x + fft.getBand(i)*7*cos(PI*(i+x)/bands), start_y + fft.getBand(i)*7*sin(PI*(i+x)/bands));
    } else {
      // Line based on frequency
      line(start_x, start_y, start_x + fft.getFreq(i)*5*cos(PI*(i+x)/bands), start_y + fft.getFreq(i)*5*sin(PI*(i+x)/bands));
    }
  }
}
