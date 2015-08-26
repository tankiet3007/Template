//
//  RatingDetailCell.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/21/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
@interface RatingDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DLStarRatingControl *starRating;
@property (weak, nonatomic) IBOutlet UIButton *numOfComment;

@end
