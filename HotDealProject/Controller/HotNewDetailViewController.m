//
//  HotNewDetailViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "HotNewDetailViewController.h"
#import "AppDelegate.h"
#import "AutoSizeTableViewCell.h"
#import "CheckQuantityDealCell.h"
#import "KindOfTransferDealCell.h"

#import "DealItem.h"
#import "ProductObject.h"
#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"
#import "WebViewController.h"
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
@interface HotNewDetailViewController ()
@property (nonatomic, strong) AutoSizeTableViewCell *prototypeCell;
@end

@implementation HotNewDetailViewController
{
    UIView * viewHeader;
    ImageSlide *imageSlideTop;
    UILabel * lblDescription;
    float fHeightOfDescription;
    UIScrollView * scrollView;
    int iSelectedItem;
    NSMutableArray * arrSelectedAldreay;
    BBBadgeBarButtonItem *barButton;
    NSMutableArray * arrProduct;
    MBProgressHUD *HUD;
    __block NSDictionary * dictDetail;
}
#define PADDING 10//HEADER_HEIGHT
#define HEADER_HEIGHT 370//HEADER_HEIGHT
@synthesize tableViewDetail;
@synthesize dealObj;
@synthesize arrDealRelateds;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    
    [self initHUD];
    [self initData];
    
    iSelectedItem = 0;
    
    //    [self setupRelatedDeal];
    //    [self setupViewHeader];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDealCount:) name:@"notiDealCount"
                                               object:nil];
    // Do any additional setup after loading the view.
}

-(void)initData
{
//        NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [NSNumber numberWithInt:_iProductID ], @"product_id",
//                                        nil];
    NSString * strParam = F(@"product_id=%@",[NSNumber numberWithInt:_iProductID ]);
    
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
//    category: {
//    category_id: 639,
//    category_name: ""
//    },
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
        [self setupLabelDescription];
        [self setupSlide];
        [self setupRelatedDeal];
        [self setupViewHeader];
        [self initUITableView];
        [self.view addSubview:[self setupBottomView]];
    }];
    
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

- (void)updateDealCount:(NSNotification *)notification {
    [self updateTotal];
}

-(void)setupLabelDescription
{
    lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT, ScreenWidth - 20, 0)];
    if (IS_IPHONE_6) {
        lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT + 55, ScreenWidth - 20, 0)];
    }
    if (IS_IPHONE_6_PLUS) {
        lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(0, HEADER_HEIGHT + 94, ScreenWidth - 20, 0)];
    }
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblDescription.numberOfLines = 0;
    lblDescription.text = F(@"\n%@\n",[dictDetail objectForKey:@"product"]);
    lblDescription.font = [UIFont systemFontOfSize:13];
    [lblDescription sizeToFit];
    CGRect rect = lblDescription.frame;
    fHeightOfDescription = rect.size.height;
}

