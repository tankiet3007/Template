//
//  SNAssetsVC.m
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import "SNAssetsVC.h"
#import "SNCustomCell.h"
#import "SNImagePickerNC.h"

@interface SNAssetsVC ()

@end

@implementation SNAssetsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.assets = [NSMutableArray array];
    self.thumbnails = [NSMutableArray array];
    self.collectionView.delegate = (id)self;
    self.collectionView.dataSource = (id)self;
    [self preparePhotos];
    if (((SNImagePickerNC *)(self.navigationController)).pickerType == kPickerTypeMovie) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self.collectionView addGestureRecognizer:longPressGesture];
        longPressGesture.delegate = (id)self;
        [self getAssetsDurations];
    }
    UIImage *image = [UIImage imageNamed:@"bt_back"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"bt_back"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;

}
-(void)backbtn_click
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    self.collectionView.userInteractionEnabled = NO;
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil)
        NSLog(@"Long press on collection view but not on a row");
    else{
        NSLog(@"long press on collection view at row %ld", (long)indexPath.row);
        [self playAlAsset:self.assets[indexPath.row]];
    }
}

- (void)preparePhotos
{
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result == nil) {
            return;
        }
        [self.assets addObject:result];
        [self.thumbnails addObject:[UIImage imageWithCGImage:[result thumbnail]]];
        [self.collectionView reloadData];
    }];
    self.checkedAssetsNumbers = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (int i = 0; i < self.assets.count; i++) {
        [self.checkedAssetsNumbers addObject:[NSNull null]];
    }
    [self.collectionView reloadData];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Xong" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked:)];
     [doneBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:doneBtn];
}

- (void)doneBtnClicked:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        BOOL isUserCheckAssets = NO;
        for (int i = 0; i < strongSelf.assets.count; i++) {
            if (![strongSelf.checkedAssetsNumbers[i] isEqual:[NSNull null]]) {
                isUserCheckAssets = YES;
            }
        }
        if (isUserCheckAssets) {
            strongSelf.info = [NSMutableArray array];
            for (int i = 0; i < strongSelf.assets.count; i++)
            {
                if (strongSelf.checkedAssetsNumbers[i] != [NSNull null]) {
                    ALAsset *myAsset = (ALAsset *)(strongSelf.assets[i]);
                    [strongSelf.info addObject:[[myAsset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[myAsset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]]];
                }
            }
            if ([((SNImagePickerNC *)(strongSelf.navigationController)).imagePickerDelegate respondsToSelector:@selector(imagePicker:didFinishPickingWithMediaInfo:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [((SNImagePickerNC *)(strongSelf.navigationController)).imagePickerDelegate imagePicker:((SNImagePickerNC *)(strongSelf.navigationController)) didFinishPickingWithMediaInfo:strongSelf.info];
                    }];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{  }];
            });
        }
    });
}

- (void)getAssetsDurations
{
    self.assetsDurations = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (ALAsset *alAsset in self.assets) {
        if ([alAsset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
            if ([alAsset valueForProperty:ALAssetPropertyDuration] != ALErrorInvalidProperty) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"mm:ss"];
                [self.assetsDurations addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue]]]];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UIImage *thumbnail = self.thumbnails[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        if (thumbnail.size.width > thumbnail.size.height) {
            CellIdentifier = @"CellLong";
        }else{
            CellIdentifier = @"CellHigh";
        }
    }else{
        CellIdentifier = @"Cell";
    }
    SNCustomCell *cell = (SNCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = thumbnail;
    if (((SNImagePickerNC *)(self.navigationController)).pickerType == kPickerTypeMovie) {
        cell.duration.hidden = NO;
        cell.duration.text =  self.assetsDurations[indexPath.row];
    }else{
        cell.duration.hidden = YES;
        cell.check.frame = cell.imageView.frame;
    }
    if ([self.checkedAssetsNumbers[indexPath.row] isEqual:[NSNull null]]) {
        cell.check.hidden = YES;
    }
    else {
        cell.check.hidden = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNCustomCell *cell = (SNCustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.check.hidden)
    {
        [self.checkedAssetsNumbers replaceObjectAtIndex:indexPath.row withObject:@1];
        cell.check.hidden = NO;
    }
    else{
        [self.checkedAssetsNumbers replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
        cell.check.hidden = YES;
    }
}

#pragma mark - Play Movie

-(void)playAlAsset:(ALAsset *)asset
{
    if (!self.isPlayerPlaying)
    {
        self.isPlayerPlaying = YES;
        NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
        self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.playerVC
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:self.playerVC.moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.playerVC.moviePlayer];
        
        self.playerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.playerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.playerVC animated:YES completion:^{
            NSLog(@"done present player");
        }];
        [self.playerVC.moviePlayer setFullscreen:NO];
        [self.playerVC.moviePlayer prepareToPlay];
        [self.playerVC.moviePlayer play];
    }
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    if ([aNotification.name isEqualToString: MPMoviePlayerPlaybackDidFinishNotification]) {
        NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        
        if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
        {
            MPMoviePlayerController *moviePlayer = [aNotification object];
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:moviePlayer];
            [self dismissViewControllerAnimated:YES completion:^{  }];
        }
        self.collectionView.userInteractionEnabled = YES;
        self.isPlayerPlaying = NO;
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
