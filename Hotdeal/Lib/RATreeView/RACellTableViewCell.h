//
//  RACellTableViewCell.h
//  RATreeView
//
//  Created by Tran Tan Kiet on 10/22/15.
//  Copyright © 2015 Rafal Augustyniak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgExpanse;

@end
