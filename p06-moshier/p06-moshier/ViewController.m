//
//  ViewController.m
//  p06-moshier
//
//  Created by Tom Moshier on 4/4/17.
//  Copyright © 2017 Tom Moshier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//taken from example 
-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC {
    NSLog(@"Backing out of the other view controller.");
    
}


@end
