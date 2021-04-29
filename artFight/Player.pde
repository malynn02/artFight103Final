class Player {
  //vars
  int x;
  int y;
  int size;
  color c;
  int runSpeed;
  int jumpSpeed;
  int fallSpeed;
  int topBound;
  int bottomBound;
  int leftBound;
  int rightBound;
  boolean movingLeft;
  boolean movingRight;
  boolean isJumping;
  boolean isFalling;
  int jumpHeight;
  int peakY;
  int boxLeft;
  int boxRight;
  int boxTop;
  int boxBottom;
  boolean wasLastDirectionLeft;
  boolean isDead;
  boolean isAttacking;
  int health;

  //*******************************************************************************

  //constructor
  Player(int pX, int pY, color pC) {
    x = pX;
    y = pY;
    size = 25;
    c = pC;
    runSpeed = 7;
    jumpSpeed = 6;
    fallSpeed = 8;
    topBound = pY;
    bottomBound = pY + 25;
    leftBound = pX;
    rightBound = pX + 25;
    movingLeft = false;
    movingRight = false;
    isJumping = false;
    isFalling = false;
    jumpHeight = 100;
    peakY = pY - jumpHeight;
    boxLeft = rightBound;
    boxRight = rightBound + 15;
    boxTop = topBound;
    boxBottom = bottomBound;
    wasLastDirectionLeft = false;
    isDead = false;
    health = 15;
  }

  //*******************************************************************************

  //render
  void renderPlayer() {
    fill (c);
    stroke (c);
    square (x, y, size);
    fill (255, 255, 0);
    rect(boxLeft, boxTop, 15, 25);
  }

  //*******************************************************************************

  //movement
  void movePlayerR() {
    if (movingRight == true && x + size <= width) {
      x = x + runSpeed;
    }
  }

  void movePlayerL() {
    if (movingLeft == true && x >= 0) {
      x = x - runSpeed;
    }
  }

  //*******************************************************************************

  //resetting boundaries (with lots of resets for the hitbox)
  void resetBoundaries() {
    topBound = y;
    bottomBound = y + size;
    leftBound = x;
    rightBound = x + size;
    if (movingRight == true && movingLeft == false) {
      boxLeft = rightBound;
      boxRight = rightBound + 15;
      boxTop = topBound;
      boxBottom = bottomBound;
      wasLastDirectionLeft = false;
    } else if (movingLeft == true && movingRight == false) {
      boxLeft = leftBound - 15;
      boxRight = leftBound;
      boxTop = topBound;
      boxBottom = bottomBound;
      wasLastDirectionLeft = true;
    } else if (movingLeft == false && movingRight == false) {
      if (wasLastDirectionLeft == false) {
        boxLeft = rightBound;
        boxRight = rightBound + 15;
        boxTop = topBound;
        boxBottom = bottomBound;
      } else if ( wasLastDirectionLeft == true) {
        boxLeft = leftBound - 15;
        boxRight = leftBound;
        boxTop = topBound;
        boxBottom = bottomBound;
      }
    }
  }

  //*******************************************************************************

  //jump
  void jump() {
    if (isJumping == true && isFalling == false) {
      if (y >= peakY) {
        y = y - jumpSpeed;
      }
    }
  }

  //reached top of jump
  void reachedTopOfJump() {
    if (y <= peakY) {
      isJumping = false;
      isFalling = true;
    }
  }

  //fall
  void fall() {
    if (isJumping == false && isFalling == true) {
      y = y + fallSpeed;
    }
  }

  //land
  void land() {
    if (y + size >= height) {
      isFalling = false;
    }
  }

  //*******************************************************************************

  //fall off the platform
  void fallOffPlatform(ArrayList <Platform> somePlatforms) {

    // if not jumping and above the ground
    if (isJumping == false && bottomBound < height) {
      boolean onPlatform = false;
      for (Platform plat : somePlatforms) {
        if (topBound <= plat.bottomBound) {
          if (bottomBound >= plat.topBound) {
            if (rightBound >= plat.leftBound) {
              if (leftBound <= plat.rightBound) {
                onPlatform = true;
              }
            }
          }
        }
      }
      if (onPlatform == false) {
        isFalling = true;
      }
    }
  }

  //*******************************************************************************

  //attack enemies
  void attackE(Enemy en) {
    if (boxTop <= en.bottomBound) {
      if (boxBottom >= en.topBound) {
        if (boxRight >= en.leftBound) {
          if (boxLeft <= en.rightBound) {
            en.isDead = true;
          }
        }
      }
    }
  }

  //*******************************************************************************

  //attack boss
  void attackB(Boss b) {
    if (boxTop <= b.bottomBound) {
      if (boxBottom >= b.topBound) {
        if (boxRight >= b.leftBound) {
          if (boxLeft <= b.rightBound) {
            b.bHealth = b.bHealth - 1;
            bStartTime = millis();
            bInHitFrames = true;
          }
        }
      }
    }
  }

  //*******************************************************************************

  //dying when you fall off all the platforms
  void fallingDeath() {
    if (bottomBound >= height) {
      isDead = true;
    }
  }

  //*******************************************************************************

  //dying when your health reaches zero
  void otherDeath() {
    if (health <= 0) {
      isDead = true;
    }
  }

  //*******************************************************************************

  //display player health
  void displayHealth() {
    fill(255);
    textSize(25);
    text("player health:", 10, 30);
    text(health, 180, 30);
  }
}
