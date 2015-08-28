//
//  CustomCollectionView.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/26/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNImagePickerNC.h"
#import "DLStarRating/DLStarRatingControl.h"
@protocol CustomCollectionViewDelegate;
@interface CustomCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate,DLStarRatingDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray * arrImageSelected;
-(void)initCollectionView;
-(void)reloadData;
@property id<CustomCollectionViewDelegate>delegate;

@end
@protocol CustomCollectionViewDelegate <NSObject>
-(void)openPicker;
@end
