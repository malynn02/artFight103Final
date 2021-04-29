class Enemy {
  //vars
  float x;
  float y;
  float eW;
  float eH;
  color c;
  float moveSpeed;
  float topBound;
  float bottomBound;
  float leftBound;
  float rightBound;
  boolean movingLeft;
  boolean movingRight;
  boolean isDead;
  float lStop;
  float rStop;

  //*******************************************************************************

  //constructor
  Enemy(Platform plat) {
    eW = 10;
    eH = 25;
    x = plat.x - eW;
    y = plat.y - eH;
    c = color(255, 0, 255);
    moveSpeed = random(.5, 2);
    topBound = y;
    bottomBound = y + eH;
    leftBound = x;
    rightBound = x + eW;
    movingLeft = true;
    movingRight = false;
    isDead = false;
    lStop = plat.leftBound;
    rStop = plat.rightBound;
  }

  //*******************************************************************************

  //render
  void renderEnemy() {
    fill (c);
    stroke (c);
    rect (x, y, eW, eH);
  }

  //*******************************************************************************

  //resetting boundaries
  void resetBoundaries() {
    topBound = y;
    bottomBound = y + eH;
    leftBound = x;
    rightBound = x + eW;
  }

  //*******************************************************************************

  //move the enemy
  void moveEnemy() {
    if (movingLeft == true && movingRight == false) {
      if (leftBound >= lStop) {
        x = x - moveSpeed;
      }
      if (leftBound <= lStop) { 
        movingLeft = false;
        movingRight = true;
      }
    }

    if (movingLeft == false && movingRight == true) {
      if (rightBound <= rStop) {
        x = x + moveSpeed;
      } 
      if (rightBound >= rStop) {  
        movingRight = false;
        movingLeft = true;
      }
    }
  }

  //*******************************************************************************

  //collision with player
  void enCollision(Player p1) {
    if (topBound <= p1.bottomBound) {
      if (bottomBound >= p1.topBound) {
        if (rightBound >= p1.leftBound) {
          if (leftBound <= p1.rightBound) {
            p1.health = p1.health - 1;
            inHitFrames = true;
            startTime = millis(); // reset player hit frame timer
          }
        }
      }
    }
  }
}
