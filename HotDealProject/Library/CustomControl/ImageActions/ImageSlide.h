//
//  ImageSlide.h
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol slideImageDelegate;
@interface ImageSlide : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) NSMutableArray *galleryImages; //Array holding the image file paths
@property (nonatomic, retain) UIScrollView *scrollView; //UIScrollview to hold the images
@property (retain, nonatomic) UIPageControl *pageControl;
@property (assign) id<slideImageDelegate> delegate;

-(void)initScroll;
-(void)initScroll2;
-(void)initScrollLocal2;
-(void)initScrollLocalForSetting:(int)indexSelected;
@end
@protocol slideImageDelegate <NSObject>
@optional
-(void)playVideoWithLink:(NSString *)urlLink;
-(void)loadWebview :(NSString *)urlLink;
-(void)topCellClick:(long)index;

@end