//
//  HomePageTableViewCell.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "DYRateView.h"

#define kTagForItemInCell       5400
#define kTagForImageInItem      5501
#define kTagForTitleInItem      5601
#define kTagForIconDiscount     5701
#define kTagForStarRating       5801
#define kTagForRealPrice        5901
#define kTagForDiscountPrice    5301


@implementation HomePageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
//        self.rootView = root;
        titleCatetory = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.bounds.size.width - 120, 30)];
        titleCatetory.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleCatetory.backgroundColor = [UIColor clearColor];
        titleCatetory.textColor = [UIColor colorWithWhite:61.0/255.0 alpha:1.0];
        titleCatetory.font = [UIFont systemFontOfSize:14];//kBoldsyStemFonSizeRevert(14);//[UIFont systemFontOfSize:16];
        //        titleCatetory.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleCatetory];
        
        UIView *redSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 26, titleCatetory.bounds.size.width, 4)];
        redSpaceLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:30.0/255.0 alpha:1.0];
        redSpaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [titleCatetory addSubview:redSpaceLine];
        
        UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(15, 39, self.bounds.size.width - 30, 1)];
        spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        spaceLine.backgroundColor = [UIColor colorWithWhite:206.0/255.0 alpha:1.0];
        [self.contentView addSubview:spaceLine];
        
        viewCategory = [UIButton buttonWithType:UIButtonTypeCustom];
        viewCategory.frame = CGRectMake(self.bounds.size.width - 85, 10, 70, 30);
        //        viewCategory.backgroundColor = [UIColor grayColor];
        viewCategory.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [viewCategory setTitle:@"xem thêm >" forState:UIControlStateNormal];
        viewCategory.titleLabel.font = kSystemFonSizeRevert(12);
        viewCategory.titleLabel.textAlignment = NSTextAlignmentRight;
        viewCategory.hidden = YES;
        [viewCategory setTitleColor:[UIColor colorWithWhite:139.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [viewCategory addTarget:self action:@selector(viewCategoryPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:viewCategory];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 54, self.bounds.size.width, 216)];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scrollView.panGestureRecognizer.delaysTouchesBegan = scrollView.delaysContentTouches;
        scrollView.delegate = self;
        scrollView.clipsToBounds = YES;
        scrollView.scrollsToTop = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
    }
    return self;
}

