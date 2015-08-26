//
//  CustomCollectionView.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/26/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CustomCollectionView.h"
#import "ImageCell.h"
#import "CustomCollectionItem.h"
@implementation CustomCollectionView
{
    UIImageView * fullScreenImageView;
    UIButton * originalImageView;
}
@synthesize collectionView;
@synthesize arrImageSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)reloadData
{
    [collectionView reloadData];
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-100) collectionViewLayout:flowLayout];
    
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionItem" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionItem"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderHome" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderHome"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
    }
    return reusableview;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrImageSelected count] +1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ImageCell";
    ImageCell *cell = (ImageCell *)[collectionViews dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.btnImageView.tag = indexPath.row;
    if (indexPath.row == [arrImageSelected count]) {
        [cell.btnImageView addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnImageView setBackgroundColor:[UIColor lightGrayColor]];
        return cell;
    }
    else
    {
        [cell.btnImageView addTarget:self action:@selector(showFullscreen:) forControlEvents:UIControlEventTouchUpInside];
        if ([arrImageSelected count] > 0) {
            UIImage * image = [arrImageSelected objectAtIndex:indexPath.row];
            [cell.btnImageView setBackgroundImage:image forState:UIControlStateNormal];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 90);
}

-(void)showPicker:(UIButton *)sender
{
    [self.delegate openPicker];
}
-(void)showFullscreen:(UIButton *)sender
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    originalImageView = sender;
    fullScreenImageView = [[UIImageView alloc] init];
    [fullScreenImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    fullScreenImageView.image = [UIImage imageNamed:@"demo2.jpg"];
    // ***********************************************************************************
    // You can either use this to zoom in from the center of your cell
    CGRect tempPoint = CGRectMake(sender.center.x, sender.center.y, 0, 0);
    CGRect startingPoint = [self convertRect:tempPoint fromView:[self.collectionView cellForItemAtIndexPath:selectedIndexPath]];
    [fullScreenImageView setFrame:startingPoint];
    [fullScreenImageView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.9f]];
    
    [self addSubview:fullScreenImageView];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [fullScreenImageView setFrame:CGRectMake(0,
                                                                  0,
                                                                  self.bounds.size.width,
                                                                  self.bounds.size.height)];
                     }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenImageViewTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [fullScreenImageView addGestureRecognizer:singleTap];
    [fullScreenImageView setUserInteractionEnabled:YES];
}

- (void)fullScreenImageViewTapped:(UIGestureRecognizer *)gestureRecognizer {
    
    CGRect point=[self convertRect:originalImageView.bounds fromView:originalImageView];
    
    gestureRecognizer.view.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [(UIImageView *)gestureRecognizer.view setFrame:point];
                     }];
    [self performSelector:@selector(animationDone:) withObject:[gestureRecognizer view] afterDelay:0.4];
    
}

-(void)animationDone:(UIView  *)view
{
    [fullScreenImageView removeFromSuperview];
    fullScreenImageView = nil;
}
@end
