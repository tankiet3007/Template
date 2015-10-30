//
//  CategoryTableViewCell.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "DYRateView.h"

#define kTagForItemInCell       6400
#define kTagForImageInItem      6501
#define kTagForTitleInItem      6601
#define kTagForIconDiscount     6701
#define kTagForStarRating       6801
#define kTagForRealPrice        6901
#define kTagForDiscountPrice    6301

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier numberItem:(int)count {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        totalItem = count;
        self.listButton = [[NSMutableArray alloc] init];
        int widthItem = 130;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
        float distan = (SCREEN_WIDTH - (widthItem * count))/(count + 1);
        for(int i = 0; i < count; i++) {
            int startX = distan + i*(widthItem + distan);
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(startX, 10, 130, 216);
            item.layer.borderWidth = 1;
            item.layer.borderColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0].CGColor;
            item.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [item addTarget:self action:@selector(opendDetail:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:item];
            [self.listButton addObject:item];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120, 100)];
            imageView.tag = kTagForImageInItem;
            imageView.userInteractionEnabled = NO;
            [item addSubview:imageView];
            
            UIButton *discountImage = [UIButton buttonWithType:UIButtonTypeCustom];
            discountImage.frame = CGRectMake(10, 0, 27, 24);
            discountImage.tag = kTagForIconDiscount;
            [discountImage setBackgroundImage:[UIImage imageNamed:@"icon_tagsale.png"] forState:UIControlStateNormal];
            discountImage.userInteractionEnabled = NO;
            discountImage.titleLabel.font = kBoldsyStemFonSizeRevert(10);
            [discountImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [item addSubview:discountImage];
            
            UILabel *titleItem = [[UILabel alloc] initWithFrame:CGRectMake(5, 115, 120, 37)];
            titleItem.tag = kTagForTitleInItem;
            titleItem.font = [UIFont systemFontOfSize:13];//kSystemFonSizeRevert(10);
            titleItem.textColor = [UIColor colorWithWhite:60.0/255.0 alpha:1.0];
            titleItem.numberOfLines = 2;
            //            titleItem.lineBreakMode = NSLineBreakByWordWrapping;
            [item addSubview:titleItem];
            
            UIView *contentRateView = [[UIView alloc] initWithFrame:CGRectMake(5, 152, 120, 20)];
            contentRateView.tag = kTagForStarRating;
            [item addSubview:contentRateView];
            
            DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 3, contentRateView.bounds.size.width - 50, 14) fullStar:[UIImage imageNamed:@"start_yellow.png"] emptyStar:[UIImage imageNamed:@"start_grey.png"]];
            rateView.tag = (kTagForStarRating + 1);
            rateView.padding = 0;
            rateView.alignment = RateViewAlignmentLeft;
            rateView.editable = NO;
            [contentRateView addSubview:rateView];
            
            UILabel *totalRating = [[UILabel alloc] initWithFrame:CGRectMake(rateView.bounds.size.width+2, 0, 35, 20)];
            totalRating.tag = (kTagForStarRating + 2);
            totalRating.backgroundColor = [UIColor clearColor];
            totalRating.textColor = [UIColor colorWithWhite:118.0/255.0 alpha:1.0];
            totalRating.font = kSystemFonSizeRevert(11);
            [contentRateView addSubview:totalRating];
            
            UILabel *realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 170, 120, 18)];
            realPriceLabel.tag = kTagForRealPrice;
            realPriceLabel.font = kSystemFonSizeRevert(10);
            realPriceLabel.textColor = [UIColor colorWithWhite:153.0/255.0 alpha:1.0];
            [item addSubview:realPriceLabel];
            
            UILabel *discountPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 188, 120, 20)];
            discountPriceLabel.tag = kTagForDiscountPrice;
            discountPriceLabel.font = kSystemFonSizeRevert(13);
            discountPriceLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:28.0/255.0 alpha:1.0];
            [item addSubview:discountPriceLabel];
        }
    }
    return self;
}

- (void)setupDataForeCell:(NSArray *)data withStartIndex:(int)startIndex {
    for(int i = 0; i < [data count]; i++) {
        if(i >= totalItem) {
            break;
        }
        ProductObj *itemData = [data objectAtIndex:i];
        UIButton *item = [_listButton objectAtIndex:i];
        item.tag = startIndex+i;
        item.hidden = NO;
        
        NSString *nameItem = itemData.nameProduct;
        int rateValue = itemData.rateValue;
        int rateTotal = itemData.rateTotal;
        int discount = itemData.discountValue;
        NSString *priceString = [NSString stringWithFormat:@"%dđ",itemData.listPrice];
        NSString *discountString = [NSString stringWithFormat:@"%dđ",itemData.priceProduct];
        
        UILabel *titleItem = (UILabel *)[item viewWithTag:kTagForTitleInItem];
        UIButton *discountImage = (UIButton *)[item viewWithTag:kTagForIconDiscount];
        titleItem.text = nameItem;
        [discountImage setTitle:[[NSString stringWithFormat:@"%d",discount] stringByAppendingString:@"%"] forState:UIControlStateNormal];
        
        UIImageView *image = (UIImageView *)[item viewWithTag:kTagForImageInItem];
        if(image) {
            NSString *imageString = itemData.imageDeal;
            if(imageString && imageString.length > 0) {
                [image setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"img_thumb.png"]];
            }
        }
        
        UIView *contentRateView = (UIView *)[item viewWithTag:kTagForStarRating];
        if(contentRateView) {
            DYRateView *rateView = (DYRateView *)[contentRateView viewWithTag:(kTagForStarRating + 1)];
            rateView.rate = rateValue;
            
            UILabel *totalRating = (UILabel *)[item viewWithTag:(kTagForStarRating + 2)];
            totalRating.text = [NSString stringWithFormat:@"(%d)",rateTotal];
        }
        
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:attributes];
        [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBaselineOffsetAttributeName : @5} range:NSMakeRange([priceString length] - 1, 1)];
        
        UILabel *realPriceLabel = (UILabel *)[item viewWithTag:kTagForRealPrice];
        realPriceLabel.attributedText = attributedString;
        
        UILabel *discountPriceLabel = (UILabel *)[item viewWithTag:kTagForDiscountPrice];
        //        NSDictionary* attributes1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:discountString attributes:nil];
        [attributedString1 setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]
                                           , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([discountString length] - 1, 1)];
        discountPriceLabel.attributedText = attributedString1;
    }
    
    if([data count] < totalItem) {
        for(int i = [data count]; i < totalItem; i++) {
            UIButton *item = [_listButton objectAtIndex:i];
            item.hidden = YES;
        }
    }
}

- (void)opendDetail:(UIButton *)sender {
    NSNumber *indexProduc = [NSNumber numberWithInt:(int)sender.tag];
    if (self.rootView && [self.rootView respondsToSelector:@selector(opendDetailDeal:)]) {
        [self.rootView performSelector:@selector(opendDetailDeal:) withObject:indexProduc];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
