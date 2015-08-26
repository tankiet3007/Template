//
//  DetailHasProductViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
#import "DealObject.h"
#import "ShoppingCartController.h"
@interface DetailHasProductViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,slideImageDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate, UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableViewDetail;
@property (nonatomic, strong)DealObject * dealObj;
@property (nonatomic,strong)NSMutableArray * arrDealRelateds;
@property (nonatomic, assign)int  iProductID;
@end
