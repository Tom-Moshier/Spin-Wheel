//
//  GameScene.m
//  p06-moshier
//
//  Created by Tom Moshier on 4/16/17.
//  Copyright Â© 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"
#import <math.h>
#import <AudioToolbox/AudioToolbox.h>

@interface GameScene () <SKPhysicsContactDelegate> {
    SKShapeNode *myCircle1;
    SKShapeNode *myCircle2;
    SKShapeNode *myCircle3;
    SKShapeNode *myCircle4;
    
    SKShapeNode *myRectangle1;
    SKShapeNode *myRectangle2;
    SKShapeNode *myRectangle3;
    SKShapeNode *myRectangle4;
    
    SKShapeNode *myTriangle;

    SKLabelNode* scoreLabel;
    SKLabelNode* numberLabel;
    SKLabelNode* speedLabel;
    SKLabelNode* speedLabelNum;
    
    SKLabelNode* SLetter;
    SKLabelNode* PLetter;
    SKLabelNode* ILetter;
    SKLabelNode* NLetter;
    SKLabelNode* Wheel;
    SKLabelNode* instruct1;
    SKLabelNode* instruct2;
    SKLabelNode* instruct3;
    SKLabelNode* instruct4;
    SKLabelNode* instruct5;
    
    SKNode* holder1;
    SKNode* holder2;
    
    SKSpriteNode *aCircle;
    SKShapeNode *circleShape;
    
    int speedNum;
    int scoreNumber;
    
    double speed;
    bool gameOver;
    
    int changeSpeedNum;
}

@end;

//A lot of this is based off of this: https://www.raywenderlich.com/149034/how-to-make-a-game-like-color-switch-with-spritekit-and-swift

static const uint32_t greenCategory = 0x1 << 2;
static const uint32_t blueCategory  = 0x1 << 3;
static const uint32_t redCategory = 0x1 << 4;
static const uint32_t yellowCategory = 0x1 << 5;


@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    [self startScene];
}

-(void) startScene {
    gameOver = true;
    [self createStartLabels];
}

-(void) createStartLabels {
    SLetter = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SLetter.fontSize = 150;
    SLetter.fontColor = [SKColor redColor];
    SLetter.position = CGPointMake(-self.frame.size.width/2 + 20, self.frame.size.height/2 -300);
    SLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    SLetter.text = @"S";
    [self addChild:SLetter];
    
    PLetter = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    PLetter.fontSize = 150;
    PLetter.fontColor = [SKColor yellowColor];
    PLetter.position = CGPointMake(-self.frame.size.width/2 + 120, self.frame.size.height/2 -150);
    PLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    PLetter.text = @"P";
    [self addChild:PLetter];
    
    ILetter = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    ILetter.fontSize = 150;
    ILetter.fontColor = [SKColor greenColor];
    ILetter.position = CGPointMake(-self.frame.size.width/2 + 220, self.frame.size.height/2 -300);
    ILetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    ILetter.text = @"I";
    [self addChild:ILetter];

    NLetter = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    NLetter.fontSize = 150;
    NLetter.fontColor = [SKColor blueColor];
    NLetter.position = CGPointMake(-self.frame.size.width/2 + 120, self.frame.size.height/2 -450);
    NLetter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    NLetter.text = @"N";
    [self addChild:NLetter];
    
    Wheel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Wheel.fontSize = 120;
    Wheel.fontColor = [SKColor whiteColor];
    Wheel.position = CGPointMake(self.frame.size.width/2 - 20, self.frame.size.height/2 -300);
    Wheel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    Wheel.text = @"Wheel";
    [self addChild:Wheel];
    
    instruct1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct1.fontSize = 70;
    instruct1.fontColor = [SKColor whiteColor];
    instruct1.position = CGPointMake(0.0,-200.0);
    instruct1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct1 setText:@"Instructions:"];
    [self addChild:instruct1];
    
    instruct2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct2.fontSize = 35;
    instruct2.fontColor = [SKColor whiteColor];
    instruct2.position = CGPointMake(0.0, -300);
    instruct2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct2 setText:@"Tap to move the ball up"];
    [self addChild:instruct2];
    
    instruct3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct3.fontSize = 35;
    instruct3.fontColor = [SKColor whiteColor];
    instruct3.position = CGPointMake(0, -400);
    instruct3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct3 setText:@"Grab the triangle to score points"];
    [self addChild:instruct3];
    
    instruct4 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct4.fontSize = 35;
    instruct4.fontColor = [SKColor whiteColor];
    instruct4.position = CGPointMake(0, -500);
    instruct4.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct4 setText:@"Only touch the same color!"];
    [self addChild:instruct4];
    
    instruct5 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct5.fontSize = 70;
    instruct5.fontColor = [SKColor whiteColor];
    instruct5.position = CGPointMake(0, 0);
    instruct5.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct5 setText:@"Tap to start"];
    [self addChild:instruct5];
    
    SKAction *flashAction = [SKAction sequence:@[
                                                 [SKAction fadeInWithDuration:1],
                                                 [SKAction waitForDuration:0],
                                                 [SKAction fadeOutWithDuration:1]
                                                 ]];
    SKAction *repeat = [SKAction repeatActionForever:flashAction];
    [instruct5 runAction:repeat];
}


