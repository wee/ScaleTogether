//
//  WWScaleView.h
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/11/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWSCaleViewDelegate <NSObject>

@optional
- (void)onWeightValueChanged:(NSDecimalNumber *)newWeight;

@end
@interface WWScaleView : UIView

@property (nonatomic) NSDecimalNumber *weight;
@property (nonatomic) id<WWSCaleViewDelegate> delegate;

@end
