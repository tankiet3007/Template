//
//  ForgotPasswordViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/3/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
- (IBAction)sendEmailToConfirm:(id)sender;

@end
