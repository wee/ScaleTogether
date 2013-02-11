//
//  WWScaleView.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/11/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WWScaleView.h"

#define WHEEL_RADIUS 400.0
#define MAJOR_TICK_LENGTH 30.0
#define MINOR_TICK_LENGTH 10.0

@implementation WWScaleView

static CGFloat rotationDegree  = 0.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(-(WHEEL_RADIUS*2.0 - size.width)/2.0, 0, WHEEL_RADIUS*2, WHEEL_RADIUS*2);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillPath(context);
    
    NSUInteger numberOfSections = 48;
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        [self drawTickAndLabel:section sections:numberOfSections startingRadius:rotationDegree context:context];
    }
    // Test scale wheel rotation
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(rotate) userInfo:nil repeats:NO];
}

- (void)rotate
{
    rotationDegree += 0.01;
    [self setNeedsDisplay];
    
}

- (void)drawTickAndLabel:(NSUInteger)section sections:(NSUInteger)numberOfSections startingRadius:(CGFloat)startingRadius context:(CGContextRef)context
{
    CGSize size = self.bounds.size;
    CGFloat midX = size.width/2.0;
    CGFloat angleSize = 2 * M_PI / numberOfSections;

    CGContextSetLineWidth(context, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0, 0.0, 0.0, 1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    CGFloat tickLength = (section % 2) == 0 ? MAJOR_TICK_LENGTH : MINOR_TICK_LENGTH;
    CGFloat angle = angleSize * section + startingRadius;
    CGFloat x = midX + sin(angle) * WHEEL_RADIUS;
    CGFloat y = WHEEL_RADIUS - cos(angle) * WHEEL_RADIUS;
    CGFloat x2 = midX + sin(angle) * (WHEEL_RADIUS - tickLength);;
    CGFloat y2 = WHEEL_RADIUS - cos(angle) * (WHEEL_RADIUS - tickLength);
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x2, y2);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
    UILabel *im = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    im.backgroundColor = [UIColor clearColor];
    
    CGFloat value;
    if (section < numberOfSections/2) {
        value = [self.weight floatValue] + (CGFloat)section / 2;
    } else {
        value = [self.weight floatValue] - ((CGFloat)numberOfSections - section) / 2;
    }
    
    im.text = [NSString stringWithFormat:@"%.1f", value];
    im.textAlignment = NSTextAlignmentCenter;
    im.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    im.layer.position = CGPointMake(midX, WHEEL_RADIUS);
    im.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -WHEEL_RADIUS + MAJOR_TICK_LENGTH + 10.0), CGAffineTransformMakeRotation(angle));
    [self addSubview:im];

}
@end
