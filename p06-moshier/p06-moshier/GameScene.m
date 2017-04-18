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
    
    SKShapeNode *myRectangle1;
    SKShapeNode *myRectangle2;
    SKShapeNode *myRectangle3;
    SKShapeNode *myRectangle4;
    
    SKShapeNode *myTriangle;
    
    SKLabelNode* scoreLabel;
    SKLabelNode* numberLabel;
    SKLabelNode* speedLabel;
    SKLabelNode* speedLabelNum;
    
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
    ball.physicsBody.collisionBitMask = 4;
    
    
    [self colorBall];
    [self addChild:ball];
    
    speed = 20;
    speedNum = 1;
    
    [self addCircle];
    [self rotateCircle:speed];
    [self addRectangle];
    [self rotateRectangle:speed];
    [self addTriangle];
    
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
    if (speed > 12) {
        speed -=0.2;
        [myRectangle1 removeFromParent];
        [myRectangle2 removeFromParent];
        [myRectangle3 removeFromParent];
        [myRectangle4 removeFromParent];
        [myCircle1 removeFromParent];
        [myCircle2 removeFromParent];
        [myCircle3 removeFromParent];
        [myCircle4 removeFromParent];
        [self addCircle];
        [self rotateCircle:speed];
        [self addRectangle];
        [self rotateRectangle:speed];
        
        [self rotateCircle:speed];
        [self rotateRectangle:speed];
        speedNum += 1;
        speedLabelNum.text = [NSString stringWithFormat:@"%d", speedNum];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}


- (void)addCircle {
    // a lot of code has been translated from swift to objective c
    // following this tutorial: https://www.raywenderlich.com/149034/how-to-make-a-game-like-color-switch-with-spritekit-and-swift
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,-200)];
    [path addLineToPoint:CGPointMake(0, -160)];
    [path addArcWithCenter:CGPointZero radius:160 startAngle:3.0 * M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(200, 0)];
    [path addArcWithCenter:CGPointZero radius:200 startAngle:0 endAngle:3.0* M_PI_2 clockwise:NO];
    
    myCircle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle1.strokeColor = [SKColor greenColor];
    myCircle1.fillColor = [SKColor greenColor];
    myCircle1.position = CGPointMake(0, -self.frame.size.height/2 +250);
    
    myCircle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle1.physicsBody.categoryBitMask = greenCategory;
    myCircle1.physicsBody.collisionBitMask = 0;
    myCircle1.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myCircle1.physicsBody.affectedByGravity = false;
    [self addChild:myCircle1];
    
    myCircle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle2.strokeColor = [SKColor redColor];
    myCircle2.fillColor = [SKColor redColor];
    myCircle2.zRotation = M_PI_2;
    myCircle2.position = CGPointMake(0, -self.frame.size.height/2 +250);
    
    myCircle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle2.physicsBody.categoryBitMask = redCategory;
    myCircle2.physicsBody.collisionBitMask = 0;
    myCircle2.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myCircle2.physicsBody.affectedByGravity = false;
    [self addChild:myCircle2];
    
    myCircle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle3.strokeColor = [SKColor blueColor];
    myCircle3.fillColor = [SKColor blueColor];
    myCircle3.zRotation = M_PI;
    myCircle3.position = CGPointMake(0, -self.frame.size.height/2 +250);
    
    myCircle3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle3.physicsBody.categoryBitMask = blueCategory;
    myCircle3.physicsBody.collisionBitMask = 0;
    myCircle3.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myCircle3.physicsBody.affectedByGravity = false;
    [self addChild:myCircle3];
    
    myCircle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle4.strokeColor = [SKColor yellowColor];
    myCircle4.fillColor = [SKColor yellowColor];
    myCircle4.zRotation = 3*M_PI_2;
    myCircle4.position = CGPointMake(0, -self.frame.size.height/2 +250);
    
    myCircle4.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myCircle4.physicsBody.categoryBitMask = yellowCategory;
    myCircle4.physicsBody.collisionBitMask = 0;
    myCircle4.physicsBody.contactTestBitMask = blueCategory | greenCategory | redCategory;
    myCircle4.physicsBody.affectedByGravity = false;
    [self addChild:myCircle4];
}


