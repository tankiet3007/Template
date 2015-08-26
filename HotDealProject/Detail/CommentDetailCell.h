//
//  CommentDetailCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface CommentDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DLStarRatingControl *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIScrollView *lblScrollview;
@end
