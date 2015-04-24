//
//  LoginCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containViewLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end
