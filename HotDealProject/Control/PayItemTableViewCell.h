//
//  PayItemTableViewCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/5/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vContain;
@property (weak, nonatomic) IBOutlet UILabel *lblBookDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalOfBill;
@property (weak, nonatomic) IBOutlet UILabel *lblBookID;

@end
