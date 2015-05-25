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
@property (strong, nonatomic) NSDictionary * dictResponse;
@property (assign, nonatomic) int iIndexAddress;
@property (assign, nonatomic) BOOL isModify;
@end
@protocol AddressTableDelegate <NSObject>
-(void)updateTableAddress:(NSString *)strAddress;
@end