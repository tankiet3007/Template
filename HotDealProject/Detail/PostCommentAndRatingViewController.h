//
//  PostCommentAndRatingViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionView.h"
@interface PostCommentAndRatingViewController : UIViewController<CustomCollectionViewDelegate, SNImagePickerDelegate>
@property (strong, nonatomic) SNImagePickerNC *imagePickerNavigationController;
@end