- (void)setUp {
    gameOver = false;
    
    //creating gravity
    self.physicsWorld.gravity = CGVectorMake(0.0f, -10.0f);
    self.physicsWorld.contactDelegate = self;

    //The issue previously was my ball was not working correctly.
    // I found a solution here: Basically you stick the ball inside of a SKSpriteNode thats invisible and it solves the issue
    //This occurs because the skphysics body starts at a different point than the skshapenode, thus the workaround is to store it in one bigger object
    //So This is a late as a result, but the game now works as intended and thus is for the better
    
    //Source: http://www.kubilayerdogan.net/aligning-skphysicsbody-correctly-with-skshapenode/

    float radius = 20.0;
    aCircle = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(radius * 2, radius * 2)];
    SKPhysicsBody *circleBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    [circleBody setDynamic:NO];
    [circleBody setUsesPreciseCollisionDetection:YES];
    aCircle.physicsBody = circleBody;
    aCircle.physicsBody.collisionBitMask = 0;
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-[aCircle size].width / 2, -[aCircle size].height / 2, [aCircle size].width, [aCircle size].width), nil);
    circleShape = [SKShapeNode node];
    [circleShape setFillColor:[UIColor redColor]];
    [circleShape setLineWidth:0];
    [circleShape setPath:bodyPath];
    [aCircle addChild:circleShape];
    CGPathRelease(bodyPath);
    [self colorBall];
    [self addChild:aCircle];
    
    speed = 11;
    speedNum = 1;
    changeSpeedNum = 0;
    
    holder1 = [SKNode node];
    holder1.position = CGPointMake(0, -self.frame.size.height/2 +250);
    holder2 = [SKNode node];
    holder2.position = CGPointMake(0, self.frame.size.height/2 -250);
    
    [self addCircle];
    [self rotateCircle:speed];
    [self addRectangle];
    [self rotateRectangle:speed];
    [self addTriangle];
    [self addChild:holder1];
    [self addChild:holder2];
    [self createLabels];
}

-(void) createLabels {
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 70;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(-self.frame.size.width/2 + 20, 150);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.text = @"Score:";
    [self addChild:scoreLabel];
    
    scoreNumber = 0;
    numberLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    numberLabel.fontSize = 70;
    numberLabel.fontColor = [SKColor whiteColor];
    numberLabel.position = CGPointMake(self.frame.size.width/2 - 20, 150);
    numberLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    numberLabel.text = [NSString stringWithFormat:@"%d", scoreNumber];
    [self addChild:numberLabel];
    
    speedLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    speedLabel.fontSize = 70;
    speedLabel.fontColor = [SKColor whiteColor];
    speedLabel.position = CGPointMake(-self.frame.size.width/2 + 20, -150);
    speedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    speedLabel.text = @"Speed:";
    [self addChild:speedLabel];
    
    speedLabelNum = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    speedLabelNum.fontSize = 70;
    speedLabelNum.fontColor = [SKColor whiteColor];
    speedLabelNum.position = CGPointMake(self.frame.size.width/2 - 20, -150);
    speedLabelNum.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    speedLabelNum.text = [NSString stringWithFormat:@"%d", speedNum];
    [self addChild:speedLabelNum];
}

