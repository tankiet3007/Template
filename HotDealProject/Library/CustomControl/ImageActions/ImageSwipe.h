//
//  ImageSwipe.h
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSwipe : UIView<UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *galleryImages; //Array holding the image file paths
@property (strong, nonatomic) UIView *viewBack;
@property (strong, nonatomic) UIView *viewFront;

@property (strong, nonatomic) UIScrollView * scrollFront;
@property (strong, nonatomic) UIScrollView * scrollBack;

@property (strong, nonatomic) UIImageView *imgFront;
@property (strong, nonatomic) UIImageView *imgBack;
//@property (strong, nonatomic) PromotionCard * pCard;
-(void)initView:(NSArray *)arrImage;
- (void)FlipUI;
-(void)autoRotate;
-(void)initView2:(NSString *)strTemplateData;
@end
