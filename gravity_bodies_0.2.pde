/*
A system of bodies solely under gravitational force.
 If you click anywhere on the  screen a new body will pop at that point.
 You can also change inital number of bodies by changing the arraySize variable(MAX 100) and change strength of gravitational force by changing G.
 You can remove the bounce method if you don't want them to bounce at the edges.
 */



float G  = 0.05;//Gravitational constant

PVector force;
int arraySize = 900;//Change number of bodies here

Body[] b;

void setup() {
  size(800, 800);
  //fullScreen();
  b = new Body[1000];

  for (int i = 0; i<arraySize; i++) {
    b[i] = new Body(random(width), random(height));
  }
  frameRate(24);
}

void draw() {
    //background(255);
  smooth();
  fill(255);
  rect(0, 0, width, height);

//  noStroke();

  for (int i = 0; i<arraySize; i++) {
    b[i].display();
    b[i].bounce();

    for (int j = 0; j<arraySize; j++) {
      if (i !=j) {
        force = b[i].gravity(b[j]);
        b[i].applyForce(force);
        b[i].updateValues();
      }
    }
  }
  for (int i = 0; i<arraySize; i++)
    b[i].move();
}

class Body {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float size;
  color bColor;


  Body(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    mass = random(0.2, 0.4)*50;
    size = mass*2;
  //  bColor= color(random(255), random(255), random(255));
  }

  void display() {
    fill(128);
    circle(location.x, location.y, size/2);
  }

  void updateValues() {
   // /*
if(acceleration.mag()>.0001){
      acceleration.normalize();
      acceleration.mult(.0001);
    }//*/
    velocity.add(acceleration);
    acceleration.mult(0);
  }
  void move() {
    //*
    if(velocity.mag()>5){
      velocity.normalize();
      velocity.mult(5);
    }//*/
    location.add(velocity);
  }
  void applyForce(PVector force) {
    force.div(mass);
    acceleration.add(force);
  }

  PVector gravity(Body b) {

    PVector f = PVector.sub(b.location, location);
    float dist = f.mag();

    f.mult(G*mass*b.mass/sq(dist));


    return f;
  }

  void bounce() {

    if (location.x <=0 || location.x>= width) {
      velocity.x = -velocity.x;
    }
    if ( location.y <= 0 || location.y>= height) {
      velocity.y  = -velocity.y;
    }
  }
}

void mouseClicked() {


  for (int i = arraySize; i<arraySize +1; i++) {
    b[i] = new Body(mouseX, mouseY);
  }
  arraySize++;
}
