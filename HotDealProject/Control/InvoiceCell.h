//
//  InvoiceCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * lblQuantityProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalOfBill;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyAward;
@property (weak, nonatomic) IBOutlet UILabel *lblCash;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckout;

@end
