/*
 This is my final game! It features a character armed with a paintbrush,
 fighting evil art supplies to get to her final boss, a canvas.
 */

//*******************************************************************************

//importing sound stuff 
import processing.sound.*;

//making animations and their arrays
Animation bWalk;
Animation eWalk;
Animation pWalk;
Animation pWalkL;
Animation pAttack;
Animation pAttackL;
Animation pJump;
Animation pJumpL;
PImage[] bWalking = new PImage[4];
PImage[] eWalking = new PImage[2];
PImage[] pWalking = new PImage[4];
PImage[] pWalkingL = new PImage[4];
PImage[] pAttacking = new PImage[4];
PImage[] pAttackingL = new PImage[4];
PImage[] pJumping = new PImage[3];
PImage[] pJumpingL = new PImage[3];

//background var
PImage defaultBG;

//sound variables
SoundFile jumpSound;
SoundFile background;

//create player and booleans for resetting to the left
Player p1;

//arraylists for enemies
ArrayList<Enemy> enemyList1;
ArrayList<Enemy> enemyList2;
ArrayList<Enemy> enemyList3;

//arraylists for platforms
ArrayList<Platform> platList;
ArrayList<Platform> bossPlat;

//create boss
Boss b1;

//make timer (to control when the player can take damage)
int startTime;
int bStartTime;
int recovery;
boolean inHitFrames;
boolean bInHitFrames;

//switch statement for state machine
int switchVal = 0;

//*******************************************************************************

void setup() {
  size(1000, 600); 

  //background
  defaultBG = loadImage("art fight bg.png");

  //filling the arrays
  for (int i=0; i < bWalking.length; i++) {
    bWalking[i] = loadImage("bossWalk"+i+".png");
  }
  for (int i=0; i < eWalking.length; i++) {
    eWalking[i] = loadImage("enemyWalk"+i+".png");
  }
  for (int i=0; i < pWalking.length; i++) {
    pWalking[i] = loadImage("playerWalk"+i+".png");
  }
  for (int i=0; i < pWalkingL.length; i++) {
    pWalkingL[i] = loadImage("playerWalkLeft"+i+".png");
  }

  //initializing the animations
  bWalk = new Animation(bWalking, 0.05, 2.5);
  eWalk = new Animation(eWalking, 0.025, 2);
  pWalk = new Animation(pWalking, 0.2, 1.7);
  pWalkL = new Animation(pWalkingL, 0.2, 1.7);

  //sound stuff
  jumpSound = new SoundFile(this, "jump.wav");
  background = new SoundFile(this, "art fight.wav");
  background.amp(.2);
  jumpSound.amp(.5);
  jumpSound.rate(1.5);

  //timer stuff
  startTime = millis();
  recovery = 1000;
  inHitFrames = false;
  bInHitFrames = false;

  //create the player
  p1 = new Player(0, height/2-50, color (0, 255, 255));

  //create an arraylist to put platforms in (and put platforms in it)
  platList = new ArrayList<Platform>();
  platList.add(new Platform(0, height/2));
  platList.add(new Platform(150, 225));
  platList.add(new Platform(200, 475));
  platList.add(new Platform(275, 125));
  platList.add(new Platform(300, 250));
  platList.add(new Platform(400, 400));
  platList.add(new Platform(525, 300));  
  platList.add(new Platform(600, 500));
  platList.add(new Platform(750, 100));
  platList.add(new Platform(600, 200));
  platList.add(new Platform(775, 425));  
  platList.add(new Platform(950, 350));

  //create an arraylist to put platforms in for the boss level (and put platforms in it)
  bossPlat = new ArrayList<Platform>();
  bossPlat.add(new Platform(0, height/2));
  bossPlat.add(new Platform(100, height/2));
  bossPlat.add(new Platform(200, height/2));
  bossPlat.add(new Platform(300, height/2));
  bossPlat.add(new Platform(400, height/2));
  bossPlat.add(new Platform(500, height/2));
  bossPlat.add(new Platform(600, height/2));
  bossPlat.add(new Platform(700, height/2));
  bossPlat.add(new Platform(800, height/2));
  bossPlat.add(new Platform(900, height/2));

  //create an arraylist to put enemies in (and put enemies in it)
  //level 1
  enemyList1 = new ArrayList<Enemy>();
  enemyList1.add(new Enemy(platList.get(3)));
  enemyList1.add(new Enemy(platList.get(5)));
  enemyList1.add(new Enemy(platList.get(9)));

  //create an arraylist to put enemies in (and put enemies in it)
  //level 2
  enemyList2 = new ArrayList<Enemy>();
  enemyList2.add(new Enemy(platList.get(1)));
  enemyList2.add(new Enemy(platList.get(3)));
  enemyList2.add(new Enemy(platList.get(5)));
  enemyList2.add(new Enemy(platList.get(7)));
  enemyList2.add(new Enemy(platList.get(9)));

  //create an arraylist to put enemies in (and put enemies in it)
  //level 3
  enemyList3 = new ArrayList<Enemy>();
  enemyList3.add(new Enemy(platList.get(1)));
  enemyList3.add(new Enemy(platList.get(2)));
  enemyList3.add(new Enemy(platList.get(3)));
  enemyList3.add(new Enemy(platList.get(4)));
  enemyList3.add(new Enemy(platList.get(5)));
  enemyList3.add(new Enemy(platList.get(6)));
  enemyList3.add(new Enemy(platList.get(7)));
  enemyList3.add(new Enemy(platList.get(8)));
  enemyList3.add(new Enemy(platList.get(9)));
  enemyList3.add(new Enemy(platList.get(10)));

  //create the boss
  b1 = new Boss (width/2, height/2 - 40, 40);
}

