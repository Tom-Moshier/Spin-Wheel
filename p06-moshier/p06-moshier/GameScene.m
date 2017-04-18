//
//  GameScene.m
//  p06-moshier
//
//  Created by Tom Moshier on 4/16/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"
#import <math.h>



@interface GameScene () <SKPhysicsContactDelegate> {
    SKShapeNode *ball;
    
    SKShapeNode *myCircle1;
    SKShapeNode *myCircle2;
    SKShapeNode *myCircle3;
    SKShapeNode *myCircle4;
    
    SKShapeNode *myCircle5;
    SKShapeNode *myCircle6;
    SKShapeNode *myCircle7;
    SKShapeNode *myCircle8;
    
    SKShapeNode *myTriangle;
    
    SKLabelNode* scoreLabel;
    SKLabelNode* numberLabel;
    SKLabelNode* speedLabel;
    SKLabelNode* speedLabelNum;
    
    SKNode* holder1;
    SKNode* holder2;
    
    int speedNum;
    int scoreNumber;
    
    double speed;
}

@end;

//A lot of this is based off of this: https://www.raywenderlich.com/149034/how-to-make-a-game-like-color-switch-with-spritekit-and-swift

static const uint32_t greenCategory = 0x1 << 2;
static const uint32_t blueCategory  = 0x1 << 3;
static const uint32_t redCategory = 0x1 << 4;
static const uint32_t yellowCategory = 0x1 << 5;


@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    [self setUp];
}

- (void)setUp {
    self.backgroundColor = [SKColor blackColor];
    
    //Most of the physics / ball creation code is from my last project
    
    //creating gravity
    self.physicsWorld.gravity = CGVectorMake(0.0f, -10.0f);
    self.physicsWorld.contactDelegate = self;
    
    //Drawing the ball was found from here: http://stackoverflow.com/questions/24078687/draw-smooth-circle-in-ios-sprite-kit
    CGRect circle = CGRectMake(20.0, 20.0, 40.0, 40.0);
    ball = [[SKShapeNode alloc] init];
    ball.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    ball.position = CGPointMake(CGRectGetMidX(self.frame)-34, CGRectGetMidY(self.frame));
    ball.lineWidth = 0;
    
    //physics for the ball
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.dynamic = NO;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.collisionBitMask = 0;
    
    [self colorBall];
    
    speed = 20;
    speedNum = 1;
    
    holder1 = [SKNode node];
    holder1.position = CGPointMake(0, -self.frame.size.height/2 +250);
    holder2 = [SKNode node];
    holder2.position = CGPointMake(0, self.frame.size.height/2 -250);

    [self addCircle];
    [self rotateCircle:speed];
    [self addCircle2];
    [self rotateCircle2:speed];
    [self addTriangle];
    [self addChild:holder1];
    [self addChild:holder2];
    [self createLabels];
    [self addChild:ball];
}

-(void) createLabels {
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 70;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(-self.frame.size.width/2 + 20, 0);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.text = @"Score:";
    [self addChild:scoreLabel];
    
    scoreNumber = 0;
    numberLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    numberLabel.fontSize = 70;
    numberLabel.fontColor = [SKColor whiteColor];
    numberLabel.position = CGPointMake(self.frame.size.width/2 - 20, 0);
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
        ball.fillColor = [SKColor blueColor];
        ball.physicsBody.categoryBitMask = blueCategory;
    }
    else if(num == 2) {
        ball.fillColor = [SKColor yellowColor];
        ball.physicsBody.categoryBitMask = yellowCategory;
    }
    else if(num == 3) {
        ball.fillColor = [SKColor redColor];
        ball.physicsBody.categoryBitMask = redCategory;
    }
    else {
        ball.fillColor = [SKColor greenColor];
        ball.physicsBody.categoryBitMask = greenCategory;
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
        speed -=1;
        [holder1 removeActionForKey:@"rotation"];
        [holder2 removeActionForKey:@"rotation"];
        [self rotateCircle:speed];
        [self rotateCircle2:speed];
        speedNum += 1;
        NSLog(@"Speed: %f",speed);
        speedLabelNum.text = [NSString stringWithFormat:@"%d", speedNum];
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
    myCircle1.zRotation = 0;
    
    myCircle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle1.physicsBody.categoryBitMask = greenCategory;
    myCircle1.physicsBody.collisionBitMask = 0;
    myCircle1.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myCircle1.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle1];
    
    myCircle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle2.strokeColor = [SKColor redColor];
    myCircle2.fillColor = [SKColor redColor];
    myCircle2.zRotation = M_PI_2;
    
    myCircle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle2.physicsBody.categoryBitMask = redCategory;
    myCircle2.physicsBody.collisionBitMask = 0;
    myCircle2.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myCircle2.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle2];
    
    myCircle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle3.strokeColor = [SKColor blueColor];
    myCircle3.fillColor = [SKColor blueColor];
    myCircle3.zRotation = M_PI;
    
    myCircle3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle3.physicsBody.categoryBitMask = blueCategory;
    myCircle3.physicsBody.collisionBitMask = 0;
    myCircle3.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myCircle3.physicsBody.affectedByGravity = false;
    [holder1 addChild:myCircle3];
    
    myCircle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle4.strokeColor = [SKColor yellowColor];
    myCircle4.fillColor = [SKColor yellowColor];
    myCircle4.zRotation = 3*M_PI_2;
    
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

