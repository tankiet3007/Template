//
//  HomePageViewController.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DDPageControl.h"

@interface HomePageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate> {
    UITableView *tableHomeView;
    UIView *contentBanner;
    iCarousel *bannerCarousel;
    DDPageControl *pgCtr;
}

@property(nonatomic, strong)NSMutableArray *dataSource;
@property(nonatomic, strong)NSArray *bannerSource;

-(void)opendCategry:(NSNumber *)idProduct withTitle:(NSString *)title;
- (void)opendDetailDeal:(ProductObj *)itemData;

@end
