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
    
}

@end