- (void)addCircle2 {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,-200)];
    [path addLineToPoint:CGPointMake(0, -160)];
    [path addArcWithCenter:CGPointZero radius:160 startAngle:3.0 * M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(200, 0)];
    [path addArcWithCenter:CGPointZero radius:200 startAngle:0 endAngle:3.0* M_PI_2 clockwise:NO];
    
    myCircle5 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle5.strokeColor = [SKColor greenColor];
    myCircle5.fillColor = [SKColor greenColor];
    myCircle5.zRotation = 0;
    
    myCircle5.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle5.physicsBody.categoryBitMask = greenCategory;
    myCircle5.physicsBody.collisionBitMask = 0;
    myCircle5.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myCircle5.physicsBody.affectedByGravity = false;
    [holder2 addChild:myCircle5];
    
    myCircle6 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle6.strokeColor = [SKColor redColor];
    myCircle6.fillColor = [SKColor redColor];
    myCircle6.zRotation = M_PI_2;
    
    myCircle6.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle6.physicsBody.categoryBitMask = redCategory;
    myCircle6.physicsBody.collisionBitMask = 0;
    myCircle6.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myCircle6.physicsBody.affectedByGravity = false;
    [holder2 addChild:myCircle6];
    
    myCircle7 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle7.strokeColor = [SKColor blueColor];
    myCircle7.fillColor = [SKColor blueColor];
    myCircle7.zRotation = M_PI;
    
    myCircle7.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle7.physicsBody.categoryBitMask = blueCategory;
    myCircle7.physicsBody.collisionBitMask = 0;
    myCircle7.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myCircle7.physicsBody.affectedByGravity = false;
    [holder2 addChild:myCircle7];
    
    myCircle8 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle8.strokeColor = [SKColor yellowColor];
    myCircle8.fillColor = [SKColor yellowColor];
    myCircle8.zRotation = 3*M_PI_2;
    
    myCircle8.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle8.physicsBody.categoryBitMask = yellowCategory;
    myCircle8.physicsBody.collisionBitMask = 0;
    myCircle8.physicsBody.contactTestBitMask = blueCategory | greenCategory | redCategory;
    myCircle8.physicsBody.affectedByGravity = false;
    [holder2 addChild:myCircle8];
}

- (void)rotateCircle2:(int)number {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [holder2 runAction:repeat withKey:@"rotation"];
}

-(void) gameOver {
    [ball removeFromParent];
    [myCircle1 removeFromParent];
    [myCircle2 removeFromParent];
    [myCircle3 removeFromParent];
    [myCircle4 removeFromParent];
    
    [myCircle5 removeFromParent];
    [myCircle6 removeFromParent];
    [myCircle7 removeFromParent];
    [myCircle8 removeFromParent];
    
    [myTriangle removeFromParent];
    
    [scoreLabel removeFromParent];
    [numberLabel removeFromParent];
    [speedLabel removeFromParent];
    [speedLabelNum removeFromParent];
    
    [self setUp];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Impluse code was found here: https://digitalbreed.com/2014/02/10/how-to-build-a-game-like-flappy-bird-with-xcode-and-sprite-kit/
    if(ball.physicsBody.dynamic == NO) {
        ball.physicsBody.dynamic = YES;
        ball.physicsBody.velocity = CGVectorMake(0, 0);
        [ball.physicsBody applyImpulse:CGVectorMake(0, 25)];
    }
    else {
        ball.physicsBody.velocity = CGVectorMake(0, 0);
        [ball.physicsBody applyImpulse:CGVectorMake(0, 25)];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    //Checks to see if the balls gotten the triangle
    if(ball.position.y >= myTriangle.position.y-40 && myTriangle.position.y == self.frame.size.height/2 -250) {
        [self changeTriangle];
    }
    else if (ball.position.y <= myTriangle.position.y+40 && myTriangle.position.y == -self.frame.size.height/2 +230) {
        [self changeTriangle];
    }
    //Checks to see if the balls gone out of bounds
    if(ball.position.y < -self.frame.size.height/2 || ball.position.y > self.frame.size.height/2) {
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
    if (firstBody.categoryBitMask != secondBody.categoryBitMask && ball.physicsBody.dynamic == YES) {
        [self gameOver];
    }
}


@end
