//
//  LoginCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnDateOfBirth;
@property (weak, nonatomic) IBOutlet UIButton *btnGender;

@end
