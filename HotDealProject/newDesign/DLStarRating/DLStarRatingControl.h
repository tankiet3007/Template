/*

    DLStarRating
    Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 

    All rights reserved. This program and the accompanying materials
    are made available under the terms of the Eclipse Public License v1.0
    which accompanies this distribution, and is available at
    http://www.eclipse.org/legal/epl-v10.html

 */

#import <UIKit/UIKit.h>

#define kDefaultNumberOfStars 5
#define kNumberOfFractions 10

@protocol DLStarRatingDelegate;

@interface DLStarRatingControl : UIControl {
	int numberOfStars;
	int currentIdx;
	UIImage *star;
	UIImage *highlightedStar;
	
    id  <DLStarRatingDelegate>__unsafe_unretained delegate;
    BOOL isFractionalRatingEnabled;
    BOOL isLarge;
}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrameCustom2:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(int)index;
- (id)initWithFrameCustom:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
@property (retain,nonatomic) UIImage *star;
@property (retain,nonatomic) UIImage *highlightedStar;
@property (nonatomic) float rating;
@property (assign,nonatomic) id<DLStarRatingDelegate> delegate;
@property (nonatomic,assign) BOOL isFractionalRatingEnabled;
@property (nonatomic,assign) BOOL isLarge;

@end

@protocol DLStarRatingDelegate

-(void)newRating:(DLStarRatingControl *)control :(float)rating;

@end
