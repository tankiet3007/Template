//
//  AlbumTVC.h
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNAssetsVC.h"

@interface SNAlbumTVC : UITableViewController <UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) SNAssetsVC *videosVC;
@property (nonatomic) int assetsGroupIndex;
@property (nonatomic) int numberOfGroups;

@end
