//
//  CategoryFilterViewController.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterDelegate;
@interface CategoryFilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<FilterDelegate> delegate;
}
@property id<FilterDelegate>delegate;
@property (nonatomic, strong) UITableView * tableviewFilter;
@property (nonatomic, strong) NSMutableArray * filterList;
@end
@protocol FilterDelegate <NSObject>
-(void)updateCategoryWithFilterList:(NSMutableArray *)list;
@end
