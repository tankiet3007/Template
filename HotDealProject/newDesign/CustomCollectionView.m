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
#import "CommentHeaderView.h"
#import "DLStarRatingControl.h"
@implementation CustomCollectionView
{
    UIImageView * fullScreenImageView;
    UIButton * originalImageView;
    DLStarRatingControl * rateControl;
    UITextView * tvComment;
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
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-60) collectionViewLayout:flowLayout];
    
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionItem" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionItem"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CommentHeaderView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CommentHeaderView"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    
    [self initBottomMenu];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
        return CGSizeMake(ScreenWidth, 184);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionViews viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CommentHeaderView *headerView = [collectionViews dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CommentHeaderView" forIndexPath:indexPath];
        if (rateControl!= nil) {
            [rateControl removeFromSuperview];
            rateControl = nil;
        }
        rateControl = [[DLStarRatingControl alloc] initWithFrameCustom:CGRectMake(ScreenWidth/2 - 100, 40, 200, 40) andStars:5 isFractional:YES];
        rateControl.delegate = self;
        rateControl.backgroundColor = [UIColor clearColor];
        rateControl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        rateControl.rating = 4;
        [headerView addSubview:rateControl];
        tvComment = headerView.tvComment;
        tvComment.layer.borderWidth = 1;
        tvComment.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        tvComment.layer.cornerRadius = 5;
        tvComment.layer.masksToBounds = YES;
        tvComment.textColor = [UIColor lightGrayColor];
        tvComment.font = [UIFont systemFontOfSize:13];
        //    tvComment.text = LS(@"MessagePlaceHolder");
        tvComment.delegate = self;
        if(tvComment.text.length == 0){
            tvComment.textColor = [UIColor lightGrayColor];
            tvComment.text = @"Bình luận (giới hạn 150 ký tự)";
            [tvComment resignFirstResponder];
        }
        reusableview = headerView;
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
    [cell.btnImageView addTarget:self action:@selector(showPickerOrFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == [arrImageSelected count]) {
        [cell.btnImageView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.btnImageView setBackgroundImage:nil forState:UIControlStateNormal];
        cell.removeCell.hidden = YES;
        return cell;
    }
    else
    {
        if ([arrImageSelected count] > 0) {
            cell.removeCell.hidden = NO;
            UIImage * image = [arrImageSelected objectAtIndex:indexPath.row];
            [cell.btnImageView setBackgroundImage:image forState:UIControlStateNormal];
            [cell.removeCell addTarget:self action:@selector(removeCell:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}
-(void)removeCell:(UIButton *)sender
{
    ImageCell * cell = (ImageCell *)sender.superview.superview;
    NSIndexPath * indexPathAtCell = [self.collectionView indexPathForCell:cell];
    [arrImageSelected removeObjectAtIndex:indexPathAtCell.row];
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, 90);
}

-(void)showPickerOrFullScreen:(UIButton *)sender
{
    if (sender.tag != [arrImageSelected count]) {
        [self showFullscreen:sender];
    }
    else
    {
        [self.delegate openPicker];
    }
}
-(void)showFullscreen:(UIButton *)sender
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    originalImageView = sender;
    fullScreenImageView = [[UIImageView alloc] init];
    [fullScreenImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    fullScreenImageView.image = [arrImageSelected objectAtIndex:sender.tag];
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        UA_log(@"%@ -- %f", tvComment.text, rateControl.rating);
        return FALSE;
    }
    int lenght = textView.text.length + (text.length - range.length);
    return lenght <= 150;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    tvComment.text = @"";
    tvComment.textColor = [UIColor blackColor];
    return YES;
}
-(void)initBottomMenu
{
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(0, HEIGHT(self) - 60 , WIDTH(self), 50)];
    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    [btnDone setTitle:@"GỬI BÌNH LUẬN" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnDone addTarget:self action:@selector(selectedDone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDone];
}
-(void)selectedDone
{
    ALERT(@"OK", @"OK");
}
-(void)newRating:(DLStarRatingControl *)control :(float)rating
{
     ALERT(@"OK", F(@"%f", rating));
}
@end
