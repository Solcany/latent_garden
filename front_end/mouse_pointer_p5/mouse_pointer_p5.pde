void setup() {
  size(500, 500); 
}

void draw() {
  background(0);
  PVector m = new PVector(mouseX, mouseY);
  PVector middle = new PVector(width/2, height/2);
  PVector dir = m.sub(middle).normalize();
  println(dir);
  stroke(255,0,0);
  PVector m_norm = m.normalize();
  line(middle.x, middle.y, m_norm.x * 20, m_norm.y * 20); 
}
