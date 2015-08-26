//
//  NearLocationViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"

@interface NearLocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MapView * mapView;

@property(nonatomic,strong)UITableView * tableDeal;
@end
