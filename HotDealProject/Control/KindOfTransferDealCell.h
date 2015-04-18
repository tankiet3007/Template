//
//  KindOfTransferDealCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/18/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KindOfTransferDealCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UIImageView *imgKindOfTransfer;
@property (weak, nonatomic) IBOutlet UILabel *lblKindOfTransferTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblKindOfTransferDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblExtension;

@end
