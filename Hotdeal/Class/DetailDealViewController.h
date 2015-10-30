//
//  DetailDealViewController.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/29/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailDealViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate> {
    UIScrollView *detailScroll;
    UIScrollView *imageSlideView;
    UIView *infoDealView;
    UIView *introDealView;
    UIView *locationUseView;
    UIView *conditionsView;
    UIView *decriptionView;
    UIView *commentView;
    UIScrollView *suggetionView;
    
    CGRect boundSetForIntroDeal;
    CGRect boundSetForLocationUse;
    CGRect boundSetForConditions;
    CGRect boundSetForDecription;
    
    SWRevealViewController *revealController;
    LocationObj * locationStored;
}

@property(nonatomic, strong)NSMutableArray *listView;
@property(nonatomic, weak)ProductObj *productSelected;

- (id)initWithProduct:(ProductObj *)product;

@end
