//
//  RegisAndLoginController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface RegisAndLoginController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDelegate>
@property (strong, nonatomic)  UIDatePicker *pickerView;
@property (strong, nonatomic)  UIPickerView *pickerGender;
//@property (nonatomic, strong)UITableView * tableViewMain;
@end
