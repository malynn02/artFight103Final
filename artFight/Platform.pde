class Platform {
  //vars
  int x;
  int y;
  int w;
  int h;
  color c;
  int topBound;
  int bottomBound;
  int leftBound;
  int rightBound;

  //*******************************************************************************

  //constructor
  Platform(int platX, int platY) {
    x = platX;
    y = platY;
    w = 100;
    h = 5;
    c = 0;
    topBound = platY;
    bottomBound = platY + h;
    leftBound = platX;
    rightBound = platX + w;
  }

  //*******************************************************************************

  //render
  void render() {
    fill(c);
    stroke(c);
    rect(x, y, w, h);
  }

  //*******************************************************************************

  //resetting boundaries
  void resetBounds() {
    topBound = y;
    bottomBound = y + h;
    leftBound = x;
    rightBound = x + w;
  }

  //*******************************************************************************

  //did the player land on the platform?
  void landedOn(Player thePlayer) {
    if (thePlayer.isFalling == true) {
      if (thePlayer.bottomBound >= topBound) {
        if (thePlayer.rightBound >= leftBound) {
          if (thePlayer.leftBound <= rightBound) {
            if (thePlayer.topBound <= bottomBound) {
              thePlayer.isFalling = false;
              thePlayer.y = y - thePlayer.size;
            }
          }
        }
      }
    }
  }

  //*******************************************************************************

  //i might not actually need this function but it was put in my google doc so here it is. just in case

  //did an enemy collide with the platform? 
  void landedOn(Enemy theEnemy) {
    if (theEnemy.bottomBound >= topBound) {
      if (theEnemy.rightBound >= leftBound) {
        if (theEnemy.leftBound <= rightBound) {
          if (theEnemy.topBound <= bottomBound) {
            theEnemy.y = y - theEnemy.eH;
          }
        }
      }
    }
  }
}