//- (void)setupDataForeCell:(NSMutableDictionary *) data {
//    self.dataCell = data;
//    float xScroll = [[data objectForKey:@"xScroll"] floatValue];
//    
//    NSArray *listItem = [data objectForKey:@"listProduct"];
//    NSString *nameCategory = SetStringFromDataServer([data objectForKey:@"name"]);
//    titleCatetory.text = nameCategory;
//    
//    CGSize sizeText = [titleCatetory.text boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleCatetory.font} context:nil].size;
//    if((sizeText.width + 2) < self.bounds.size.width - 120) {
//        titleCatetory.frame = CGRectMake(titleCatetory.frame.origin.x, titleCatetory.frame.origin.y, sizeText.width + 2, titleCatetory.frame.size.height);
//    }
//    else {
//        titleCatetory.frame = CGRectMake(titleCatetory.frame.origin.x, titleCatetory.frame.origin.y, self.bounds.size.width - 120, titleCatetory.frame.size.height);
//    }
//    
//    int productCount = [[data objectForKey:@"productCount"] intValue];
//    int productID = [[data objectForKey:@"categoryId"] intValue];
//    viewCategory.hidden = (productCount <= [listItem count]);
//    viewCategory.tag = productID;
//    
//    for(int i = 0; i < [listItem count]; i++) {
//        NSDictionary *itemData = [listItem objectAtIndex:i];
//        UIButton *item = (UIButton *)[scrollView viewWithTag:(kTagForItemInCell+i)];
//        if(!item) {
//            int startX = 15 + i*145;
//            
//            item = [UIButton buttonWithType:UIButtonTypeCustom];
//            item.frame = CGRectMake(startX, 0, 130, 214);
//            item.tag = kTagForItemInCell+i;
//            item.layer.borderWidth = 1;
//            item.layer.borderColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0].CGColor;
//            [item addTarget:self action:@selector(opendDetail:) forControlEvents:UIControlEventTouchUpInside];
//            [scrollView addSubview:item];
//            
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120, 100)];
//            imageView.tag = kTagForImageInItem;
//            imageView.userInteractionEnabled = NO;
//            [item addSubview:imageView];
//            
//            UIButton *discountImage = [UIButton buttonWithType:UIButtonTypeCustom];
//            discountImage.frame = CGRectMake(10, 0, 27, 24);
//            discountImage.tag = kTagForIconDiscount;
//            [discountImage setBackgroundImage:[UIImage imageNamed:@"icon_tagsale.png"] forState:UIControlStateNormal];
//            discountImage.userInteractionEnabled = NO;
//            discountImage.titleLabel.font = kBoldsyStemFonSizeRevert(10);
//            [discountImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [item addSubview:discountImage];
//            
//            UILabel *titleItem = [[UILabel alloc] initWithFrame:CGRectMake(5, 115, 120, 37)];
//            titleItem.tag = kTagForTitleInItem;
//            titleItem.font = [UIFont systemFontOfSize:13];//kSystemFonSizeRevert(10);
//            titleItem.textColor = [UIColor colorWithWhite:60.0/255.0 alpha:1.0];
//            titleItem.numberOfLines = 2;
////            titleItem.lineBreakMode = NSLineBreakByWordWrapping;
//            [item addSubview:titleItem];
//            
//            UIView *contentRateView = [[UIView alloc] initWithFrame:CGRectMake(5, 152, 120, 20)];
//            contentRateView.tag = kTagForStarRating;
//            [item addSubview:contentRateView];
//            
//            DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 3, contentRateView.bounds.size.width - 50, 14) fullStar:[UIImage imageNamed:@"start_yellow.png"] emptyStar:[UIImage imageNamed:@"start_grey.png"]];
//            rateView.tag = (kTagForStarRating + 1);
//            rateView.padding = 0;
//            rateView.alignment = RateViewAlignmentLeft;
//            rateView.editable = NO;
//            [contentRateView addSubview:rateView];
//            
//            UILabel *totalRating = [[UILabel alloc] initWithFrame:CGRectMake(rateView.bounds.size.width+2, 0, 35, 20)];
//            totalRating.tag = (kTagForStarRating + 2);
//            totalRating.backgroundColor = [UIColor clearColor];
//            totalRating.textColor = [UIColor colorWithWhite:118.0/255.0 alpha:1.0];
//            totalRating.font = kSystemFonSizeRevert(11);
//            [contentRateView addSubview:totalRating];
//            
//            UILabel *realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 170, 120, 18)];
//            realPriceLabel.tag = kTagForRealPrice;
//            realPriceLabel.font = kSystemFonSizeRevert(10);
//            realPriceLabel.textColor = [UIColor colorWithWhite:153.0/255.0 alpha:1.0];
//            [item addSubview:realPriceLabel];
//            
//            UILabel *discountPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 188, 120, 20)];
//            discountPriceLabel.tag = kTagForDiscountPrice;
//            discountPriceLabel.font = kSystemFonSizeRevert(13);
//            discountPriceLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:28.0/255.0 alpha:1.0];
//            [item addSubview:discountPriceLabel];
//            
//            //rateview: (5,165,120,20)
//            //oldPrice: (5,190,120,20)
//            //newPrice: (5,210,120,20)
//        }
//        else {
//            id viewWithTagImage = [item viewWithTag:(kTagForImageInItem+1)];
//            if(viewWithTagImage && [viewWithTagImage isKindOfClass:[UIImageView class]]) {
//                UIImageView *imageView = viewWithTagImage;
//                imageView.image = [UIImage imageNamed:@""];
//                imageView.tag = kTagForImageInItem;
//            }
//        }
//        item.hidden = NO;
//        
//        NSString *nameItem = SetStringFromDataServer([itemData objectForKey:@"name"]);
//        int rateValue = [[itemData objectForKey:@"rateVal"] intValue];
//        int rateTotal = [[itemData objectForKey:@"rateTotal"] intValue];
//        int discount = [[itemData objectForKey:@"discountValue"] intValue];
//        int price = [[itemData objectForKey:@"listPrice"] intValue];
//        NSString *priceString = [NSString stringWithFormat:@"%dđ",price];
//        int priceDiscount = [[itemData objectForKey:@"price"] intValue];
//        NSString *discountString = [NSString stringWithFormat:@"%dđ",priceDiscount];
//        
//        UILabel *titleItem = (UILabel *)[item viewWithTag:kTagForTitleInItem];
//        UIButton *discountImage = (UIButton *)[item viewWithTag:kTagForIconDiscount];
//        titleItem.text = nameItem;
//        [discountImage setTitle:[[NSString stringWithFormat:@"%d",discount] stringByAppendingString:@"%"] forState:UIControlStateNormal];
//        
//        UIView *contentRateView = (UIView *)[item viewWithTag:kTagForStarRating];
//        if(contentRateView) {
//            DYRateView *rateView = (DYRateView *)[contentRateView viewWithTag:(kTagForStarRating + 1)];
//            rateView.rate = rateValue;
//            
//            UILabel *totalRating = (UILabel *)[item viewWithTag:(kTagForStarRating + 2)];
//            totalRating.text = [NSString stringWithFormat:@"(%d)",rateTotal];
//        }
//        
//        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:attributes];
//        [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBaselineOffsetAttributeName : @5} range:NSMakeRange([priceString length] - 1, 1)];
//        
//        UILabel *realPriceLabel = (UILabel *)[item viewWithTag:kTagForRealPrice];
//        realPriceLabel.attributedText = attributedString;
//
//        UILabel *discountPriceLabel = (UILabel *)[item viewWithTag:kTagForDiscountPrice];
////        NSDictionary* attributes1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:discountString attributes:nil];
//        [attributedString1 setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]
//                                           , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([discountString length] - 1, 1)];
//        discountPriceLabel.attributedText = attributedString1;
//    }
//    if(countItem > [listItem count]) {
//        for(int i=(int)[listItem count]; i < countItem; i++) {
//            UIButton *item = (UIButton *)[scrollView viewWithTag:(kTagForItemInCell+i)];
//            if(item != nil) {
//                item.hidden = YES;
//            }
//        }
//    }
//    countItem = (int)[listItem count];
//    int totalWidth = 15 + countItem*145;
//    [scrollView setContentOffset:CGPointMake(xScroll, scrollView.contentOffset.y) animated:NO];
//    [scrollView setContentSize:CGSizeMake(totalWidth, scrollView.contentSize.height)];
//    [self loadImageWithLazyLoad:xScroll];
//}

