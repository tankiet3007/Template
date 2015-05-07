//
//  UserAmountViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/7/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAmountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vContain;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblUserRecieve;
@property (weak, nonatomic) IBOutlet UILabel *lblUserUsed;
- (IBAction)useAction:(id)sender;

@end
