//
//  LocationDetailCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblDration;
@property (weak, nonatomic) IBOutlet UIButton *btnFullList;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;

@end
