//
//  SupplierCell.m
//  FelixV1
//
//  Created by MAC on 8/19/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//

#import "SupplierCell.h"

@implementation SupplierCell
@synthesize lblDiscountPrice,lblNumberOfRating,lblNumOfBook,lblStandarPrice,lblTitle,starRating,imgLogo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
