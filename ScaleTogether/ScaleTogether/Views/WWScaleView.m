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

#define NUMBER_OF_TICKS 48

@interface WWScaleView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat rotationDegree;
@property (nonatomic, assign) CGPoint beginPanPoint;

@end

@implementation WWScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rotationDegree = 0.0;
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

#pragma mark - Pan Gesture Recognizer
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

- (void)onPanGesture:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.beginPanPoint = [recognizer translationInView:self];
            NSLog(@"start at %@", NSStringFromCGPoint(self.beginPanPoint));
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint newPoint = [recognizer translationInView:self];
            if (fabs(newPoint.x - self.beginPanPoint.x) > 5.0) {
                self.rotationDegree += (newPoint.x - self.beginPanPoint.x) / 100;
                self.beginPanPoint = newPoint;
                [self setNeedsDisplay];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint newPoint = [recognizer translationInView:self];
            NSLog(@"end at %@", NSStringFromCGPoint(newPoint));
            break;
        }
        default:
            break;
    }
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(-(WHEEL_RADIUS*2.0 - size.width)/2.0, 0, WHEEL_RADIUS*2, WHEEL_RADIUS*2);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillPath(context);
    
    for (NSUInteger section = 0; section < NUMBER_OF_TICKS; section++) {
        [self drawTickAndLabel:section sections:NUMBER_OF_TICKS startingRadius:self.rotationDegree context:context];
    }
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat recordButtonWidh = 80.0;
    recordButton.frame = CGRectMake(size.width/2.0-(recordButtonWidh/2), size.height/2, recordButtonWidh, 40);
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self addSubview:recordButton];
    // Test scale wheel rotation
    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(rotate) userInfo:nil repeats:NO];
}

- (void)rotate
{
    self.rotationDegree += 0.01;
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
    CGContextMoveToPoint(context,
                         midX + sin(angle) * WHEEL_RADIUS,
                         WHEEL_RADIUS - cos(angle) * WHEEL_RADIUS);
    CGContextAddLineToPoint(context,
                            midX + sin(angle) * (WHEEL_RADIUS - tickLength),
                            WHEEL_RADIUS - cos(angle) * (WHEEL_RADIUS - tickLength));
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
    CGFloat value;
    if (section < numberOfSections/2) {
        value = [self.weight floatValue] + (CGFloat)section / 2;
    } else {
        value = [self.weight floatValue] - ((CGFloat)numberOfSections - section) / 2;
    }
    [self addSubview:[self assignTickLabel:value angle:(CGFloat)angle]];
}

- (UILabel *)assignTickLabel:(CGFloat)value angle:(CGFloat)angle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    label.backgroundColor = [UIColor clearColor];
    
    
    label.text = [NSString stringWithFormat:@"%.1f", value];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    label.layer.position = CGPointMake(self.bounds.size.width/2.0, WHEEL_RADIUS);
    label.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, -WHEEL_RADIUS + MAJOR_TICK_LENGTH + 10.0), CGAffineTransformMakeRotation(angle));
    return label;
}
@end
