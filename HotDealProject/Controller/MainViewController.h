//
//  MainViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
#import "ShoppingCartController.h"
#import "CartViewController.h"
//#import "UITableView+DragLoad.h"
@interface MainViewController : UIViewController<UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate,slideImageDelegate, ShoppingCartDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableViewMain;
@end
