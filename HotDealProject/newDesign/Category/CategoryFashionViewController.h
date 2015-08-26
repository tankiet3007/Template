//
//  CategoryFashionViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryObject.h"
@interface CategoryFashionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UITableView * tableviewCategory;
@property (nonatomic,strong) NSString * strTitle;
@property (nonatomic,strong) NSString * strCateId;
@property (nonatomic, strong) CategoryObject * cateItem;
@property (strong, nonatomic) UICollectionView *collectionView;

@end
