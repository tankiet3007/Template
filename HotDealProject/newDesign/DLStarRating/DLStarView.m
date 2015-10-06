/*
 
 DLStarRating
 Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 
 
 All rights reserved. This program and the accompanying materials
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 */

#import "DLStarView.h"
#import "DLStarRatingControl.h"

@implementation DLStarView

#pragma mark -
#pragma mark Initialization

- (id)initWithDefault:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(int)index allowFractions:(BOOL)fractions {
	self = [super initWithFrame:CGRectZero];
    
	if (self) {
        [self setTag:index];
        if (fractions) {
            highlightedStar = [self croppedImage:highlightedStar];
            star = [self croppedImage:star];
        }
//        self.frame = CGRectMake((star.size.width*index), 0, 1.3*((star.size.width/3)-0.2), 1.3*(star.size.height/3+kEdgeInsetBottom-1.5));
        if ([UIScreen mainScreen].scale > 2.9) {
            self.frame = CGRectMake((star.size.width*index), 0, 0.44*(star.size.width)-0.5, 0.44*(star.size.height+kEdgeInsetBottom));
        }
        else
        {
        self.frame = CGRectMake((star.size.width*index), 0, 0.4*(star.size.width)-0.5, 0.4*(star.size.height+kEdgeInsetBottom));
        }
//        self.frame = CGRectMake((star.size.width*index), 0, (star.size.width), (star.size.height+kEdgeInsetBottom));
        [self setStarImage:star highlightedStarImage:highlightedStar];
		[self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, kEdgeInsetBottom, 0)];
		[self setBackgroundColor:[UIColor clearColor]];
        if (index == 0) {
   	        [self setAccessibilityLabel:@"1 star"];
        } else {
   	        [self setAccessibilityLabel:[NSString stringWithFormat:@"%d stars", index+1]];   
        }
	}
	return self;
}

- (id)initWithCustom:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(int)index allowFractions:(BOOL)fractions {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self setTag:index];
        if (fractions) {
            highlightedStar = [self croppedImage:highlightedStar];
            star = [self croppedImage:star];
        }
        self.frame = CGRectMake((star.size.width*index), 0, 1.4*((star.size.width/3)+4), 1.4*(star.size.height/3+kEdgeInsetBottom-1.5));
        //        self.frame = CGRectMake((star.size.width*index), 0, star.size.width, star.size.height+kEdgeInsetBottom);
        [self setStarImage:star highlightedStarImage:highlightedStar];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, kEdgeInsetBottom, 0)];
        [self setBackgroundColor:[UIColor clearColor]];
        if (index == 0) {
   	        [self setAccessibilityLabel:@"1 star"];
        } else {
   	        [self setAccessibilityLabel:[NSString stringWithFormat:@"%d stars", index+1]];
        }
    }
    return self;}

- (id)initWithCustom2:(UIImage*)star highlighted:(UIImage*)highlightedStar position:(int)index allowFractions:(BOOL)fractions {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self setTag:index];
        if (fractions) {
            highlightedStar = [self croppedImage:highlightedStar];
            star = [self croppedImage:star];
        }
//        self.frame = CGRectMake((star.size.width*index), 0, star.size.width/2+ 2, star.size.height);
         self.frame = CGRectMake((star.size.width*index), 0, 2*((star.size.width/3)-0.2), 2*(star.size.height/3+kEdgeInsetBottom-1.5));
        [self setStarImage:star highlightedStarImage:highlightedStar];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, kEdgeInsetBottom, 0)];
        [self setBackgroundColor:[UIColor clearColor]];
        if (index == 0) {
   	        [self setAccessibilityLabel:@"1 star"];
        } else {
   	        [self setAccessibilityLabel:[NSString stringWithFormat:@"%d stars", index+1]];
        }
    }
    return self;
}



- (UIImage *)croppedImage:(UIImage*)image {
    float partWidth = image.size.width/kNumberOfFractions * image.scale;
    int part = (self.tag+kNumberOfFractions)%kNumberOfFractions;
    float xOffset = partWidth*part;
    CGRect newFrame = CGRectMake(xOffset, 0, partWidth , image.size.height * image.scale);
    CGImageRef resultImage = CGImageCreateWithImageInRect([image CGImage], newFrame);
    UIImage *result = [UIImage imageWithCGImage:resultImage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(resultImage);
    return result;
}



#pragma mark -
#pragma mark UIView methods

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	return self.superview;
}

#pragma mark -
#pragma mark Layouting
- (void)centerIn2:(CGRect)_frame with:(int)numberOfStars {
    CGSize size = self.frame.size;
    
    float height = self.frame.size.height;
    float frameHeight = _frame.size.height;
    float newY = (frameHeight-height)/2;
    
    float widthOfStars = self.frame.size.width * numberOfStars;
    float frameWidth = _frame.size.width;
    float gapToApply = (frameWidth-widthOfStars)/2;
    
    self.frame = CGRectMake((size.width*self.tag) + gapToApply, newY, size.width, size.height);
}
- (void)centerIn:(CGRect)_frame with:(int)numberOfStars {
	CGSize size = self.frame.size;
	float height = self.frame.size.height;
	float frameHeight = _frame.size.height;
	float newY = (frameHeight-height)/2;
	
	float widthOfStars = self.frame.size.width * numberOfStars;
	float frameWidth = _frame.size.width;
	float gapToApply = (frameWidth-widthOfStars)/2;
    
    int tag = self.tag;
   	CGRect rect = CGRectMake((size.width*self.tag) + gapToApply + tag*5, newY, size.width, size.height);
    self.frame = rect;
//    CGSize size = self.frame.size;
//    
//    float height = self.frame.size.height;
//    float frameHeight = _frame.size.height;
//    float newY = (frameHeight-height)/2;
//    
//    float widthOfStars = self.frame.size.width * numberOfStars;
//    float frameWidth = _frame.size.width;
//    float gapToApply = (frameWidth-widthOfStars)/2;
//    
//    self.frame = CGRectMake((size.width*self.tag) + gapToApply, newY, size.width, size.height);
}

- (void)setStarImage:(UIImage*)starImage highlightedStarImage:(UIImage*)highlightedImage {
    [self setImage:starImage forState:UIControlStateNormal];
    [self setImage:highlightedImage forState:UIControlStateSelected];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

@end
