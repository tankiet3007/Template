//
//  SildeViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 7/28/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
@interface SildeViewController : UIViewController<slideImageDelegate>
@property (nonatomic, strong)NSMutableArray * arrImages;
@property (nonatomic, strong)ImageSlide *imageSlideTop;
@end