//*******************************************************************************

void draw() {
  switch(switchVal) {
  case 0: //start screen
    startScreen();
    music();
    break;

  case 1: //level 1
    generalLevel();
    levelProgression();
    makePlatforms();
    level1Enemies();
    music();
    break;

  case 2: //level 2
    generalLevel();
    levelProgression();
    makePlatforms();
    level2Enemies();
    music();
    break;

  case 3: //level 3
    levelProgression();
    generalLevel();
    makePlatforms();
    level3Enemies();
    music();
    break;

  case 4: //boss level
    levelProgression();
    generalLevel();
    bossLevel();
    bossFunctions();
    music();
    break;

  case 5: //defeat screen
    defeat();
    music();
    break;

  case 6: //victory screen
    victory();
    music();
    break;
  }
}

//*******************************************************************************

void keyPressed() {
  //player movement
  if (key == 'd') {
    p1.movingRight = true;
    pWalk.isAnimating = true;
  } 
  if (key == 'a') {
    p1.movingLeft = true;
    if (p1.wasLastDirectionLeft == true)
      pWalkL.isAnimating = true;
  } 
  if (key == 'w') {
    if (p1.isJumping == false) {
      if (p1.isFalling == false) {
        p1.isJumping = true;
        p1.peakY = p1.y - p1.jumpHeight;
        jumpSound.play();
      }
    }
  }
  //player attack
  if ( key == ' ') {    
    for (Enemy ene : enemyList1) {
      p1.attackE(ene);
    }
    for (Enemy ene : enemyList2) {
      p1.attackE(ene);
    }
    for (Enemy ene : enemyList3) {
      p1.attackE(ene);
    }
    if (bInHitFrames == false) {
      p1.attackB(b1);
    }
  }
  //switch statement
  if (key=='r') {
    if (switchVal==0) {
      switchVal = 1;
      p1.x = 0;
      p1.y = height/2 - 50;
    } else if (switchVal>0) {
      switchVal = 0;
    }
  }
}


//*******************************************************************************

