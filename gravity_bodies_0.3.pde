/*
 A system of bodies solely under gravitational force.
 If you click anywhere on the  screen a new body will pop at that point.
 You can also change inital number of bodies by changing the arraySize variable(MAX 100) and change strength of gravitational force by changing G.
 You can remove the bounce method if you don't want them to bounce at the edges.
 You can remove the collide method if you don't want them to collide.
 */



float G  = 0.005;//Gravitational constant

PVector force;
int arraySize = 50;//Change number of bodies here

Body[] b;

void setup() {
  size(800, 800);
  //fullScreen();
  b = new Body[100];

  for (int i = 0; i<arraySize; i++) {
    b[i] = new Body(random(width), random(height));
  }
}

void draw() {
  background(255);
  fill(128);

  //to display, bounce, and change the values of velocities of bodies
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

  //finally change the positon vector of bodies and make them move
  for (int i = 0; i<arraySize; i++)
    b[i].move();


  // Collision changes velocities of two bodies at the same time, hence inner loop starts from (i+1)
  for ( int i = 0; i<arraySize; i++) {
    for ( int j = i+1; j< arraySize; j++) {
      b[i].collide(b[j]);
    }
  }
}

class Body {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float size;


  Body(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    mass = 0.3*50;
    size = mass*2;
  }

  void display() {

    circle(location.x, location.y, size);
  }

  void updateValues() {

    velocity.add(acceleration);
    acceleration.mult(0);
  }

  void move() {
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

  // how collision works - if A and B are colliding, I am swapping their velocity vectors.
  void collide(Body b) {
    PVector normal = PVector.sub(location, b.location);
    float dist = normal.mag();

    if (dist<= (size/2 + b.size/2)) {

      PVector temp = velocity.copy();

      velocity.mult(0);
      velocity.add(b.velocity);

      b.velocity.mult(0);
      b.velocity.add(temp);
    }
  }
}


void mouseClicked() {

  for (int i = arraySize; i<arraySize +1; i++) {
    b[i] = new Body(mouseX, mouseY);
  }
  arraySize++;
}
