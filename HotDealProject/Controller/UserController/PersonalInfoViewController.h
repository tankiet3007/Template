//
//  PersonalInfoViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDelegate>
@property (strong, nonatomic)  UIDatePicker *pickerView;
@property (strong, nonatomic)  UIPickerView *pickerGender;
@property (nonatomic, strong)  UITableView * tableViewInfo;
@property (nonatomic, strong)  NSDictionary * dictResponse;


@end