void keyReleased() {
  //more movement
  if (key == 'd') {
    p1.movingRight = false;
  }
  if (key == 'a') {
    p1.movingLeft = false;
  }
}

//*******************************************************************************

void startScreen() {
  background(loadImage("art fight menu.png"));
  p1.x = 0;
  p1.y = height/2 - 50;
  p1.health = 15;
  p1.isDead = false;
  if (enemyList1.size() < 3) {
    enemyList1.clear();
    enemyList1.add(new Enemy(platList.get(3)));
    enemyList1.add(new Enemy(platList.get(5)));
    enemyList1.add(new Enemy(platList.get(9)));
  }
  if (enemyList2.size() < 5) {
    enemyList2.clear();
    enemyList2.add(new Enemy(platList.get(1)));
    enemyList2.add(new Enemy(platList.get(3)));
    enemyList2.add(new Enemy(platList.get(5)));
    enemyList2.add(new Enemy(platList.get(7)));
    enemyList2.add(new Enemy(platList.get(9)));
  }
  if (enemyList3.size() < 10) {
    enemyList3.clear();
    enemyList3.add(new Enemy(platList.get(1)));
    enemyList3.add(new Enemy(platList.get(2)));
    enemyList3.add(new Enemy(platList.get(3)));
    enemyList3.add(new Enemy(platList.get(4)));
    enemyList3.add(new Enemy(platList.get(5)));
    enemyList3.add(new Enemy(platList.get(6)));
    enemyList3.add(new Enemy(platList.get(7)));
    enemyList3.add(new Enemy(platList.get(8)));
    enemyList3.add(new Enemy(platList.get(9)));
    enemyList3.add(new Enemy(platList.get(10)));
  }
}

//*******************************************************************************

void generalLevel() {
  //background(100);
  background (defaultBG);
  //timer stuff
  if (inHitFrames == true) {
    if (millis() - startTime >= recovery) {
      inHitFrames = false;
    }
  }
  //player stuff
  if (p1.wasLastDirectionLeft == true) {
    pWalkL.display(p1.x, p1.y);
  } else {  
    pWalk.display(p1.x, p1.y);
  }
  p1.resetBoundaries();
  p1.jump();
  p1.reachedTopOfJump();
  p1.fall();
  p1.land();  
  if (p1.movingRight == true) {
    p1.movePlayerR();
  }
  if (p1.movingLeft == true) {
    p1.movePlayerL();
  }
  p1.fallOffPlatform(platList);
  p1.fallingDeath();
  p1.otherDeath();
  p1.displayHealth();
  //losing
  if (p1.isDead == true) {
    switchVal = 5;
    if (enemyList1.size() < 3) {
      enemyList1.clear();
      enemyList1.add(new Enemy(platList.get(3)));
      enemyList1.add(new Enemy(platList.get(5)));
      enemyList1.add(new Enemy(platList.get(9)));
    }
    if (enemyList2.size() < 5) {
      enemyList2.clear();
      enemyList2.add(new Enemy(platList.get(1)));
      enemyList2.add(new Enemy(platList.get(3)));
      enemyList2.add(new Enemy(platList.get(5)));
      enemyList2.add(new Enemy(platList.get(7)));
      enemyList2.add(new Enemy(platList.get(9)));
    }
    if (enemyList3.size() < 10) {
      enemyList3.clear();
      enemyList3.add(new Enemy(platList.get(1)));
      enemyList3.add(new Enemy(platList.get(2)));
      enemyList3.add(new Enemy(platList.get(3)));
      enemyList3.add(new Enemy(platList.get(4)));
      enemyList3.add(new Enemy(platList.get(5)));
      enemyList3.add(new Enemy(platList.get(6)));
      enemyList3.add(new Enemy(platList.get(7)));
      enemyList3.add(new Enemy(platList.get(8)));
      enemyList3.add(new Enemy(platList.get(9)));
      enemyList3.add(new Enemy(platList.get(10)));
    }
  }
}

