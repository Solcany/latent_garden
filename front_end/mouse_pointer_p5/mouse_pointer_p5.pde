float line_length = 100.0;
PVector middle;

void setup() {
  size(500, 500); 
  middle = new PVector(width/2, height/2);
}

void draw() {
  background(0);
  float angle = atan2(middle.y - mouseY, middle.x - mouseX);
  PVector dir = new PVector(-cos(angle), -sin(angle));
  stroke(255,0,0);  
  line(middle.x, middle.y, middle.x + dir.x * line_length, middle.y + dir.y * line_length);
}
