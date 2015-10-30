//
//  CategoryTableViewCell.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell {
    int totalItem;
}

@property(nonatomic,weak)id rootView;
@property(nonatomic, strong)NSMutableArray *listButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier numberItem:(int)count;
- (void)setupDataForeCell:(NSArray *)data withStartIndex:(int)startIndex;

@end
