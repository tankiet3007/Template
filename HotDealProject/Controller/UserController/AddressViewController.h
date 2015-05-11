//
//  AddressViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressDelegate;
@interface AddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    id<AddressDelegate> delegate;
}
@property id<AddressDelegate>delegate;

@property (nonatomic, strong)UITableView * tableAddress;
@end
@protocol AddressDelegate <NSObject>
-(void)updateAddress:(NSString *)strAddress;
@end