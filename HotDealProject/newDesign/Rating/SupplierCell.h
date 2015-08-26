//
//  SupplierCell.h
//  FelixV1
//
//  Created by MAC on 8/19/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface SupplierCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNumOfBook;
@property (weak, nonatomic) IBOutlet UILabel *lblStandarPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet DLStarRatingControl *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfRating;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;

@end
