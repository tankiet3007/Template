//
//  ProductListViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/22/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProductListDelegate;
@interface ProductListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate>
{
    id<ProductListDelegate> delegate;
}
@property id<ProductListDelegate>delegate;

@property(nonatomic,strong)UITableView * tableViewProduct;
@property(nonatomic,strong)NSMutableArray * arrProduct;
@property(nonatomic,strong)NSDictionary * dictDealDetail;
@end
@protocol ProductListDelegate <NSObject>
-(void)updateTotalSeletedItem:(NSMutableArray *)arrTotalItem;
@end