-(void)shoppingCart
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    if ([arrProduct count] == 0) {
        return;
    }
    ShoppingCartController * shopping = [[ShoppingCartController alloc]init];
    shopping.delegate = self;
    [self.navigationController pushViewController:shopping animated:YES];
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    if (strTitle == nil || [strTitle isEqualToString:@""]) {
        strTitle = @"CHI TIẾT";
    }
    [appdelegate initNavigationbar:self withTitle:strTitle];
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    // Set a value for the badge
    
    barButton.badgeOriginX = 25;
    barButton.badgeOriginY = -5;
    
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        iBadge += item.iCurrentQuantity;
    }
    barButton.badgeValue = F(@"%d",iBadge);
    
    //    barButton.badgeValue = F(@"%ld",[arrProduct count]);
    self.navigationItem.rightBarButtonItem = barButton;
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
    NSArray * arrImage = [dictDetail objectForKey:@"images"];
    NSMutableArray * galleryImages = [NSMutableArray arrayWithArray:arrImage];
    imageSlideTop.galleryImages = galleryImages;
    imageSlideTop.delegate = self;
    [imageSlideTop initScrollLocal2];
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
    if (IS_IPHONE_6) {
        realHeight += 45;
    }
    if (IS_IPHONE_6_PLUS) {
        realHeight += 94;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(PADDING, PADDING, ScreenWidth - PADDING*2, realHeight)];
    UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(viewHeader), 40)];
    lblTitle.numberOfLines = 2;
    lblTitle.text = [dictDetail objectForKey:@"title"];
    lblTitle.font = [UIFont boldSystemFontOfSize:15];
    lblTitle.textColor = [UIColor orangeColor];
    [viewHeader addSubview:lblTitle];
    
    [viewHeader addSubview:imageSlideTop];
    
    UILabel * lblStandarPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(imageSlideTop) + HEIGHT(imageSlideTop), 150, 18)];
    lblStandarPrice.font = [UIFont systemFontOfSize:14];
    lblStandarPrice.textColor = [UIColor blackColor];
    int price = [[dictDetail objectForKey:@"list_price"]intValue];
    NSString * strStardarPrice = F(@"%d", price);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    lblStandarPrice.attributedText = attributedString;
    [lblStandarPrice sizeToFit];
    [viewHeader addSubview:lblStandarPrice];
    
    UILabel * lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(lblStandarPrice) + HEIGHT(lblStandarPrice), 150, 25)];
    
    int list_price = [[dictDetail objectForKey:@"price"]intValue];
    NSString * strDiscountPrice = F(@"%d",  list_price);
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
    float calculatePercent = (float)((float)list_price/(float)price) *100;
    lblDiscountPercent.text = F(@"%.0f%%", calculatePercent);
    lblDiscountPercent.textAlignment = NSTextAlignmentCenter;
    lblDiscountPercent.font = [UIFont boldSystemFontOfSize:15];
    lblDiscountPercent.textColor = [UIColor whiteColor];//frame = (245 337; 55 25)
    [viewHeader addSubview:lblDiscountPercent];
    [viewHeader addSubview:lblDescription];
    
}

-(void)initUITableView
{
    tableViewDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66 - 40) style:UITableViewStylePlain];
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
    return  5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (IS_IPHONE_6) {
            return HEADER_HEIGHT + fHeightOfDescription + 65;
        }
        if (IS_IPHONE_6_PLUS) {
            return HEADER_HEIGHT + fHeightOfDescription + 104;
        }
        return HEADER_HEIGHT + fHeightOfDescription + 15;
    }
    if (indexPath.section == 1) {
        return 44+10;
    }
    if (indexPath.section == 2) {
        return 88;
    }
    if (indexPath.section == 4) {
        return 350;
    }
    if (indexPath.section == 3) {
        if (IS_IOS8_OR_ABOVE) {
            return UITableViewAutomaticDimension;
        }
        
        // (7)
        //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
        
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        
        // (8)
        [self.prototypeCell updateConstraintsIfNeeded];
        [self.prototypeCell layoutIfNeeded];
        
        // (9)
        return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return 350;
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

        UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth -20, 45)];
        [cell.contentView insertSubview:viewBG atIndex:0];
        viewBG.layer.borderWidth = 0.5;
        viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
        NSArray * arrProducts = [dictDetail objectForKey:@"child_products"];
        if ([arrProducts count] == 0) {
            iSelectedItem = 1;
            cell.lblNumofVoucher.text = @"1 voucher";
        }
        else
        {
        if (dealObj.iType == 0) {
            if (iSelectedItem == 0) {
                cell.lblNumofVoucher.text = @"Chọn số lượng";
            }
            else
            {
                cell.lblNumofVoucher.text = F(@"%d sản phẩm",iSelectedItem);
            }
        }
        else
        {
            if (iSelectedItem == 0) {
                cell.lblNumofVoucher.text = @"Chọn số lượng";
            }
            else
            {
                cell.lblNumofVoucher.text = F(@"%d voucher",iSelectedItem);
            }
            
        }
        }
        return cell;
    }
    if (indexPath.section == 2) {
        KindOfTransferDealCell *cell = (KindOfTransferDealCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KindOfTransferDealCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTotal.text = F(@"%d",[[dictDetail objectForKey:@"buy_number"]intValue]);
        
        return cell;
    }
    if (indexPath.section == 3) {
        AutoSizeTableViewCell *cell = (AutoSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AutoSizeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
    if (indexPath.section == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 15, ScreenWidth -20, 20)];
        
        lblTitle.text = @"Sản phẩm liên quan";
        lblTitle.font = [UIFont boldSystemFontOfSize:14];
        lblTitle.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lblTitle];
        [cell.contentView addSubview:scrollView];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)configureCell:(AutoSizeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.titleLabel.text = @"Địa chỉ sử dụng";
    //    cell.desLabel.text = @"Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng Địa chỉ sử dụng";
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"Điểm nổi bật";
        cell.desLabel.text = @"Điểm nổi bật Điểm nổi bật Điểm nổi bật Điểm nổi bật Điểm nổi bật Điểm nổi bật\n\n";
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"Lưu ý khi mua";
        cell.desLabel.text = @"Lưu ý khi mua Lưu ý khi mua Lưu ý khi mua\n\n";
    }
    
    if (indexPath.row == 2) {
        cell.titleLabel.text = @"Địa chỉ sử dụng";
        cell.desLabel.text = @"Địa chỉ sử dụng \n\n";
    }
    if (indexPath.row == 3) {
        cell.titleLabel.text = @"Chi tiết khuyến mãi";
        cell.desLabel.text = @"\n";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 0)];
    lblTemp.lineBreakMode = NSLineBreakByWordWrapping;
    lblTemp.numberOfLines = 0;
    lblTemp.text = cell.desLabel.text;
    if ([cell.desLabel.text isEqualToString:@""]) {
        lblTemp.text = @"\n";
    }
    lblTemp.font = [UIFont systemFontOfSize:12];
    [lblTemp sizeToFit];
    CGRect rect = lblTemp.frame;
    //    fHeightOfDescription = rect.size.height;
    
    //    UA_log(@"height desLabel : %f", rect.size.height );
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth -20, rect.size.height + 15)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
}

