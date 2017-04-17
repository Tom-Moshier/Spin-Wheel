//
//  GameScene.m
//  p06-moshier
//
//  Created by Tom Moshier on 4/16/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () <SKPhysicsContactDelegate> {
    SKShapeNode *ball;
}

@end;


@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    //Most of the physics / ball creation code is from my last project
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    self.physicsBody.friction = 0.0f;
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    
    //Add a ball with physics
    //Drawing the ball was found from here: http://stackoverflow.com/questions/24078687/draw-smooth-circle-in-ios-sprite-kit
    CGRect circle = CGRectMake(10.0, 10.0, 20.0, 20.0);
    ball = [[SKShapeNode alloc] init];
    ball.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    ball.fillColor = [SKColor redColor];
    ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    ball.lineWidth = 0;
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 0.0f;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.linearDamping = 0.0f;
    ball.physicsBody.dynamic = YES; //enables forces to interact
    ball.physicsBody.allowsRotation = NO;
    ball.name = @"Ball";

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
