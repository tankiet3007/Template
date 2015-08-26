//
//  HeaderDetailCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/21/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
@interface HeaderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNumOfBook;
@property (weak, nonatomic) IBOutlet UILabel *lblStandarPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet ImageSlide *slideImage;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@end
