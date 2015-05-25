//
//  AccountInfoViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartController.h"
#import "EmailPromotionViewController.h"
#import "AddressViewController.h"
#import "PersonalInfoViewController.h"
@interface AccountInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ShoppingCartDelegate,ProvineDelegate, AddressDelegate, InfoDelegate>
@property (nonatomic, strong) UITableView * tableInfo;
@end
