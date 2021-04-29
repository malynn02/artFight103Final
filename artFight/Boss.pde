class Boss {
  //vars
  float x;
  float y;
  float size;
  color c;
  float moveSpeed;
  float topBound;
  float bottomBound;
  float leftBound;
  float rightBound;
  boolean movingLeft;
  boolean movingRight;
  boolean isDead;
  int bHealth;

  //*******************************************************************************

  //constructor
  Boss(float bX, float bY, float bSize) {
    x = bX;
    y = bY;
    size = bSize;
    c = color(255, 255, 0);
    moveSpeed = 1;
    topBound = bY;
    bottomBound = bY + bSize;
    leftBound = bX;
    rightBound = bX + bSize;
    movingLeft = true;
    movingRight = false;
    isDead = false;
    bHealth = 10;
  }

  //*******************************************************************************

  //render the boss
  void renderBoss() {
    fill(c);
    stroke(c);
    square(x, y, size);
  }

  //*******************************************************************************

  //resetting boundaries
  void resetBoundaries() {
    topBound = y;
    bottomBound = y + size;
    leftBound = x;
    rightBound = x + size;
  }

  //*******************************************************************************

  //movement that follows the player
  void followPlayer(Player p1) {
    if (p1.x <= x) {
      movingLeft = true;
      movingRight = false;
    }
    if (p1.x >= x) {
      movingLeft = false;
      movingRight = true;
    }
    if (movingLeft == true && movingRight == false) {
      x = x - moveSpeed;
    }
    if (movingLeft == false && movingRight == true) {
      x = x + moveSpeed;
    }
  }

  //*******************************************************************************

  //collision with the player
  void bCollision(Player p1) {
    if (topBound <= p1.bottomBound) {
      if (bottomBound >= p1.topBound) {
        if (rightBound >= p1.leftBound) {
          if (leftBound <= p1.rightBound) {
            p1.health = p1.health - 1;
            inHitFrames = true;
            startTime = millis();
          }
        }
      }
    }
  }

  //*******************************************************************************

  //dying when health reaches 0
  void bDeath() {
    if (bHealth <= 0) {
      isDead = true;
    }
  }

  //*******************************************************************************

  //display boss health
  void displayHealth() {
    fill(255);
    textSize(25);
    text("boss health:", 300, 30);
    text(bHealth, 450, 30);
  }
}
