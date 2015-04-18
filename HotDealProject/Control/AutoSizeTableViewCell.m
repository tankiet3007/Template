//
//  AutoSizeTableViewCell.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/18/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AutoSizeTableViewCell.h"

@implementation AutoSizeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// (1)
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // (2)
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    // (3)
    self.desLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.desLabel.frame);
}
@end
