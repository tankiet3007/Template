//
//  CategoryTravelViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/10/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryObject.h"
#import "TTRangeSlider.h"
@interface CategoryTravelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, TTRangeSliderDelegate>
@property (nonatomic,strong) UITableView * tableviewCategory;
@property (nonatomic,strong) NSString * strTitle;
@property (nonatomic,strong) NSString * strCateId;
@property (nonatomic, strong) CategoryObject * cateItem;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
