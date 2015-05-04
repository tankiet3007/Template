//
//  ChangePasswordViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCartController.h"
@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate,ShoppingCartDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;
- (IBAction)changePassClick:(id)sender;

@end
