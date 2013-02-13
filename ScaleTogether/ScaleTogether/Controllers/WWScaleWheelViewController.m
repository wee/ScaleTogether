//
//  WWScaleWheelViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import "WWScaleWheelViewController.h"
#import "WWScaleView.h"

@interface WWScaleWheelViewController()<WWSCaleViewDelegate>

@property (nonatomic) NSDecimalNumber *weight;

@end

@implementation WWScaleWheelViewController

- (void)awakeFromNib
{
    self.weight = [NSDecimalNumber decimalNumberWithString:@"100.0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [super viewWillAppear:animated];
    [self drawWheel];
    [self drawRecordButton];
}

- (void)drawWheel
{
    
    WWScaleView *scaleView = [[WWScaleView alloc] initWithFrame:self.view.bounds];
    scaleView.weight = self.weight;
    scaleView.delegate = self;
    [self.view addSubview:scaleView];
    
}

- (void)drawRecordButton
{
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat recordButtonWidh = 80.0;
    recordButton.frame = CGRectMake(self.view.bounds.size.width/2.0-(recordButtonWidh/2), self.view.bounds.size.height/2, recordButtonWidh, 40);
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.view addSubview:recordButton];

}

- (void)onWeightValueChanged:(NSDecimalNumber *)newWeight
{
    NSLog(@"weight selected %@", newWeight);
}

@end
