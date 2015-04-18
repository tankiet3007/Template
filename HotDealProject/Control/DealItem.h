//
//  DealItem.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/12/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealItem : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblNumOfBook;
@property (weak, nonatomic) IBOutlet UILabel *lblStandarPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnTemp;

@end
