//
//  GameScene.m
//  p06-moshier
//
//  Created by Tom Moshier on 4/16/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKLabelNode* start;
    SKLabelNode* highscore;
    SKLabelNode* options;
    SKLabelNode* instructions;
    SKLabelNode* spinWheel;
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    
    start = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highscore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    options = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instructions = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    spinWheel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    start.fontSize = 40;
    start.fontColor = [SKColor greenColor];
    start.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    start.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [start setText:@"New Game"];
    start.name = @"Start";
    [self addChild:start];
    
    highscore.fontSize = 40;
    highscore.fontColor = [SKColor yellowColor];
    highscore.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-4*(start.frame.size.height));
    highscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [highscore setText:@"Highscores"];
    highscore.name = @"Score";
    [self addChild:highscore];
    
    options.fontSize = 40;
    options.fontColor = [SKColor redColor];
    options.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-8*(start.frame.size.height));
    options.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [options setText:@"Options"];
    options.name = @"Options";
    [self addChild:options];
    
    instructions.fontSize = 40;
    instructions.fontColor = [SKColor cyanColor];
    instructions.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-12*(start.frame.size.height));
    instructions.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instructions setText:@"Instructions"];
    instructions.name = @"Instructions";
    [self addChild:instructions];
    
    spinWheel.fontSize = 60;
    spinWheel.fontColor = [SKColor whiteColor];
    spinWheel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+self.frame.size.height/2 - 75);
    spinWheel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [spinWheel setText:@"Spin Wheel"];
    [self addChild:spinWheel];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *touchesArray = [touches allObjects];
    for(int i=0; i <[touchesArray count]; i++) {
        UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
        CGPoint point = [touch locationInView:nil];
        if(touch.name == @"Start") {
            
        }
        // do something with 'point'
    }
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
