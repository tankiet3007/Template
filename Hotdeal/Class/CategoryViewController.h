//
//  CategoryViewController.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    int productID;
    int totalItemInRow;
    LocationObj *locationStored;
    UITableView *tableCategoryView;
    BOOL isLoadMore;
    int limitProductGet;
    int totalProduct;
}

@property(nonatomic, strong)NSString *titleCategory;
@property(nonatomic, strong)NSMutableArray *dataSource;

- (id)initWithProductID:(int)idItem withTitle:(NSString *)title;
- (void)opendDetailDeal:(NSNumber *)indexItem;

@end
