//
//  WWScaleWheelViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import "WWScaleWheelViewController.h"
#import "WWScaleView.h"

@interface WWScaleWheelViewController ()

@property (nonatomic) NSDecimalNumber *weight;
@property (nonatomic) UIView *container;

@end

@implementation WWScaleWheelViewController

- (void)awakeFromNib
{
    self.weight = [NSDecimalNumber decimalNumberWithString:@"100.0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self drawWheel];
}

- (void)drawWheel
{
    
    WWScaleView *container = [[WWScaleView alloc] initWithFrame:self.view.bounds];
    container.weight = self.weight;
    self.container = container;
    
    [self.view addSubview:container];
    
//    [NSTimer scheduledTimerWithTimeInterval:1
//                                     target:self
//                                   selector:@selector(rotate)
//                                   userInfo:nil
//                                    repeats:YES];
}

- (void) rotate {
    CGAffineTransform t = CGAffineTransformRotate(self.container.transform, -M_PI/4);
    self.container.transform = t;
}

@end