//*******************************************************************************

void levelProgression() {
  //level progression
  if (enemyList1.size() < 1 && switchVal == 1) {
    if (p1.rightBound >= width) {
      if (p1.y <= 350) {
        switchVal = 2;
        p1.x = 0;
        p1.y = height/2 - 50;
      }
    }
  }

  if (enemyList2.size() < 1 && switchVal == 2) {
    if (p1.rightBound >= width) {
      if (p1.y <= 350) {
        switchVal = 3;
        p1.x = 0;
        p1.y = height/2 - 50;
      }
    }
  }
  if (enemyList3.size() < 1 && switchVal == 3) {
    if (p1.rightBound >= width) {
      if (p1.y <= 350) {
        switchVal = 4;
        p1.x = 0;
        p1.y = height/2 - 50;
      }
    }
  }
}

//*******************************************************************************

void makePlatforms() {
  //platform stuff
  for (Platform plat : platList) {
    plat.render();
    plat.resetBounds();
    plat.landedOn(p1);
  }
}

//*******************************************************************************

void level1Enemies() {
  //enemy stuff
  for (Enemy ene : enemyList1) {
    if (ene.isDead == false) {
      eWalk.display(ene.x, ene.y);
      eWalk.isAnimating = true;
      ene.resetBoundaries();
      ene.moveEnemy();
      if (inHitFrames == false) {
        ene.enCollision(p1);
      }
    }
  }
  for (int i=enemyList1.size()-1; i>=0; i--) {
    if (enemyList1.get(i).isDead == true) {
      enemyList1.remove(i);
    }
  }
}

//*******************************************************************************

void level2Enemies() {
  //enemy stuff
  for (Enemy ene : enemyList2) {
    if (ene.isDead == false) {
      eWalk.display(ene.x, ene.y);
      eWalk.isAnimating = true;
      ene.resetBoundaries();
      ene.moveEnemy();
      if (inHitFrames == false) {
        ene.enCollision(p1);
      }
    }
  }
  for (int i=enemyList2.size()-1; i>=0; i--) {
    if (enemyList2.get(i).isDead == true) {
      enemyList2.remove(i);
    }
  }
}

//*******************************************************************************

void level3Enemies() {
  //enemy stuff
  for (Enemy ene : enemyList3) {
    if (ene.isDead == false) {
      eWalk.display(ene.x, ene.y);
      eWalk.isAnimating = true;
      ene.resetBoundaries();
      ene.moveEnemy();
      if (inHitFrames == false) {
        ene.enCollision(p1);
      }
    }
  }
  for (int i=enemyList3.size()-1; i>=0; i--) {
    if (enemyList3.get(i).isDead == true) {
      enemyList3.remove(i);
    }
  }
}

//*******************************************************************************

void bossFunctions() {
  //boss stuff
  if (b1.isDead == false) {
    bWalk.display(b1.x, b1.y);
    bWalk.isAnimating = true;
    // b1.renderBoss();
    b1.resetBoundaries();
    b1.followPlayer(p1);
    if (inHitFrames == false) {
      b1.bCollision(p1);
    }
    b1.bDeath();
    b1.displayHealth();
  }
  if (bInHitFrames == true) {
    if (millis() - bStartTime >= recovery) {
      bInHitFrames = false;
    }
  }
  if (b1.isDead == true) {
    switchVal = 6;
    b1.bHealth = 10;
    b1.isDead = false;
  }
}

//*******************************************************************************

void bossLevel() {
  //setting up the level for the boss
  for (Platform plat : bossPlat) {
    plat.render();
    plat.resetBounds();
    plat.landedOn(p1);
  }
}

//*******************************************************************************

void defeat() {
  background(loadImage("art fight lose.png"));
}

//*******************************************************************************

void victory() {
  background(loadImage("art fight win.png"));
}

//*******************************************************************************

void music() {
  if (!background.isPlaying()) {
    background.play();
  }
}
