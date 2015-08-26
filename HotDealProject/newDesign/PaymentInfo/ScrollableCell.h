//
//  ScrollableCell.h
//  FelixV1
//
//  Created by MAC on 11/25/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCell;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleScroll;

@end
