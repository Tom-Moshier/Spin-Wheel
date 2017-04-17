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
}

@end;



@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    
    //Most of the physics / ball creation code is from my last project
    
    //creating gravity
    self.physicsWorld.gravity = CGVectorMake(0.0f, -10.0f);
    self.physicsWorld.contactDelegate = self;
    
    //making a frame so the ball can't go past
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    
    //Drawing the ball was found from here: http://stackoverflow.com/questions/24078687/draw-smooth-circle-in-ios-sprite-kit
    CGRect circle = CGRectMake(20.0, 20.0, 40.0, 40.0);
    ball = [[SKShapeNode alloc] init];
    ball.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ball.lineWidth = 0;
    
    //physics for the ball
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.dynamic = NO;
    ball.physicsBody.allowsRotation = NO;
    ball.name = @"Ball";
    [self colorBall];
    [self addChild:ball];
    
    [self addCircle];
    [self rotateCircle];
    [self addRectangle];
    [self rotateRectangle];
    

}

- (void)colorBall {
    int num;
    num = [self getRandomNumberBetween:1 to:4];
    NSLog(@"%d",num);
    if(num == 1) {
        ball.fillColor = [SKColor blueColor];
    }
    else if(num == 2) {
        ball.fillColor = [SKColor yellowColor];
    }
    else if(num == 3) {
        ball.fillColor = [SKColor redColor];
    }
    else {
        ball.fillColor = [SKColor greenColor];
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
    [self addChild:myCircle1];
    
    myCircle2 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle2.strokeColor = [SKColor redColor];
    myCircle2.fillColor = [SKColor redColor];
    myCircle2.zRotation = M_PI_2;
    [self addChild:myCircle2];
    
    myCircle3 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle3.strokeColor = [SKColor blueColor];
    myCircle3.fillColor = [SKColor blueColor];
    myCircle3.zRotation = M_PI;
    [self addChild:myCircle3];
    
    myCircle4 = [SKShapeNode shapeNodeWithPath:path.CGPath];
    myCircle4.strokeColor = [SKColor yellowColor];
    myCircle4.fillColor = [SKColor yellowColor];
    myCircle4.zRotation = 3*M_PI_2;
    [self addChild:myCircle4];
}

- (void)rotateCircle {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:20];
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
}

- (void)rotateRectangle {
    SKAction *rotation = [SKAction rotateByAngle:2*M_PI duration:20];
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
    // Called before each frame is rendered
}

@end
