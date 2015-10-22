//
//  CollectionMenu.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/21/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionMenu : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@end
