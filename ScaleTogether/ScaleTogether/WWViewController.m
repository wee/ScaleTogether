//
//  WWViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import "WWViewController.h"
#import "WWChartViewController.h"

@interface WWViewController ()

@property (nonatomic) IBOutlet UIView *chartView;

@end

@implementation WWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                             bundle: nil];
    
    WWChartViewController *controller = (WWChartViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"WWChartViewController"];

    controller.view = self.chartView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