- (void)colorBall {
    int num;
    num = [self getRandomNumberBetween:1 to:4];
    NSLog(@"%d",num);
    if(num == 1) {
        circleShape.fillColor = [SKColor blueColor];
        circleShape.physicsBody.categoryBitMask = blueCategory;
        aCircle.physicsBody.categoryBitMask = blueCategory;
    }
    else if(num == 2) {
        circleShape.fillColor = [SKColor yellowColor];
        circleShape.physicsBody.categoryBitMask = yellowCategory;
        aCircle.physicsBody.categoryBitMask = yellowCategory;
    }
    else if(num == 3) {
        circleShape.fillColor = [SKColor redColor];
        circleShape.physicsBody.categoryBitMask = redCategory;
        aCircle.physicsBody.categoryBitMask = redCategory;
    }
    else {
        circleShape.fillColor = [SKColor greenColor];
        circleShape.physicsBody.categoryBitMask = greenCategory;
        aCircle.physicsBody.categoryBitMask = greenCategory;
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

//simply makes the triangle and displays it
- (void) addTriangle {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(80,0)];
    [path addLineToPoint:CGPointMake(40, 80)];
    [path closePath];
    
    myTriangle = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myTriangle.strokeColor = [SKColor whiteColor];
    myTriangle.fillColor = [SKColor whiteColor];
    myTriangle.position = CGPointMake(-34, self.frame.size.height/2 -250);
    [self addChild:myTriangle];
    
}

//changes the position from one ring to the other, then goes and changes the speed of the rings
- (void) changeTriangle {
    if(myTriangle.position.y ==  self.frame.size.height/2 -250) {
        myTriangle.position =  CGPointMake(-34,-self.frame.size.height/2 +230);
    }
    else {
        myTriangle.position =  CGPointMake(-34,self.frame.size.height/2 -250);
    }
    [self changeSpeed];
    [self colorBall];
    scoreNumber += 1*speedNum+1;
    numberLabel.text = [NSString stringWithFormat:@"%d", scoreNumber];
}

- (void) changeSpeed {
    if (speed > 1) {
        if(changeSpeedNum == 0) {
            speed -=1;
            [holder1 removeActionForKey:@"rotation"];
            [self rotateCircle:speed];
            speedNum += 1;
            NSLog(@"Speed: %f",speed);
            speedLabelNum.text = [NSString stringWithFormat:@"%d", speedNum];
            changeSpeedNum = 1;
        }
        else {
            [holder2 removeActionForKey:@"rotation"];
            [self rotateRectangle:speed];
            NSLog(@"Speed: %f",speed);
            changeSpeedNum = 0;
        }
    }
}

- (void)addCircle {
    // a lot of code has been translated from swift to objective c
    // following this tutorial: https://www.raywenderlich.com/149034/how-to-make-a-game-like-color-switch-with-spritekit-and-swift
    //a lot of it is my own however and doesn't seem to work as intended
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,-200)];
    [path addLineToPoint:CGPointMake(0, -160)];
    [path addArcWithCenter:CGPointZero radius:160 startAngle:3.0 * M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(200, 0)];
    [path addArcWithCenter:CGPointZero radius:200 startAngle:0 endAngle:3.0* M_PI_2 clockwise:NO];
    
    myCircle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle1.strokeColor = [SKColor greenColor];
    myCircle1.fillColor = [SKColor greenColor];
    myCircle1.zRotation = M_PI_2;
    
    myCircle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle1.physicsBody.categoryBitMask = greenCategory;
    myCircle1.physicsBody.collisionBitMask = 0;
    myCircle1.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myCircle1.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle1];
    
    myCircle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle2.strokeColor = [SKColor redColor];
    myCircle2.fillColor = [SKColor redColor];
    myCircle2.zRotation = 0;
    
    myCircle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle2.physicsBody.categoryBitMask = redCategory;
    myCircle2.physicsBody.collisionBitMask = 0;
    myCircle2.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myCircle2.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle2];
    
    myCircle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle3.strokeColor = [SKColor blueColor];
    myCircle3.fillColor = [SKColor blueColor];
    myCircle3.zRotation = 3*M_PI_2;
    
    myCircle3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle3.physicsBody.categoryBitMask = blueCategory;
    myCircle3.physicsBody.collisionBitMask = 0;
    myCircle3.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myCircle3.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle3];
    
    myCircle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle4.strokeColor = [SKColor yellowColor];
    myCircle4.fillColor = [SKColor yellowColor];
    myCircle4.zRotation = M_PI;
    
    myCircle4.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle4.physicsBody.categoryBitMask = yellowCategory;
    myCircle4.physicsBody.collisionBitMask = 0;
    myCircle4.physicsBody.contactTestBitMask = blueCategory | greenCategory | redCategory;
    myCircle4.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle4];
}


- (void)rotateCircle:(int)number {
    //SKAction just repeats forever
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [holder1 runAction:repeat withKey:@"rotation"];
}

