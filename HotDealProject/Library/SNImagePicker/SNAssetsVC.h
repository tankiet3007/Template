//
//  SNAssetsVC.h
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SNAssetsVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ALAssetsGroup *assetsGroup;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *checkedAssetsNumbers;
@property (strong, nonatomic) NSMutableArray *info;
@property (strong, nonatomic) NSMutableArray *thumbnails;
@property (strong, nonatomic) NSMutableArray *assetsDurations;
@property (nonatomic) BOOL isPlayerPlaying;
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;

@end