- (void)rotateCircle:(int)number {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [myCircle1 runAction:repeat];
    [myCircle2 runAction:repeat];
    [myCircle3 runAction:repeat];
    [myCircle4 runAction:repeat];
}

- (void)addRectangle {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,-200)];
    [path addLineToPoint:CGPointMake(0, -160)];
    [path addArcWithCenter:CGPointZero radius:160 startAngle:3.0 * M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(200, 0)];
    [path addArcWithCenter:CGPointZero radius:200 startAngle:0 endAngle:3.0* M_PI_2 clockwise:NO];
    
    myRectangle1 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle1.strokeColor = [SKColor redColor];
    myRectangle1.fillColor = [SKColor redColor];
    myRectangle1.position = CGPointMake(0, self.frame.size.height/2 -250);
    
    myRectangle1.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle1.physicsBody.categoryBitMask = redCategory;
    myRectangle1.physicsBody.collisionBitMask = 0;
    myRectangle1.physicsBody.contactTestBitMask = blueCategory | yellowCategory | greenCategory;
    myRectangle1.physicsBody.affectedByGravity = false;
    [self addChild:myRectangle1];
    
    myRectangle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle2.strokeColor = [SKColor greenColor];
    myRectangle2.fillColor = [SKColor greenColor];
    myRectangle2.zRotation = M_PI_2;
    myRectangle2.position = CGPointMake(0, self.frame.size.height/2 -250);
    
    myRectangle2.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle2.physicsBody.categoryBitMask = greenCategory;
    myRectangle2.physicsBody.collisionBitMask = 0;
    myRectangle2.physicsBody.contactTestBitMask = blueCategory | yellowCategory | redCategory;
    myRectangle2.physicsBody.affectedByGravity = false;
    [self addChild:myRectangle2];
    
    myRectangle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle3.strokeColor = [SKColor yellowColor];
    myRectangle3.fillColor = [SKColor yellowColor];
    myRectangle3.zRotation = M_PI;
    myRectangle3.position = CGPointMake(0, self.frame.size.height/2 -250);
    
    myRectangle3.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle3.physicsBody.categoryBitMask = yellowCategory;
    myRectangle3.physicsBody.collisionBitMask = 0;
    myRectangle3.physicsBody.contactTestBitMask = blueCategory | greenCategory | redCategory;
    myRectangle3.physicsBody.affectedByGravity = false;
    [self addChild:myRectangle3];
    
    myRectangle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myRectangle4.strokeColor = [SKColor blueColor];
    myRectangle4.fillColor = [SKColor blueColor];
    myRectangle4.zRotation = 3*M_PI_2;
    myRectangle4.position = CGPointMake(0, self.frame.size.height/2 -250);
    
    myRectangle4.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:(path.CGPath)];
    myRectangle4.physicsBody.categoryBitMask = blueCategory;
    myRectangle4.physicsBody.collisionBitMask = 0;
    myRectangle4.physicsBody.contactTestBitMask = greenCategory | yellowCategory | redCategory;
    myRectangle4.physicsBody.affectedByGravity = false;
    [self addChild:myRectangle4];



}

- (void)rotateRectangle:(int)number {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:number];
    SKAction *repeat = [SKAction repeatActionForever:rotation];
    [myRectangle1 runAction:repeat];
    [myRectangle2 runAction:repeat];
    [myRectangle3 runAction:repeat];
    [myRectangle4 runAction:repeat];
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
    if(ball.position.y >= myTriangle.position.y-40 && myTriangle.position.y == self.frame.size.height/2 -250) {
        [self changeTriangle];
    }
    else if (ball.position.y <= myTriangle.position.y+40 && myTriangle.position.y == -self.frame.size.height/2 +230) {
        [self changeTriangle];
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
    if (firstBody.categoryBitMask != secondBody.categoryBitMask) {
        NSLog(@"Maybe here it stopped?");
        NSLog(@"1");
    }
}


@end
