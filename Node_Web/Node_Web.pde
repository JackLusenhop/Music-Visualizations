import ddf.minim.*;
import ddf.minim.analysis.*;

Minim m;
AudioPlayer player;
FFT fft;

Node[] nodes = new Node[1200];

void setup() {
  fullScreen();
  smooth();
  
  //Initialize Nodes
  for(int i = 0; i < nodes.length; i++){
    nodes[i] = new Node(random(width), random(height));
  }
  
  //Initialize Sound
  m = new Minim(this);
  player = m.loadFile("Piano Song.mp3", 1024);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  player.play();
}

void draw() {
  noStroke();
  noCursor();
  background(20);
  
  // Play Music
  fft.forward(player.mix);
  
  for(int i = 0; i < nodes.length; i++){
    float freq = fft.getFreq(dist(nodes[i].loc.x, nodes[i].loc.y, width/2, height/2)*2.2); // Multiplier = 2.2 higher to show more frequencies
    
    //Draw Lines
    strokeWeight(freq/15);
    stroke((1-nodes[i].loc.y/800)*255, 0, (nodes[i].loc.y/800)*255);
    for(int j = i + 1; j < nodes.length; j++){
      Node other = nodes[j];
      float dist = nodes[i].loc.dist(other.loc);
      if (dist > 0 && dist < 45){
        line(nodes[i].loc.x, nodes[i].loc.y, other.loc.x, other.loc.y);
      }
    }
    stroke(255);
    nodes[i].run();
  }
  
}
