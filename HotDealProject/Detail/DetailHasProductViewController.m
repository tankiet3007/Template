//
//  DetailHasProductViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "DetailHasProductViewController.h"
#import "HeaderDetailCell.h"
#import "AppDelegate.h"
#import "BBBadgeBarButtonItem.h"
#import "ProductObject.h"
#import "TKDatabase.h"
#import "RatingDetailCell.h"
#import "LocationDetailCell.h"
#import "WebDetailCell.h"
#import "SildeViewController.h"
#import "CommentDetailCell.h"
#import "CommentBasicCell.h"
#import "WebViewController.h"
#import "SupplierCell.h"
#import "ProductDetailCell.h"
#import "LocationTableViewController.h"
@interface DetailHasProductViewController ()

@end

@implementation DetailHasProductViewController
{
    __block NSDictionary * dictDetail;
    MBProgressHUD *HUD;
    BBBadgeBarButtonItem *barButton;
    NSMutableArray * arrProduct;
    NSMutableArray * galleryImages;
}
@synthesize arrDealRelateds;
@synthesize tableViewDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self initHUD];
    [self initData];
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
    [self initData];
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0936459200"]];
}

-(void)initData
{
    NSString * strParam = F(@"product_id=%@",[NSNumber numberWithInt:_iProductID]);
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequest:strParam withURL:URL_GET_DEAL_CONTENT completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        dictDetail = dict;
        NSDictionary * dictCategory = [dict objectForKey:@"category"];
        NSString * sTitle = [dictCategory objectForKey:@"category_name"];
        [self initNavigationbar:sTitle];
        if (dict == nil) {
            return;
        }
        arrDealRelateds = [NSMutableArray new];
        NSArray * arrProducts_recommend = [dict objectForKey:@"products_recommend"];
        for (NSDictionary * dictItem in arrProducts_recommend) {
            DealObject * item = [[DealObject alloc]init];
            item.strTitle = [dictItem objectForKey:@"title"];
            item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.isNew = YES;
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDealRelateds addObject:item];
        }
        //        [self initWebviewExample];
        [self initUITableView];
    }];
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    if (strTitle == nil || [strTitle isEqualToString:@""]) {
        strTitle = @"CHI TIẾT";
    }
    [appdelegate initNavigationbar:self withTitle:strTitle];
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customButton addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeOriginX = 25;
    barButton.badgeOriginY = -5;
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        iBadge += item.iCurrentQuantity;
    }
    barButton.badgeValue = F(@"%d",iBadge);
    self.navigationItem.rightBarButtonItem = barButton;
}
-(void)shoppingCart
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    if ([arrProduct count] == 0) {
        return;
    }
    ShoppingCartController * shopping = [[ShoppingCartController alloc]init];
    [self.navigationController pushViewController:shopping animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)initUITableView
{
    tableViewDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, -35, ScreenWidth, ScreenHeight - 80) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewDetail];
    tableViewDetail.backgroundColor = [UIColor whiteColor];
    tableViewDetail.dataSource = self;
    tableViewDetail.delegate = self;
    tableViewDetail.separatorColor = [UIColor clearColor];
    tableViewDetail.showsVerticalScrollIndicator = NO;
    tableViewDetail.sectionHeaderHeight = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section ==1) {
        return [arrDealRelateds count];
    }
    if (section == 2) {
        return 4;
    }
    if (section == 3) {
        return 2;//2 comment
    }
    return [arrDealRelateds count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 290;
    }
    if (indexPath.section == 1) {
        return 110;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 60;
        }
        if (indexPath.row ==1 ) {
            return 160;
        }
        if (indexPath.row == 2 ||indexPath.row == 3) {
            return 200;
        }
    }
    if (indexPath.section == 3) {
        return [self heightForBasicCellAtIndexPath:indexPath];
    }
    if (indexPath.section == 4)
    {
        return 100;
    }
    return 180;
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
            sizingCell = [self.tableViewDetail dequeueReusableCellWithIdentifier:@"CommentBasicCell"];
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
            sizingCell = [self.tableViewDetail dequeueReusableCellWithIdentifier:@"CommentDetailCell"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeaderDetailCell *cell = (HeaderDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"HeaderDetailCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeaderDetailCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureHeaderCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        ProductDetailCell *cell = (ProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductDetailCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureProductCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            RatingDetailCell *cell = (RatingDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"RatingDetailCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RatingDetailCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [self configureRatingCell:cell forRowAtIndexPath:indexPath];
            return cell;
        }
        if (indexPath.row == 1) {
            LocationDetailCell *cell = (LocationDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationDetailCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationDetailCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [self configureLocationCell:cell forRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 2||indexPath.row == 3) {
            WebDetailCell *cell = (WebDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"WebDetailCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WebDetailCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [self configureWebCell:cell forRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 4) {
        SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:@"SupplierCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureDealCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.section == 3)     {
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
    }
    return nil;
}
#pragma mark configure cell
-(void)configureProductCell:(ProductDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealObject * item = [arrDealRelateds objectAtIndex:indexPath.row];
    int iSetTag = (indexPath.row +1) * 100;
    cell.tfQuantity.tag = iSetTag;
    cell.btnMinus.tag = iSetTag+1;
    cell.btnPlus.tag = iSetTag+2;
    [cell.btnMinus addTarget:self action:@selector(minusQuantity:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusQuantity:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    cell.lblTitle.text = item.strTitle;
    cell.tfQuantity.delegate = self;
    cell.tfQuantity.text = F(@"%d",1);
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
}
-(void)configureDealCell:(SupplierCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(12, 98, ScreenWidth -20, 1)];
    line.tag = 101;
    line.backgroundColor = [UIColor darkGrayColor];
    [cell addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    
    DealObject * item = [arrDealRelateds objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.strTitle;
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    backgroundView.layer.borderColor = [[UIColor clearColor]CGColor];
    backgroundView.layer.borderWidth = 10.0f;
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    float calculatePercent = (1-(float)((float)item.lDiscountPrice/(float)item.lStandarPrice)) *100;
    cell.lblPercentage.text = F(@"%.0f%%", calculatePercent);
    
    cell.starRating.backgroundColor = [UIColor clearColor];
    cell.starRating.rating = 4;
    cell.starRating.userInteractionEnabled = NO;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
    cell.lblNumOfBook.text = F(@"%d",item.buy_number);
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    cell.lblTitle.text = item.strTitle;
}
- (void)configureRatingCell:(RatingDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.starRating.rating = 4;
    cell.starRating.userInteractionEnabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    [cell.contentView addSubview:vPadding];
    
    UIView * vPadding2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 10)];
    vPadding2.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    [cell.contentView addSubview:vPadding2];
}

- (void)configureLocationCell:(LocationDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    //Do something
    UIView * vPadding2 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, 10)];
    vPadding2.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    [cell.contentView addSubview:vPadding2];
    [cell.btnFullList addTarget:self action:@selector(seeMoreLocation) forControlEvents:UIControlEventTouchUpInside];
}
- (void)configureHeaderCell:(HeaderDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arrImage = [dictDetail objectForKey:@"images"];
    NSMutableArray * arrImageRender = [NSMutableArray new];
    for (NSString * item in arrImage) {
        NSString * urlRender = F(@"%@&size=%fx%f", item,ScreenWidth,ScreenWidth);
        urlRender = [urlRender stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        UA_log(@"urlRender : %@", urlRender);
        [arrImageRender addObject:urlRender];
    }
    galleryImages = [NSMutableArray arrayWithArray:arrImageRender];
    cell.slideImage.galleryImages = arrImageRender;
    cell.slideImage.delegate = self;
    [cell.slideImage initScrollLocal2];
    cell.lblTitle.text = [dictDetail objectForKey:@"title"];
    int price = [[dictDetail objectForKey:@"list_price"]intValue];
    NSString * strStardarPrice = F(@"%d", price);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.lblStandarPrice.attributedText = attributedString;
    
    int list_price = [[dictDetail objectForKey:@"price"]intValue];
    NSString * strDiscountPrice = F(@"%d",  list_price);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    cell.lblDiscountPrice.font = [UIFont boldSystemFontOfSize:13];
}
- (void)configureWebCell:(WebDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.webView setDelegate:self];
    if (indexPath.row == 2) {
        cell.lblTitle.text = @"ĐIỀU KIỆN SỬ DỤNG";
        NSString * strHTMLContain = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:%@;font-family:Helvetica;color:#ffff;'>%@",@40,[dictDetail objectForKey:@"condition"] ];
        [cell.webView loadHTMLString:strHTMLContain baseURL:nil];
        [cell.btnFullList addTarget:self action:@selector(seeMoreHTMLCondition) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row == 3) {
        cell.lblTitle.text = @"GIỚI THIỆU CHI TIẾT";
        NSString * strHTMLContain = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:%@;font-family:Helvetica;color:#ffff;'>%@",@40,[dictDetail objectForKey:@"detail"] ];
        [cell.webView loadHTMLString:strHTMLContain baseURL:nil];
        [cell.btnFullList addTarget:self action:@selector(seeMoreHTMLDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.webView.scrollView.scrollEnabled = NO;
    cell.webView.scrollView.bounces = NO;
    UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 190, ScreenWidth, 10)];
    vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    [cell.contentView addSubview:vPadding];
}
- (void)seeMoreHTMLCondition
{
    WebViewController * web = [[WebViewController alloc]init];
    NSString * strHTMLContain = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:%@;font-family:Helvetica;color:#ffff;'>%@",@40,[dictDetail objectForKey:@"condition"] ];
    web.sTitle = LS(@"condition");
    web.strContent = strHTMLContain;
    [self.navigationController pushViewController:web animated:YES];
}
- (void)seeMoreHTMLDetail
{
    WebViewController * web = [[WebViewController alloc]init];
    NSString * strHTMLContain = [NSString stringWithFormat:@"<div style='text-align:justify; font-size:%@;font-family:Helvetica;color:#ffff;'>%@",@40,[dictDetail objectForKey:@"detail"] ];
    web.sTitle = LS(@"feature");
    web.strContent = strHTMLContain;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)topCellClick:(long)index
{
    NSLog(@"delegate %ld",index);
    SildeViewController * promotionDetail = [[SildeViewController alloc]init];
    promotionDetail.arrImages = galleryImages;
    [self presentViewController:promotionDetail animated:NO completion:nil];
}
#pragma mark comment cell
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UIButton * btnComment = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 300, 25)];
        [btnComment setTitle:@"XEM TẤT CẢ 28 BÌNH LUẬN" forState:UIControlStateNormal];
        btnComment.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnComment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnComment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [vHeader addSubview:btnComment];
        
        UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 10)];
        vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
        [vHeader addSubview:vPadding];
        
        return vHeader;
    }
    return nil;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel * lblComment = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 25)];
        lblComment.text = @"BÌNH LUẬN";
        lblComment.font = [UIFont boldSystemFontOfSize:15];
        lblComment.textColor = [UIColor blackColor];
        [vHeader addSubview:lblComment];
        
        UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(5, 35, ScreenWidth - 10, 1)];
        vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
        [vHeader addSubview:vPadding];
        
        return vHeader;
    }
    if (section == 4) {
        UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UILabel * lblComment = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 25)];
        lblComment.text = @"DEAL LIÊN QUAN";
        lblComment.font = [UIFont boldSystemFontOfSize:15];
        lblComment.textColor = [UIColor blackColor];
        [vHeader addSubview:lblComment];
        
        UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(5, 35, ScreenWidth - 10, 1)];
        vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
        [vHeader addSubview:vPadding];
        
        return vHeader;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3|| section == 4) {
        return 40;
    }
    return 0;
}
- (void)configureCommentCell:(CommentDetailCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.starRating.rating = 3;
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
    cell.starRating.rating = 4;
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
-(void)minusQuantity:(UIButton *)sender
{
    int iTag = sender.tag;
    int iRowAtIndex = (iTag - 1)/100 -1;
    //    update object ...
//    ProductObject * pObject = [arrProduct objectAtIndex:iRowAtIndex];
    ProductDetailCell *cell = (ProductDetailCell *)sender.superview.superview;
    int iNum = [cell.tfQuantity.text intValue];
    if (iNum == 0) {
        return;
    }
    iNum = iNum - 1;
    cell.tfQuantity.text = F(@"%d", iNum);
    UA_log(@"btn minus at index: %d", iRowAtIndex);
//    pObject.iCurrentQuantity = iNum;
//    [arrProduct removeObjectAtIndex:iRowAtIndex];
//    [arrProduct insertObject:pObject atIndex:iRowAtIndex];
    
//    NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:1];
//    [self.tableViewDetail beginUpdates];
//    [self.tableViewDetail reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableViewDetail endUpdates];
    
}

-(void)plusQuantity:(UIButton *)sender
{
    int iTag = sender.tag;
    int iRowAtIndex = (iTag - 2)/100 -1;
    //    update object ...
//    ProductObject * pObject = [arrProduct objectAtIndex:iRowAtIndex];
    
    //    [ProductList insertObject:prod atIndex:i];
    ProductDetailCell *cell = (ProductDetailCell *)sender.superview.superview;
    int iNum = [cell.tfQuantity.text intValue];
    iNum = iNum + 1;
    cell.tfQuantity.text = F(@"%d", iNum);
//    pObject.iCurrentQuantity = iNum;
//    [arrProduct removeObjectAtIndex:iRowAtIndex];
//    [arrProduct insertObject:pObject atIndex:iRowAtIndex];
    //    cell.tfQuantity.text = F(@"%d", iNum);
//    [tableViewDetail reloadData];
//    UA_log(@"btn minus at index: %d", iRowAtIndex);
//    NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:1];
//    [self.tableViewDetail beginUpdates];
//    [self.tableViewDetail reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableViewDetail endUpdates];
}
-(void)seeMoreLocation
{
    LocationTableViewController * lcVC = [[LocationTableViewController alloc]init];
    [self.navigationController pushViewController:lcVC animated:YES];
}
@end
