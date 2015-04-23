//
//  ShoppingCartController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate>
@property(nonatomic,strong)UITableView * tableViewProduct;
@property(nonatomic,strong)NSMutableArray * arrProduct;
@end
