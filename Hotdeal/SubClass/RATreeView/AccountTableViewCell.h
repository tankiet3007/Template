//
//  AccountTableViewCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/22/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *signIn;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *location;

@end
