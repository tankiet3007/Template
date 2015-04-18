//
//  HotNewDetailViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "HotNewDetailViewController.h"
#import "AppDelegate.h"
#import "CheckQuantityDealCell.h"
@interface HotNewDetailViewController ()

@end

@implementation HotNewDetailViewController
{
    UIView * viewHeader;
    ImageSlide *imageSlideTop;
    UILabel * lblDescription;
    float fHeightOfDescription;
}
#define PADDING 10//HEADER_HEIGHT
#define HEADER_HEIGHT 370//HEADER_HEIGHT
@synthesize tableViewDetail;
@synthesize dealObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"CHI TIẾT"];
    
    lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT, 300, 0)];
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblDescription.numberOfLines = 0;
    lblDescription.text = dealObj.strDescription;
    lblDescription.font = [UIFont systemFontOfSize:14];
    [lblDescription sizeToFit];
    CGRect rect = lblDescription.frame;
    fHeightOfDescription = rect.size.height;
    
    [self setupSlide];
    [self setupViewHeader];
    [self initUITableView];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupSlide
{
    if (imageSlideTop != nil) {
        [imageSlideTop removeFromSuperview];
        imageSlideTop = nil;
    }
    imageSlideTop = [[ImageSlide alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth- PADDING *2, ScreenWidth- PADDING *2 -20)];
    NSMutableArray * galleryImages = [NSMutableArray arrayWithObjects:@"beef",@"beef",@"beef",@"beef",@"beef", nil];
    imageSlideTop.galleryImages = galleryImages;
    imageSlideTop.delegate = self;
    [imageSlideTop initScroll];
}
-(void)setupViewHeader
{
    if (viewHeader != nil) {
        NSArray * arrSubview = [viewHeader subviews];
        for (UIView *item in arrSubview) {
            [item removeFromSuperview];
        }
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    float realHeight = HEADER_HEIGHT + fHeightOfDescription;
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(PADDING, PADDING, ScreenWidth - PADDING*2, realHeight)];
    UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(viewHeader), 40)];
    lblTitle.numberOfLines = 2;
    lblTitle.text = dealObj.strTitle;
    lblTitle.font = [UIFont boldSystemFontOfSize:15];
    lblTitle.textColor = [UIColor orangeColor];
    [viewHeader addSubview:lblTitle];
    
    [viewHeader addSubview:imageSlideTop];
    
    UILabel * lblStandarPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(imageSlideTop) + HEIGHT(imageSlideTop), 150, 18)];
    lblStandarPrice.font = [UIFont systemFontOfSize:14];
    lblStandarPrice.textColor = [UIColor blackColor];
    NSString * strStardarPrice = F(@"%ld", dealObj.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    lblStandarPrice.attributedText = attributedString;
    [lblStandarPrice sizeToFit];
    [viewHeader addSubview:lblStandarPrice];
    
    UILabel * lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(lblStandarPrice) + HEIGHT(lblStandarPrice), 150, 25)];
    
    NSString * strDiscountPrice = F(@"%ld", dealObj.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    lblDiscountPrice.text = strDiscountPrice;
    lblDiscountPrice.font = [UIFont boldSystemFontOfSize:20];
    lblDiscountPrice.textColor = [UIColor orangeColor];
     [lblDiscountPrice sizeToFit];
    [viewHeader addSubview:lblDiscountPrice];

    UIImageView * imvDown = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - PADDING*2 - 60, Y(lblStandarPrice)+5, 60, 35)];
    imvDown.image = [UIImage imageNamed:@"arrow-pointing-down"];
    [viewHeader addSubview:imvDown];
    
   UILabel *  lblDiscountPercent = [[UILabel alloc]initWithFrame:CGRectMake(X(imvDown) + 5, Y(imvDown)+2, WIDTH(imvDown)-5, 25)];
    
    lblDiscountPercent.numberOfLines = 1;
    lblDiscountPercent.text = @"60%";
    lblDiscountPercent.textAlignment = NSTextAlignmentCenter;
    lblDiscountPercent.font = [UIFont boldSystemFontOfSize:15];
    lblDiscountPercent.textColor = [UIColor whiteColor];//frame = (245 337; 55 25)
    [viewHeader addSubview:lblDiscountPercent];
    [viewHeader addSubview:lblDescription];

}

-(void)initUITableView
{
    tableViewDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66) style:UITableViewStylePlain];
    [self.view addSubview:tableViewDetail];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewDetail.backgroundColor = [UIColor whiteColor];
    tableViewDetail.dataSource = self;
    tableViewDetail.delegate = self;
    tableViewDetail.separatorColor = [UIColor clearColor];
    tableViewDetail.showsVerticalScrollIndicator = NO;
    tableViewDetail.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HEADER_HEIGHT + fHeightOfDescription + 15;
    }
    if (indexPath.section == 1) {
        return 44;
    }
//    if (indexPath.section == 2) {
//        return 120;
//    }
//    if (indexPath.section == 3) {
//        return 29;
//    }
    return 230;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:viewHeader];
        return cell;
    }
    if (indexPath.section == 1) {
        CheckQuantityDealCell *cell = (CheckQuantityDealCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckQuantityDealCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imgPic.image = [UIImage imageNamed:@"beef"];
        cell.vContainer.layer.borderWidth = 0.5;
        cell.vContainer.layer.borderColor =[UIColor lightGrayColor].CGColor;
        return cell;
    }
//    if (indexPath.section == 2) {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 5, 300, 20)];
//        lblTitle.text = @"Chọn danh mục";
//        lblTitle.font = [UIFont boldSystemFontOfSize:14];
//        lblTitle.textColor = [UIColor redColor];
//        [cell.contentView addSubview:lblTitle];
////        [cell.contentView addSubview:scrollViewCategory];
//        return cell;
//    }
//    if (indexPath.section == 3) {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        [cell.contentView addSubview:viewHeader];
//        
//        return cell;
//    }
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
