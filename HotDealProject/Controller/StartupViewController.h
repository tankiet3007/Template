//
//  StartupViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol StartupDelegate;
@interface StartupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
//{
//    id<StartupDelegate> delegate;
//}
//@property id<StartupDelegate>delegate;

@property(nonatomic,strong)UITableView * tableViewMain;
@property (nonatomic,assign)BOOL isFromLeftMenu;
@end
//@protocol StartupDelegate <NSObject>
//-(void)updateLocation;
//@end