- (void)addRectangle {
    CGSize size;
    size.height = 40;
    size.width = 400;
    CGPoint origin;
    origin.x = -200;
    origin.y = -200;
    CGRect rect;
    rect.origin = origin;
    rect.size = size;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    myRectangle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle1.strokeColor = [SKColor greenColor];
    myRectangle1.fillColor = [SKColor greenColor];
    myRectangle1.zRotation = 0;
    
    myRectangle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle1.physicsBody.categoryBitMask = greenCategory;
    myRectangle1.physicsBody.collisionBitMask = 0;
    myRectangle1.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myRectangle1.physicsBody.affectedByGravity = false;
    [holder2 addChild:myRectangle1];
    
    myRectangle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle2.strokeColor = [SKColor redColor];
    myRectangle2.fillColor = [SKColor redColor];
    myRectangle2.zRotation = M_PI_2;
    
    myRectangle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle2.physicsBody.categoryBitMask = redCategory;
    myRectangle2.physicsBody.collisionBitMask = 0;
    myRectangle2.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myRectangle2.physicsBody.affectedByGravity = false;
    [holder2 addChild:myRectangle2];
    
    myRectangle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle3.strokeColor = [SKColor blueColor];
    myRectangle3.fillColor = [SKColor blueColor];
    myRectangle3.zRotation = M_PI;
    
    myRectangle3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle3.physicsBody.categoryBitMask = blueCategory;
    myRectangle3.physicsBody.collisionBitMask = 0;
    myRectangle3.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myRectangle3.physicsBody.affectedByGravity = false;
    [holder2 addChild:myRectangle3];
    
    myRectangle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle4.strokeColor = [SKColor yellowColor];
    myRectangle4.fillColor = [SKColor yellowColor];
    myRectangle4.zRotation = 3*M_PI_2;
    
    myRectangle4.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle4.physicsBody.categoryBitMask = yellowCategory;
    myRectangle4.physicsBody.collisionBitMask = 0;
    myRectangle4.physicsBody.contactTestBitMask = blueCategory | greenCategory | redCategory;
    myRectangle4.physicsBody.affectedByGravity = false;
    [holder2 addChild:myRectangle4];
}

- (void)rotateRectangle:(int)number {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [holder2 runAction:repeat withKey:@"rotation"];
}

-(void) gameOver {
    [aCircle removeFromParent];
    [myCircle1 removeFromParent];
    [myCircle2 removeFromParent];
    [myCircle3 removeFromParent];
    [myCircle4 removeFromParent];
    
    [myRectangle1 removeFromParent];
    [myRectangle2 removeFromParent];
    [myRectangle3 removeFromParent];
    [myRectangle4 removeFromParent];
    
    [myTriangle removeFromParent];
    
    [scoreLabel removeFromParent];
    [numberLabel removeFromParent];
    [speedLabel removeFromParent];
    [speedLabelNum removeFromParent];
    
    SKLabelNode* gameOverLabel;
    SKLabelNode* finalScore;
    SKLabelNode* startNode;
    gameOver = true;
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameOverLabel.fontSize = 70;
    gameOverLabel.fontColor = [SKColor whiteColor];
    gameOverLabel.position = CGPointMake(0.0f, 250.0f);;
    gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [gameOverLabel setText:@"Game Over"];
    finalScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    finalScore.fontSize = 70;
    finalScore.fontColor = [SKColor whiteColor];
    finalScore.position = CGPointMake(0.0f, 0.0f);
    finalScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [finalScore setText:[NSString stringWithFormat:@"Final Score: %d", scoreNumber]];
    [self addChild:finalScore];
    [self addChild:gameOverLabel];
    startNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startNode.fontSize = 55;
    startNode.fontColor = [SKColor whiteColor];
    startNode.position = CGPointMake(0.0f, -250.0f);
    startNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [startNode setText:@"Tap to Try Again"];
    [self addChild:startNode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Impluse code was found here: https://digitalbreed.com/2014/02/10/how-to-build-a-game-like-flappy-bird-with-xcode-and-sprite-kit/
    if(gameOver) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        [self setUp];
    }
    else {
        if(aCircle.physicsBody.dynamic == NO) {
            aCircle.physicsBody.dynamic = YES;
        }
        aCircle.physicsBody.velocity = CGVectorMake(0, 0);
        [aCircle.physicsBody applyImpulse:CGVectorMake(0, 25)];
        SystemSoundID soundID;
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Regular" ofType:@"caf"];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    //Checks to see if the balls gotten the triangle
    if(aCircle.position.y >= myTriangle.position.y-40 && myTriangle.position.y == self.frame.size.height/2 -250) {
        [self changeTriangle];
    }
    else if (aCircle.position.y <= myTriangle.position.y+40 && myTriangle.position.y == -self.frame.size.height/2 +230) {
        [self changeTriangle];
    }
    //Checks to see if the balls gone out of bounds
    if(aCircle.position.y < -self.frame.size.height/2 || aCircle.position.y > self.frame.size.height/2) {
        [self gameOver];
    }
}

-(void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    //the ball must be in motion because when setting up the scene things collide
    if (firstBody.categoryBitMask != secondBody.categoryBitMask && aCircle.physicsBody.dynamic == YES) {
        [self gameOver];
    }
}


@end
