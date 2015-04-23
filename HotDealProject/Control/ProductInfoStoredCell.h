//
//  ProductInfoStoredCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoStoredCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnChoice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnDestroy;
@property (weak, nonatomic) IBOutlet UIImageView *imgProductCell;

@end
