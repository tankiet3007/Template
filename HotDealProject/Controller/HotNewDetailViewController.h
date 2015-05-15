//
//  HotNewDetailViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
#import "DealObject.h"
#import "ProductListViewController.h"
#import "ShoppingCartController.h"
@interface HotNewDetailViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate,slideImageDelegate, ProductListDelegate,ShoppingCartDelegate>
@property(nonatomic,strong)UITableView * tableViewDetail;
@property (nonatomic, strong)DealObject * dealObj;
@property (nonatomic,strong)NSMutableArray * arrDealRelateds;
@property (nonatomic, assign)int  iProductID;
@end