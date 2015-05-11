//
//  AddressTableViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDelegate>
@property (strong, nonatomic)  UIPickerView *pickerViewMain;
@end
