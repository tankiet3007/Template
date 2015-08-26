//
//  CartTravelCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface CartTravelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStandarPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet DLStarRatingControl *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@property (weak, nonatomic) IBOutlet UIButton *btnDestroy;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UITextField *tfQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblNumOfday;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTodate;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDateSub;
@property (weak, nonatomic) IBOutlet UIButton *btnToDateSub;

@end
