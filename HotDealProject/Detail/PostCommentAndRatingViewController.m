//
//  PostCommentAndRatingViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PostCommentAndRatingViewController.h"
#import "AppDelegate.h"
#import "CustomCollectionView.h"
@interface PostCommentAndRatingViewController ()

@end

@implementation PostCommentAndRatingViewController
{
    NSMutableArray * arrImageSelected;
    CustomCollectionView * cV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Đánh giá và Bình luận"];
    cV = [[CustomCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -100)];
    [self.view addSubview:cV];
    [cV initCollectionView];
    arrImageSelected = [NSMutableArray new];
    cV.delegate = self;
}
-(void)openPicker
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SNPicker" bundle:nil];
    self.imagePickerNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerNC"];
    [self.imagePickerNavigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    self.imagePickerNavigationController.imagePickerDelegate = self;
    self.imagePickerNavigationController.pickerType = kPickerTypePhoto;
    [self presentViewController:self.imagePickerNavigationController animated:YES completion:^{ }];
}
#pragma mark - SNImagePickerDelegate

- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info
{
    
    // If you Pick a photos you can get images like this
    __block int iNum = 0;
    for (int i = 0; i < info.count; i++) {
        iNum += 1;
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:info[i] resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            [arrImageSelected addObject:image];
            if (iNum == info.count) {
                cV.arrImageSelected = arrImageSelected;
                [cV reloadData];
            }
        } failureBlock:^(NSError *error) {     }];
    }
   
    /*
     If you Pick a movie you can get an asset url like this and do something with asset
     NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
     */
}

- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
