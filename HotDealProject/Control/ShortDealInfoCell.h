//
//  ShortDealInfoCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/22/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortDealInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnChoice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStandarPrice;

@end
