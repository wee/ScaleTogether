//
//  WWViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import "WWViewController.h"
#import "WWChartViewController.h"
#import "WWScaleWheelViewController.h"

@interface WWViewController ()

@property (nonatomic) IBOutlet UIView *chartView;
@property (nonatomic) IBOutlet UIView *scaleWheelView;

@end

@implementation WWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    WWChartViewController *controller = (WWChartViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"WWChartViewController"];

    controller.view = self.chartView;
    
    WWScaleWheelViewController *wheelController = (WWScaleWheelViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"WWScaleWheelViewController"];
    wheelController.view = self.scaleWheelView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