- (void)setupDataForeCell:(CategoryHome *) data {
    self.dataCell = data;
    float xScroll = data.startScroll;
    
    NSArray *listItem = data.listProduct;
    titleCatetory.text = data.nameCategory;
    
    CGSize sizeText = [titleCatetory.text boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleCatetory.font} context:nil].size;
    if((sizeText.width + 2) < self.bounds.size.width - 120) {
        titleCatetory.frame = CGRectMake(titleCatetory.frame.origin.x, titleCatetory.frame.origin.y, sizeText.width + 2, titleCatetory.frame.size.height);
    }
    else {
        titleCatetory.frame = CGRectMake(titleCatetory.frame.origin.x, titleCatetory.frame.origin.y, self.bounds.size.width - 120, titleCatetory.frame.size.height);
    }
    
    viewCategory.hidden = (data.productCount <= [listItem count]);
    viewCategory.tag = data.categoryID;
    
    for(int i = 0; i < [listItem count]; i++) {
        ProductObj *itemData = [listItem objectAtIndex:i];
        UIButton *item = (UIButton *)[scrollView viewWithTag:(kTagForItemInCell+i)];
        if(!item) {
            int startX = 15 + i*145;
            
            item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(startX, 0, 130, 216);
            item.tag = kTagForItemInCell+i;
            item.layer.borderWidth = 1;
            item.layer.borderColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0].CGColor;
            [item addTarget:self action:@selector(opendDetail:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:item];
            
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
        else {
            id viewWithTagImage = [item viewWithTag:(kTagForImageInItem+1)];
            if(viewWithTagImage && [viewWithTagImage isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = viewWithTagImage;
                imageView.image = [UIImage imageNamed:@"img_thumb.png"];
                imageView.tag = kTagForImageInItem;
            }
        }
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
    if(countItem > [listItem count]) {
        for(int i=(int)[listItem count]; i < countItem; i++) {
            UIButton *item = (UIButton *)[scrollView viewWithTag:(kTagForItemInCell+i)];
            if(item != nil) {
                item.hidden = YES;
            }
        }
    }
    countItem = (int)[listItem count];
    int totalWidth = 15 + countItem*145;
    [scrollView setContentOffset:CGPointMake(xScroll, scrollView.contentOffset.y) animated:NO];
    [scrollView setContentSize:CGSizeMake(totalWidth, scrollView.contentSize.height)];
    [self loadImageWithLazyLoad:xScroll];
}

- (void)loadImageWithLazyLoad:(float)startScrool {
    int startX = IS_IPHONE?15:30;
    int countSkip = 0;
    int widthContent = IS_IPHONE?145:160;
    
    _dataCell.startScroll = startScrool;
    NSArray *listItem = _dataCell.listProduct;
    
    float maxViewLoad = startScrool + [[UIScreen mainScreen] bounds].size.width;//scrollView.bounds.size.width;
    int tagStart = (startScrool - startX)/widthContent;
    int tagEnd = (maxViewLoad - startX)/widthContent + 1;
    for(int i = tagStart; i < (tagEnd+countSkip); i++) {
        if(i < [listItem count]) {
            ProductObj *dealInfo = [listItem objectAtIndex:i];
            UIButton *viewLoad = (UIButton *)[scrollView viewWithTag:kTagForItemInCell + i];
            
            if(dealInfo && viewLoad) {
                UIImageView *image = (UIImageView *)[viewLoad viewWithTag:kTagForImageInItem];
                if(image) {
                    NSString *imageString = dealInfo.imageDeal;
                    if(imageString && imageString.length > 0) {
                        [image setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"img_thumb.png"]];
                    }
                    image.tag = kTagForImageInItem + 1;
                }
            }
        }
    }
}

- (void)opendDetail:(UIButton *)sender {
    int indexItem = (int)sender.tag - kTagForItemInCell;
    ProductObj *itemData = [self.dataCell.listProduct objectAtIndex:indexItem];
    if (self.rootView && [self.rootView respondsToSelector:@selector(opendDetailDeal:)]) {
        [self.rootView performSelector:@selector(opendDetailDeal:) withObject:itemData];
    }
}

- (void)viewCategoryPress:(UIButton *)sender {
    NSNumber *idProduct = [NSNumber numberWithInt:sender.tag];
    if (self.rootView && [self.rootView respondsToSelector:@selector(opendCategry:withTitle:)]) {
        [self.rootView performSelector:@selector(opendCategry:withTitle:) withObject:idProduct withObject:titleCatetory.text];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self loadImageWithLazyLoad:scroll.contentOffset.x];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