-(UIScrollView *)setupRelatedDeal
{
    if (scrollView != nil) {
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(PADDING, 40, ScreenWidth, 180)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    //    [scrollView setBounces:NO];
    
    int x = 0;
    for (int i = 0; i < [arrDealRelateds count]; i++) {
        DealItem *itemS = [[[NSBundle mainBundle] loadNibNamed:@"DealItem" owner:self options:nil] objectAtIndex:0];
        [itemS setFrame:CGRectMake(x, 0, 250, 180)];
        [itemS.btnTemp addTarget:self action:@selector(clickOnItem:) forControlEvents:UIControlEventTouchUpInside];
        itemS.btnTemp.tag = i;
        //        itemS.backgroundColor = [UIColor greenColor];
        
        DealObject * item = [arrDealRelateds objectAtIndex:i];
        NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
        strStardarPrice = [strStardarPrice formatStringToDecimal];
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
        itemS.lblStandarPrice.attributedText = attributedString;
        [itemS.lblStandarPrice sizeToFit];
        itemS.lblNumOfBook.text = F(@"%d",item.buy_number);
        
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        itemS.lblDiscountPrice.text = strDiscountPrice;
        itemS.lblTitle.text = item.strTitle;
        
        if (item.isNew == FALSE) {
            itemS.lblNew.hidden = YES;
        }
        if (item.iType == 1) {
            itemS.lblEVoucher.hidden = YES;
        }
        
        
        x += itemS.frame.size.width + PADDING;
        [scrollView addSubview:itemS];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    return scrollView;
}
-(void)clickOnItem:(id)sender
{
    UIButton * btnTag = (UIButton *)sender;
    UA_log(@"button is at %ld index", (long)btnTag.tag);
    HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
    DealObject * dealObjs = [arrDealRelateds objectAtIndex:(long)btnTag.tag];
    detail.dealObj = dealObjs;
    detail.arrDealRelateds = arrDealRelateds;
    [self.navigationController pushViewController:detail animated:YES];
}

-(UIView *)setupBottomView
{
    UIView * viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 114, ScreenWidth, 50)];
    viewBottom.backgroundColor = [UIColor darkGrayColor];
    UIButton * btnOne = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnOne setFrame:CGRectMake(PADDING, 8, ScreenWidth/2 - PADDING*2, 35)];
    btnOne.backgroundColor = [UIColor whiteColor];
    [btnOne setTitle:@"CHO VÀO GIỎ HÀNG" forState:UIControlStateNormal];
    [btnOne.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnOne setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btnOne addTarget:self action:@selector(addProductToCart) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnOne];
    
    UIButton * btnTwo = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnTwo setFrame:CGRectMake(PADDING*2 + WIDTH(btnOne), 8, ScreenWidth/2 - PADDING, 35)];
    btnTwo.backgroundColor = [UIColor greenColor];
    [btnTwo setTitle:@"MUA NGAY" forState:UIControlStateNormal];
    [btnTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTwo.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnTwo addTarget:self action:@selector(openCart) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnTwo];
    return viewBottom;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ProductListViewController * pList = [[ProductListViewController alloc]init];
        pList.arrProduct = arrSelectedAldreay;
        pList.dictDealDetail = dictDetail;
        pList.delegate = self;
        [self.navigationController pushViewController:pList animated:YES];
        return;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            WebViewController * web = [[WebViewController alloc]init];
            web.sTitle = LS(@"feature");
            web.strContent = [dictDetail objectForKey:@"feature"];
            [self.navigationController pushViewController:web animated:YES];
            
        }
        if (indexPath.row == 1) {
            WebViewController * web = [[WebViewController alloc]init];
            web.sTitle = LS(@"condition");
            web.strContent = [dictDetail objectForKey:@"condition"];
            [self.navigationController pushViewController:web animated:YES];
            
        }
        if (indexPath.row == 2) {
            WebViewController * web = [[WebViewController alloc]init];
            web.sTitle = LS(@"location");
            web.strContent = [dictDetail objectForKey:@"location"];
            [self.navigationController pushViewController:web animated:YES];
            
        }
        if (indexPath.row == 3) {
            WebViewController * web = [[WebViewController alloc]init];
            web.sTitle = LS(@"detail");
            web.strContent = [dictDetail objectForKey:@"detail"];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
    
}
-(void)updateTotalSeletedItem:(NSMutableArray *)arrTotalItem
{
    //Add product to database
    int iTotal = 0;
    for (ProductObject * item in arrTotalItem) {
        iTotal += item.iCurrentQuantity;
        UA_log(@"%d", iTotal);
    }
    arrSelectedAldreay = [NSMutableArray arrayWithArray:arrTotalItem];
    iSelectedItem = iTotal;
    [tableViewDetail reloadData];
    [self updateTotal];
    
    
}
-(void)updateTotal
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        int iCurrent = item.iCurrentQuantity;
        iBadge += iCurrent;
    }
    barButton.badgeValue = F(@"%d",iBadge);
}
-(void)addProductToCart
{
    if (iSelectedItem == 0) {
        ALERT(@"Thông báo!", @"Vui lòng chọn số lượng");
        return;
    }
    
    ProductObject * item = [[ProductObject alloc]init];
    item.strProductID = F(@"%@",[dictDetail objectForKey:@"product_id"]);
    item.strTitle = [dictDetail objectForKey:@"title"];
    item.iCurrentQuantity = 1;
    item.iMaxQuantity = 5;
    item.lDiscountPrice = [[dictDetail objectForKey:@"price"]intValue];
    item.lStandarPrice = [[dictDetail objectForKey:@"list_price"]intValue];
    [arrProduct addObject:item];
    [[TKDatabase sharedInstance]addProduct:item];
    [self updateTotal];
    
//    User * user
//        NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [NSNumber numberWithInt:_iProductID ], @"product_id",
//                                        
//                                        nil];
//    NSString * strParam = F(@"product_id=%@",[NSNumber numberWithInt:_iProductID ]);
    
//    [HUD show:YES];
//    [[TKAPI sharedInstance]postRequestAF:strParam withURL:URL_ADD_TO_CART completion:^(NSDictionary * dict, NSError *error) {
//    }];
}
-(void)openCart
{
    if (iSelectedItem == 0) {
        ALERT(@"Thông báo!", @"Vui lòng chọn số lượng");
        return;
    }
    ProductObject * item = [[ProductObject alloc]init];
    item.strProductID = F(@"%@",[dictDetail objectForKey:@"product_id"]);
    item.strTitle = [dictDetail objectForKey:@"title"];
    item.iCurrentQuantity = 1;
    item.iMaxQuantity = 5;
    item.lDiscountPrice = [[dictDetail objectForKey:@"price"]intValue];
    item.lStandarPrice = [[dictDetail objectForKey:@"list_price"]intValue];
    [arrProduct addObject:item];
    [[TKDatabase sharedInstance]addProduct:item];
    [self updateTotal];

    ShoppingCartController * cart = [[ShoppingCartController alloc]init];
    [self.navigationController pushViewController:cart animated:YES];
}
@end
