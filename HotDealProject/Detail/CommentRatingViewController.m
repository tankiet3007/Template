//
//  CommentRatingViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CommentRatingViewController.h"
#import "Appdelegate.h"
#import "CommentBasicCell.h"
#import "CommentDetailCell.h"
@interface CommentRatingViewController ()

@end

@implementation CommentRatingViewController
@synthesize tableViewComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUITableView];
    [self initNavigationbar:@"Đánh giá và Bình luận"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initUITableView
{
    tableViewComment = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -160) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewComment];
    tableViewComment.backgroundColor = [UIColor whiteColor];
    tableViewComment.dataSource = self;
    tableViewComment.delegate = self;
    tableViewComment.separatorColor = [UIColor clearColor];
    tableViewComment.showsVerticalScrollIndicator = NO;
    tableViewComment.sectionHeaderHeight = 0.0;
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(0, ScreenHeight-160, ScreenWidth, 50)];
    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    [btnDone setTitle:@"GỬI BÌNH LUẬN MỚI CỦA BẠN" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnDone addTarget:self action:@selector(newComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}
-(void)newComment
{
    
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:strTitle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CommentBasicCell *cell = (CommentBasicCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentBasicCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentBasicCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureCommentBasicCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        CommentDetailCell *cell = (CommentDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentDetailCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentDetailCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureCommentCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}
- (void)configureCommentCell:(CommentDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.starRating.rating = 3.5;
    cell.starRating.userInteractionEnabled = NO;
    cell.lblComment.text = @"Update 1: This manual calculation of the cell's height.";
    cell.lblComment.numberOfLines = 0;
    cell.lblComment.preferredMaxLayoutWidth = CGRectGetWidth(cell.lblComment.frame);
    [cell.lblComment setNeedsUpdateConstraints];
    NSArray * arrImage = [NSArray arrayWithObjects:@"demo1.jpg",@"demo2.jpg",@"demo1.jpg",@"demo2.jpg", nil];
    int x = 0;
    for (int i = 0 ; i < [arrImage count]; i++) {
        UIImageView * imv = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 60, 60)];
        NSString * strImage = [arrImage objectAtIndex:i];
        imv.image = [UIImage imageNamed:strImage];
        [cell.lblScrollview addSubview:imv];
        x += 70;
    }
    cell.lblScrollview.contentSize = CGSizeMake(x, cell.lblScrollview.frame.size.height);
    cell.lblScrollview.showsHorizontalScrollIndicator = NO;
}

- (void)configureCommentBasicCell:(CommentBasicCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.starRating.rating = 3.5;
    cell.starRating.userInteractionEnabled = NO;
    cell.lblComment.text = @"Update 1: This answer was for iOS 7. I find auto layout in table view cells to be very unreliable since iOS 8, even for very simple layouts. After lots of experimentation, I (mostly) went back to doing manual layout and manual calculation of the cell's height.";
    cell.lblComment.numberOfLines = 0;
    cell.lblComment.preferredMaxLayoutWidth = CGRectGetWidth(cell.lblComment.frame);
    [cell.lblComment setNeedsUpdateConstraints];
}

- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath {
    //if cell has image return yes;
    return YES;
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static CommentBasicCell *sizingCell = nil;
        if (sizingCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentBasicCell" owner:self options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewComment dequeueReusableCellWithIdentifier:@"CommentBasicCell"];
        });
        
        [self configureCommentBasicCell:sizingCell forRowAtIndexPath:indexPath];
        return [self calculateHeightForConfiguredSizingCell:sizingCell];
    }
    if (indexPath.row == 1) {
        static CommentDetailCell *sizingCell = nil;
        if (sizingCell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentDetailCell" owner:self options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewComment dequeueReusableCellWithIdentifier:@"CommentDetailCell"];
        });
        
        [self configureCommentCell:sizingCell forRowAtIndexPath:indexPath];
        return [self calculateHeightForConfiguredSizingCell:sizingCell];
    }
    return 0;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}
@end
