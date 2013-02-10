//
//  WWScaleWheelViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WWScaleWheelViewController.h"

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
    NSUInteger numberOfSections = 48;
    
    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    CGFloat angleSize = 2*M_PI/numberOfSections;
    for (int i = 0; i < numberOfSections; i++) {
        UILabel *im = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        im.backgroundColor = [UIColor redColor];
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:i] decimalValue]];
        im.text = [NSString stringWithFormat:@"%@", [self.weight decimalNumberByAdding:number]];
        im.textAlignment = NSTextAlignmentCenter;
        im.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0,
                                        container.bounds.size.height);
        im.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -300), CGAffineTransformMakeRotation(angleSize * i));
        im.tag = i;
        [container addSubview:im];
    }
    container.userInteractionEnabled = NO;
    
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
