//
//  HomePageTableViewCell.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewCell : UITableViewCell<UIScrollViewDelegate> {
    UILabel *titleCatetory;
    UIButton *viewCategory;
    UIScrollView *scrollView;
    int countItem;
}

@property(nonatomic,weak)id rootView;
@property(nonatomic,weak)CategoryHome *dataCell;

- (void)setupDataForeCell:(CategoryHome *) data;

@end
