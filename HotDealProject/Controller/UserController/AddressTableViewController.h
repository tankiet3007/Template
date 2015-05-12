//
//  AddressTableViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressTableDelegate;
@interface AddressTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDelegate>
{
    id<AddressTableDelegate> delegate;
}
@property id<AddressTableDelegate>delegate;

@property (strong, nonatomic) UIPickerView *pickerViewMain;
@property (strong, nonatomic) NSString * strTitle;
@end
@protocol AddressTableDelegate <NSObject>
-(void)updateTableAddress:(NSString *)strAddress;
@end