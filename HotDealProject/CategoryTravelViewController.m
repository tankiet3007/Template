//
//  CategoryTravelViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/10/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CategoryTravelViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "SWRevealViewController.h"
#import "DealCell.h"
#import "SupplierCell.h"
#import "CustomCollectionItem.h"
#import "MenuObject.h"
#import "CategoryCell.h"
#define CellHeight1 50
@interface CategoryTravelViewController ()

@end

@implementation CategoryTravelViewController
{
    UIButton * btnTitle;
    UIButton * lastBtnMenu;
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UISegmentedControl *segmentedControl;
    
    UILabel * lblNumOfVoucher;
    SWRevealViewController *revealController;
    UITableView * tableViewSubCategory1;
    UITableView * tableViewSubCategory2;
    UITableView * tableViewSubCategory3;
    
    NSArray * arrSort;
    BOOL isShowSortMenu;
    int iState;
    MBProgressHUD *HUD;
    UIView * viewCT;
    BOOL bForceStop;
    UIButton * btnKind;
    UIButton * btnConvenient;
    UIButton * btnPrice;
    UIButton * btnFilter;
    
    UIView * viewMenu;
    UIView * viewPrice;
    UIView* dimView;
    
    BOOL isShowSortMenu2;
    int iMenuRow1;
    int iMenuRow3;
    NSMutableArray * arrMenu1;
    NSMutableArray * arrMenu1_1;
    NSMutableArray * arrMenu3;
    NSMutableArray * arrMenu2;
    
    NSIndexPath * lastIndexPathMenu1;
    NSIndexPath * lastIndexPathMenu1_2;
    NSIndexPath * lastIndexPathMenu1_3;
    NSIndexPath * lastIndexPathMenu2;
    NSIndexPath * lastIndexPathMenu3;
    BOOL isShowSortMenu3;
    BOOL isShowPriceMenu;
    int iIndexMenu;
    
    TTRangeSlider * tRangeSlider;
}
#define RowHeight 44
#define CollectionItemHeight1 50
#define CollectionItemHeight2 33
@synthesize tableviewCategory;
@synthesize strTitle;
@synthesize strCateId;
@synthesize cateItem;
@synthesize collectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initDataMenu];
    iIndexMenu = -1;
    lastIndexPathMenu1 = [NSIndexPath indexPathForRow:0 inSection:0];
    lastIndexPathMenu2 = [NSIndexPath indexPathForRow:0 inSection:0];
    lastIndexPathMenu3 = [NSIndexPath indexPathForRow:0 inSection:0];
    bForceStop = FALSE;
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"indexSelected"];
    if (savedValue != nil) {
        iState = [savedValue intValue];
    }
    if (iState == 1) {
        iState = 437;
    }
    else
        iState = 440;
    [self initNavigationbar];
    [self initMenu];
    [self initHUD];
    isShowSortMenu = NO;
    
    isShowSortMenu3 = YES;
    isShowPriceMenu = YES;
    arrDeals = [[NSMutableArray alloc]init];
    [self initData2:10 wOffset:1 wType:@"default"];
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)initData2:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strCateId, @"category",
                                    F(@"%d", iState), @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    nil];
    
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_SEARCH_DEAL completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        for (NSDictionary * dictItem in arrProducts) {
            DealObject * item = [[DealObject alloc]init];
            item.strTitle = [dictItem objectForKey:@"title"];
            item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDeals addObject:item];
        }
        UA_log(@"%lu item", [arrDeals count]);
        //        [tableViewSearch reloadData];
        [self initUITableView];
    }];
    
}


-(void)showCategory
{
    if(isShowSortMenu == NO)
    {
        isShowSortMenu = YES;
        [self setDimView:NO];
        [self initMainCategory];
    }
    else
    {
        isShowSortMenu = NO;
        [self dissmissProductview];
    }
}
- (void)hiddenView:(id)sender {
    
    [UIView animateWithDuration:.2 animations:^{
        
    } completion:^(BOOL finished) {
        [self dissmissProductview];
        [self dissmissMenu];
        dimView.alpha = 0;
        isShowSortMenu = NO;
        isShowSortMenu2 = NO;
    }];
}

-(void)dissmissProductview
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewCT.frame = CGRectMake(0, -220, ScreenWidth, -220);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [viewCT removeFromSuperview];
                         dimView.alpha = 0;
                     }];
}

-(void)initMainCategory
{
    
    viewCT = [[UIView alloc]initWithFrame:CGRectMake(0, -220, ScreenWidth, 220)];
    [viewCT setBackgroundColor:[UIColor whiteColor]];
    int x = 40;
    int y = 20;
    int size = 52;
    int midPadding = (ScreenWidth - size *3 - x*2)/2;
    viewCT.frame = CGRectMake(0, -220, ScreenWidth, 220);
    
    UIButton * btnCategory = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory setFrame:CGRectMake(x, y, size, size)];
    btnCategory.tag = 110;
    [btnCategory setBackgroundImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
    [btnCategory addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory.layer.borderWidth=1.0f;
    btnCategory.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory];
    
    UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(x, y+size, size, 30)];
    lblName.font = [UIFont boldSystemFontOfSize:10];
    lblName.text = @"ĂN UỐNG";
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.userInteractionEnabled = NO;
    lblName.backgroundColor = [UIColor clearColor];
    lblName.numberOfLines = 2;
    [viewCT addSubview:lblName];
    
    UIButton * btnCategory2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory2 setFrame:CGRectMake(x+size+midPadding, y, size, size)];
    btnCategory2.tag = 111;
    [btnCategory2 setBackgroundImage:[UIImage imageNamed:@"spa"] forState:UIControlStateNormal];
    [btnCategory2 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory2.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory2.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory2.layer.borderWidth=1.0f;
    btnCategory2.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory2];
    
    UILabel * lblName2 = [[UILabel alloc]initWithFrame:CGRectMake(x+size+midPadding,y+ size, size, 30)];
    lblName2.font = [UIFont boldSystemFontOfSize:10	];
    lblName2.text = @"SPA\nLÀM ĐẸP";
    lblName2.textAlignment = NSTextAlignmentCenter;
    lblName2.userInteractionEnabled = NO;
    lblName2.backgroundColor = [UIColor clearColor];
    lblName2.numberOfLines = 2;
    [viewCT addSubview:lblName2];
    UIButton * btnCategory3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory3 setFrame:CGRectMake(x+size*2+midPadding*2, y, size, size)];
    btnCategory3.tag = 112;
    [btnCategory3 setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    [btnCategory3 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory3.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory3.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory3.layer.borderWidth=1.0f;
    btnCategory3.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory3];
    
    UILabel * lblName3 = [[UILabel alloc]initWithFrame:CGRectMake(x+size*2+midPadding*2, y+size, size, 30)];
    lblName3.font = [UIFont boldSystemFontOfSize:10	];
    lblName3.text = @"ĐÀO TẠO GIẢI TRÍ";
    lblName3.textAlignment = NSTextAlignmentCenter;
    lblName3.userInteractionEnabled = NO;
    lblName3.backgroundColor = [UIColor clearColor];
    lblName3.numberOfLines = 2;
    [viewCT addSubview:lblName3];
    
    UIButton * btnCategory4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory4 setFrame:CGRectMake(x, y + size + 40, size, size)];
    btnCategory4.tag = 113;
    [btnCategory4 setBackgroundImage:[UIImage imageNamed:@"sanpham"] forState:UIControlStateNormal];
    [btnCategory4 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory4.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory4.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory4.layer.borderWidth=1.0f;
    btnCategory4.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory4];
    
    UILabel * lblName4 = [[UILabel alloc]initWithFrame:CGRectMake(x, y + size*2 + 40, size, 30)];
    lblName4.font = [UIFont boldSystemFontOfSize:10	];
    lblName4.text = @"SẢN PHẨM";
    lblName4.textAlignment = NSTextAlignmentCenter;
    lblName4.userInteractionEnabled = NO;
    lblName4.backgroundColor = [UIColor clearColor];
    lblName4.numberOfLines = 2;
    [viewCT addSubview:lblName4];
    
    UIButton * btnCategory5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory5 setFrame:CGRectMake(x+size+midPadding, y + size + 40, size, size)];
    btnCategory5.tag = 114;
    [btnCategory5 setBackgroundImage:[UIImage imageNamed:@"fashion"] forState:UIControlStateNormal];
    [btnCategory5 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory5.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory5.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory5.layer.borderWidth=1.0f;
    btnCategory5.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory5];
    
    UILabel * lblName5 = [[UILabel alloc]initWithFrame:CGRectMake(x+size+midPadding, y + size*2 + 40, size, 30)];
    lblName5.font = [UIFont boldSystemFontOfSize:10	];
    lblName5.text = @"THỜI TRANG";
    lblName5.textAlignment = NSTextAlignmentCenter;
    lblName5.userInteractionEnabled = NO;
    lblName5.backgroundColor = [UIColor clearColor];
    lblName5.numberOfLines = 2;
    [viewCT addSubview:lblName5];
    UIButton * btnCategory6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory6 setFrame:CGRectMake(x+size*2+midPadding*2, y + size + 40, size, size)];
    btnCategory6.tag = 115;
    [btnCategory6 setBackgroundImage:[UIImage imageNamed:@"tralvel"] forState:UIControlStateNormal];
    [btnCategory6 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory6.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory6.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory6.layer.borderWidth=1.0f;
    btnCategory6.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory6];
    
    UILabel * lblName6 = [[UILabel alloc]initWithFrame:CGRectMake(x+size*2+midPadding*2, y + size*2 + 40, size, 30)];
    lblName6.font = [UIFont boldSystemFontOfSize:10	];
    lblName6.text = @"DU LỊCH";
    lblName6.textAlignment = NSTextAlignmentCenter;
    lblName6.userInteractionEnabled = NO;
    lblName6.backgroundColor = [UIColor clearColor];
    lblName6.numberOfLines = 2;
    [viewCT addSubview:lblName6];
    
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewCT.frame = CGRectMake(0, 0, ScreenWidth, 220);
                     }
                     completion:^(BOOL finished){
                     }];
    //    [self.view addSubview:self.postStatusView];
    [self.view addSubview:viewCT];
}

-(void)initNavigationbar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    btnTitle = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTitle.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTitle setTitle:cateItem.strTitle forState:UIControlStateNormal];
    [btnTitle addTarget:self action:@selector(showCategory) forControlEvents:UIControlEventTouchUpInside];
    [btnTitle sizeToFit];
    self.navigationItem.titleView = btnTitle;
    
    
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark inittableView
-(void)initUITableView
{
    tableviewCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableviewCategory];
    
    tableviewCategory.backgroundColor = [UIColor whiteColor];
    tableviewCategory.dataSource = self;
    tableviewCategory.delegate = self;
    [tableviewCategory setAllowsSelection:YES];
    tableviewCategory.separatorColor = [UIColor clearColor];
    tableviewCategory.showsVerticalScrollIndicator = NO;
    tableviewCategory.sectionHeaderHeight = 0.0;
}

-(void)initTableViewForSort
{
    if (tableViewSubCategory1 != nil) {
        [tableViewSubCategory1 removeFromSuperview];
        tableViewSubCategory1 = nil;
    }
    if (collectionView!= nil) {
        [collectionView removeFromSuperview];
        collectionView = nil;
    }
    if (viewPrice != nil) {
        [viewPrice removeFromSuperview];
        viewPrice = nil;
    }
    //    [self dissmissMenu];
    //    [self setDimView:YES];
    tableViewSubCategory1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 110, [arrMenu1 count] *CellHeight1)];
    tableViewSubCategory1.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:0.3];
    [self.view addSubview:tableViewSubCategory1];
    tableViewSubCategory1.layer.shadowOpacity = 1;
    tableViewSubCategory1.layer.shadowRadius = 1.0;
    tableViewSubCategory1.clipsToBounds = YES;
    tableViewSubCategory1.backgroundColor = [UIColor whiteColor];
    tableViewSubCategory1.dataSource = self;
    tableViewSubCategory1.delegate = self;
    [tableViewSubCategory1 setAllowsSelection:YES];
    tableViewSubCategory1.separatorColor = [UIColor clearColor];
    tableViewSubCategory1.showsVerticalScrollIndicator = NO;
    tableViewSubCategory1.sectionHeaderHeight = 0.0;
    [btnKind setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
}

-(void)initTableViewSub2
{
    if (tableViewSubCategory2 != nil) {
        [tableViewSubCategory2 removeFromSuperview];
        tableViewSubCategory2 = nil;
    }
    tableViewSubCategory2 = [[UITableView alloc]initWithFrame:CGRectMake(110, 50, 110, [arrMenu1 count] *CellHeight1)];
    tableViewSubCategory2.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:0.3];
    [self.view addSubview:tableViewSubCategory2];
    tableViewSubCategory2.layer.shadowOpacity = 1;
    tableViewSubCategory2.layer.shadowRadius = 1.0;
    tableViewSubCategory2.clipsToBounds = YES;
    tableViewSubCategory2.backgroundColor = [UIColor whiteColor];
    tableViewSubCategory2.dataSource = self;
    tableViewSubCategory2.delegate = self;
    [tableViewSubCategory2 setAllowsSelection:YES];
    tableViewSubCategory2.separatorColor = [UIColor clearColor];
    tableViewSubCategory2.showsVerticalScrollIndicator = NO;
    tableViewSubCategory2.sectionHeaderHeight = 0.0;
}

-(void)initTableViewSub3
{
    if (tableViewSubCategory3 != nil) {
        [tableViewSubCategory3 removeFromSuperview];
        tableViewSubCategory3 = nil;
    }
    tableViewSubCategory3 = [[UITableView alloc]initWithFrame:CGRectMake(220, 50, 110, [arrMenu1 count] *CellHeight1)];
    tableViewSubCategory3.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:0.3];
    [self.view addSubview:tableViewSubCategory3];
    tableViewSubCategory3.layer.shadowOpacity = 1;
    tableViewSubCategory3.layer.shadowRadius = 1.0;
    tableViewSubCategory3.clipsToBounds = YES;
    tableViewSubCategory3.backgroundColor = [UIColor whiteColor];
    tableViewSubCategory3.dataSource = self;
    tableViewSubCategory3.delegate = self;
    [tableViewSubCategory3 setAllowsSelection:YES];
    tableViewSubCategory3.separatorColor = [UIColor clearColor];
    tableViewSubCategory3.showsVerticalScrollIndicator = NO;
    tableViewSubCategory3.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableviewCategory]) {
        return [arrDeals count];
    }
    else
        return [arrMenu1 count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![tableView isEqual:tableviewCategory]) {
        return CellHeight1;
    }
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewSubCategory1]) {
        static NSString *simpleTableIdentifier = @"CategoryCell";
        
        CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnName.titleLabel.numberOfLines = 2;
        cell.btnName.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.btnName addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
        MenuObject * item  = [MenuObject new];
        item = [arrMenu1 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu1]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
        [cell.btnName setTitle:item.strName forState:UIControlStateNormal];
        cell.btnName.tag = indexPath.row;
        
        
        return cell;
    }
    if ([tableView isEqual:tableViewSubCategory2]) {
        static NSString *simpleTableIdentifier = @"CategoryCell";
        
        CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnName.titleLabel.numberOfLines = 2;
        cell.btnName.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.btnName addTarget:self action:@selector(buttonClicked3:) forControlEvents:UIControlEventTouchUpInside];
        MenuObject * item  = [MenuObject new];
        item = [arrMenu1 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu1_2]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
        [cell.btnName setTitle:item.strName forState:UIControlStateNormal];
        cell.btnName.tag = indexPath.row;
        
        
        return cell;
    }
    if ([tableView isEqual:tableViewSubCategory3]) {
        static NSString *simpleTableIdentifier = @"CategoryCell";
        
        CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnName.titleLabel.numberOfLines = 2;
        cell.btnName.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.btnName addTarget:self action:@selector(buttonClicked4:) forControlEvents:UIControlEventTouchUpInside];
        MenuObject * item  = [MenuObject new];
        item = [arrMenu1 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu1_3]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
        [cell.btnName setTitle:item.strName forState:UIControlStateNormal];
        cell.btnName.tag = indexPath.row;
        
        
        return cell;
    }
    if ([tableView isEqual:tableviewCategory])
    {
        static NSString *simpleTableIdentifier = @"SupplierCell";
        
        SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(12, 98, ScreenWidth -20, 1)];
        line.tag = 101;
        line.backgroundColor = [UIColor darkGrayColor];
        [cell addSubview:line];
        
        
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        
        DealObject * item = [arrDeals objectAtIndex:indexPath.row];
        cell.lblTitle.text = item.strTitle;
        UIView *backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
        backgroundView.layer.borderColor = [[UIColor clearColor]CGColor];
        backgroundView.layer.borderWidth = 10.0f;
        cell.selectedBackgroundView = backgroundView;
        cell.backgroundColor = [UIColor clearColor];
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentsPath = [documentsPath stringByAppendingPathComponent:@"PublicFolder"];
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
        
        DLStarRatingControl *starRating = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(80, 37, 120, 26)];
        starRating.backgroundColor = [UIColor clearColor];
        //        cell.starRating.rating =  item.iRate ;
        starRating.rating = 3.5;
        starRating.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        starRating.isFractionalRatingEnabled = YES;
        starRating.userInteractionEnabled = NO;
        [cell.contentView addSubview:starRating];
        
        NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
        strStardarPrice = [strStardarPrice formatStringToDecimal];
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
        [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                           , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strStardarPrice length], 1)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.lblStandarPrice.attributedText = attributedString2;
        [cell.lblStandarPrice sizeToFit];
        cell.lblNumOfBook.text = F(@"%d",item.buy_number);
        //        cell.lblNumOfBook.text = F(@"%d",23595);
        
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        //        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strDiscountPrice) attributes:nil];
        [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                           , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strDiscountPrice length], 1)];
        
        cell.lblDiscountPrice.attributedText = attributedString2;
        cell.lblTitle.text = item.strTitle;
        if (bForceStop == TRUE) {
            return cell;
        }
        if (indexPath.row == [arrDeals count] - 1)
        {
            [self loadMoreDeal];
        }
        return cell;
    }
    return nil;
}
-(void)loadMoreDeal
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    @437, @"city",
                                    [NSNumber numberWithInteger:10], @"fetch_count",
                                    [NSNumber numberWithLong:[arrDeals count]], @"offset",
                                    @"default",@"fetch_type",
                                    nil];
    HUD.labelText = @"Tải thêm deal";
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_DEAL_LIST completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        if ([arrProducts count] == 0) {
            bForceStop = YES;
            return;
        }
        
        for (NSDictionary * dictItem in arrProducts) {
            DealObject * item = [[DealObject alloc]init];
            item.strTitle = [dictItem objectForKey:@"title"];
            item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDeals addObject:item];
        }
        
        [tableviewCategory reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableviewCategory]) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        DetailViewController * detail = [[DetailViewController alloc]init];
        DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
        detail.iProductID = dealObj.product_id;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    else
    {
        if ([tableView isEqual:tableViewSubCategory1]) {
            if (indexPath.row == 0) {
                [self dissmissMenu];
                return;
            }//get data ->
            [self initTableViewSub2];
            
            lastIndexPathMenu1_2 = nil;
            lastIndexPathMenu1_3 = nil;
            
            CategoryCell * cell = (CategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
            lastIndexPathMenu1 = indexPath;
            isShowSortMenu2 = NO;
            [tableView reloadData];
        }
        if ([tableView isEqual:tableViewSubCategory2]) {
            CategoryCell * cell = (CategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            [self initTableViewSub3];
            
            lastIndexPathMenu1_3 = nil;
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
            lastIndexPathMenu1_2 = indexPath;
            isShowSortMenu2 = NO;
            [tableView reloadData];
        }
        if ([tableView isEqual:tableViewSubCategory3]) {
            CategoryCell * cell = (CategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
            lastIndexPathMenu1_3 = indexPath;
            isShowSortMenu2 = NO;
            [self dissmissMenu];
            [btnKind setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
        }
    }
}
-(void)showFilterMenu
{
    isShowSortMenu3 = !isShowSortMenu3;
    if (isShowSortMenu3  == YES) {
        [self dissmissMenu];
    }
}
-(void)showPriceMenu
{
    isShowPriceMenu = !isShowPriceMenu;
    if (isShowPriceMenu  == YES) {
        [self dissmissMenu];
    }
}
-(void)setDimView:(BOOL)isMenu
{
    if (dimView != nil) {
        [dimView removeFromSuperview];
        dimView = nil;
    }
    if (isMenu == NO) {
        dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    else
    {
        dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight)];
        
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    tapGesture.numberOfTapsRequired = 1;
    [dimView addGestureRecognizer:tapGesture];
    
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0;
    [self.view addSubview:dimView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         dimView.alpha = 0.6;
                     }];
}
-(void)clickOnCategory:(UIButton *)sender
{
    isShowSortMenu = NO;
    [self dissmissProductview];
    switch (sender.tag) {
        case 110:
        {
            [btnTitle setTitle:@"ĂN UỐNG" forState:UIControlStateNormal];
            break;
        }
        case 111:
        {
            [btnTitle setTitle:@"SPA LÀM ĐẸP" forState:UIControlStateNormal];
            break;
        }
        case 112:
        {
            [btnTitle setTitle:@"ĐÀO TẠO GIẢI TRÍ" forState:UIControlStateNormal];
            break;
        }
        case 113:
        {
            [btnTitle setTitle:@"SẢN PHẨM" forState:UIControlStateNormal];
            break;
        }
        case 114:
        {
            [btnTitle setTitle:@"THỜI TRANG" forState:UIControlStateNormal];
            break;
        }
        case 115:
        {
            [btnTitle setTitle:@"DU LỊCH" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [btnTitle sizeToFit];
}
#pragma mark Menu -----
-(void)kindSelect:(UIButton *)sender
{
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConvenient setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    is_segment1 = TRUE;
    iIndexMenu = 1;
    
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self setDimView:YES];
        [self initTableViewForSort];
        if (lastIndexPathMenu1_3 != nil) {
            [self initTableViewSub2];
            [self initTableViewSub3];
        }
        [self showFilterMenu];
        
        lastBtnMenu = sender;
    }
    else
    {
        isShowSortMenu2 = YES;
        
        [self initTableViewForSort];
        lastBtnMenu = sender;
    }
}
-(void)convenientSelect:(UIButton *)sender
{
    iIndexMenu = 2;
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setDimView:YES];
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self showMenu];
        lastBtnMenu = sender;
    }
    else
    {
        [self callbackMenu];
        lastBtnMenu = sender;
    }
    
}
-(void)priceSelect:(UIButton *)sender
{
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConvenient setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    is_segment1 = TRUE;
    iIndexMenu = 1;
    
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self setDimView:YES];
        [self initPriceView];
        [self showPriceMenu];
        
        lastBtnMenu = sender;
    }
    else
    {
        isShowSortMenu2 = YES;
        [self initPriceView];
        lastBtnMenu = sender;
    }
}
-(void)filterSelect:(UIButton *)sender
{
    iIndexMenu = 4;
    //        is_segment1 = TRUE;
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConvenient setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setDimView:YES];
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self showMenu];
        lastBtnMenu = sender;
    }
    else
    {
        [self callbackMenu];
        lastBtnMenu = sender;
    }
}
-(void)callbackMenu
{
    [self removeAllMenu];
    isShowSortMenu2 = YES;
    [self setDimView:YES];
    if (iIndexMenu == 2) {
        [self initCollectionWithNumOfItem:[arrMenu2 count]];
    }
    if (iIndexMenu == 4) {
        [self initCollectionWithNumOfItem:[arrMenu3 count]];
    }
}

-(void)initPriceView
{
    if (viewPrice != nil) {
        [viewPrice removeFromSuperview];
        viewPrice = nil;
    }
    viewPrice = [[UIView alloc]initWithFrame:CGRectMake(0, 41, ScreenWidth, 180)];
    viewPrice.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewPrice];
    
    UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100, 10, 200, 25)];
    lblTitle.text = @"Chọn giá muốn hiển thị (x1000)";
    lblTitle.font = [UIFont systemFontOfSize:12];
    lblTitle.textColor = [UIColor darkGrayColor];
    [viewPrice addSubview:lblTitle];
    
    
    tRangeSlider = [[TTRangeSlider alloc]initWithFrame:CGRectMake(9, 50, ScreenWidth - 18, 65)];
    tRangeSlider.delegate = self;
    tRangeSlider.minValue = 0;
    tRangeSlider.maxValue = 6;
    tRangeSlider.enableStep = YES;
    tRangeSlider.step = 1;
    tRangeSlider.selectedMinimum = 1;
    tRangeSlider.selectedMaximum = 4;
    [viewPrice addSubview:tRangeSlider];
    
    double range = (ScreenWidth - 20)/6;
    UILabel * lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 35, 20)];
    lblPrice.text = @"0";
    lblPrice.textAlignment = NSTextAlignmentCenter;
    lblPrice.font = [UIFont systemFontOfSize:9];
//    [lblPrice sizeToFit];
    [viewPrice addSubview:lblPrice];
    
    UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(10+16, 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];
    
    vLine = [[UIView alloc]initWithFrame:CGRectMake(range+20, 57, 1, 12)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];
    
     vLine = [[UIView alloc]initWithFrame:CGRectMake(10+2*range- 15+20, 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];
    
    vLine = [[UIView alloc]initWithFrame:CGRectMake(10+3*range-15+14, 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];
    
    vLine = [[UIView alloc]initWithFrame:CGRectMake(10+4*range- 25+20, 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];
    
    vLine = [[UIView alloc]initWithFrame:CGRectMake(10+5*range- 35+20+4, 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];

    vLine = [[UIView alloc]initWithFrame:CGRectMake(10+6*range- 45+30 , 57, 1, 15)];
    vLine.backgroundColor = [UIColor darkGrayColor];
    [viewPrice addSubview:vLine];

    
    UILabel * lblPrice1 = [[UILabel alloc]initWithFrame:CGRectMake(range, 40, 40, 20)];
    lblPrice1.text = @"500";
//    [lblPrice1 sizeToFit];
    lblPrice1.textAlignment = NSTextAlignmentCenter;
    lblPrice1.font = [UIFont systemFontOfSize:9];
    [viewPrice addSubview:lblPrice1];
    
    
    UILabel * lblPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10+2*range- 15, 40, 40, 20)];
    lblPrice2.text = @"1.000";
    lblPrice2.font = [UIFont systemFontOfSize:9];
    lblPrice2.textAlignment = NSTextAlignmentCenter;
//    [lblPrice2 sizeToFit];
    [viewPrice addSubview:lblPrice2];
    
    UILabel * lblPrice3 = [[UILabel alloc]initWithFrame:CGRectMake(10+3*range-15+3, 40, 40, 20)];
    lblPrice3.text = @"2.000";
//    [lblPrice3 sizeToFit];
    lblPrice3.font = [UIFont systemFontOfSize:9];
    [viewPrice addSubview:lblPrice3];
    
    UILabel * lblPrice4 = [[UILabel alloc]initWithFrame:CGRectMake(10+4*range- 25, 40, 40, 20)];
    lblPrice4.text = @"3.000";
    lblPrice4.textAlignment = NSTextAlignmentCenter;
    lblPrice4.font = [UIFont systemFontOfSize:9];
//    [lblPrice4 sizeToFit];
    [viewPrice addSubview:lblPrice4];
    
    UILabel * lblPrice5 = [[UILabel alloc]initWithFrame:CGRectMake(10+5*range- 35+5, 40, 40, 20)];
    lblPrice5.text = @"5.000";
//    [lblPrice5 sizeToFit];
    lblPrice5.textAlignment = NSTextAlignmentCenter;
    lblPrice5.font = [UIFont systemFontOfSize:9];
    [viewPrice addSubview:lblPrice5];
    lblPrice5 = [[UILabel alloc]initWithFrame:CGRectMake(10+6*range- 45, 40, 60, 20)];
    lblPrice5.text = @">5.000";
    lblPrice5.textAlignment = NSTextAlignmentCenter;
    lblPrice5.font = [UIFont systemFontOfSize:9];
    [viewPrice addSubview:lblPrice5];
    
    
    UIButton * btnUpdatePrice = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnUpdatePrice setFrame:CGRectMake(ScreenWidth/2 - 60, 120, 120, 30)];
    [btnUpdatePrice setTitle:@"CẬP NHẬT" forState:UIControlStateNormal];
    [btnUpdatePrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnUpdatePrice.layer.cornerRadius = 3;
    btnUpdatePrice.layer.masksToBounds = YES;
    btnUpdatePrice.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
    [btnUpdatePrice addTarget:self action:@selector(updateRangeOfPrice) forControlEvents:UIControlEventTouchUpInside];
    [viewPrice addSubview:btnUpdatePrice];
}
-(void)updateRangeOfPrice
{
    
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (sender == tRangeSlider){
        NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
    }
}
-(void)initMenu
{
    viewMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [viewMenu setBackgroundColor:[UIColor whiteColor]];
    
    btnKind = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnKind setTitle:@"DANH MỤC" forState:UIControlStateNormal];
    [btnKind addTarget:self action:@selector(kindSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnKind.frame = CGRectMake(5, 5, ScreenWidth/4 - 20, 30);
    btnKind.titleLabel.numberOfLines = 2;
    [btnKind.titleLabel setFont:[UIFont boldSystemFontOfSize:9]];
    [btnKind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [viewMenu addSubview:btnKind];
    // UIButton * btnConvenient;
    //UIButton * btnPrice;
    btnConvenient = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnConvenient setTitle:@"TIỆN NGHI" forState:UIControlStateNormal];
    [btnConvenient addTarget:self action:@selector(convenientSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnConvenient.frame = CGRectMake(ScreenWidth/4, 5, ScreenWidth/4 - 20, 30);
    [btnConvenient.titleLabel setFont:[UIFont boldSystemFontOfSize:9]];
    btnConvenient.titleLabel.numberOfLines = 2;
    [btnConvenient setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [viewMenu addSubview:btnConvenient];
    
    btnPrice = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnPrice setTitle:@"GIÁ" forState:UIControlStateNormal];
    [btnPrice addTarget:self action:@selector(priceSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnPrice.frame = CGRectMake(ScreenWidth/2, 5, ScreenWidth/4 - 20, 30);
    [btnPrice.titleLabel setFont:[UIFont boldSystemFontOfSize:9]];
    [btnPrice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnPrice.titleLabel.numberOfLines = 2;
    [viewMenu addSubview:btnPrice];
    
    
    
    btnFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnFilter setTitle:@"SẮP XẾP" forState:UIControlStateNormal];
    [btnFilter addTarget:self action:@selector(filterSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnFilter.frame = CGRectMake((3*ScreenWidth/4)+5, 5, ScreenWidth/4 - 20, 30);
    btnFilter.titleLabel.numberOfLines = 2;
    [btnFilter.titleLabel setFont:[UIFont boldSystemFontOfSize:9]];
    [btnFilter setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [viewMenu addSubview:btnFilter];
    
    UIView * vLineBreak = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/4 - 0.5, 0, 1, 40)];
    vLineBreak.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vLineBreak];
    
    UIView * vLineBreak2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 0.5, 0, 1, 40)];
    vLineBreak2.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vLineBreak2];
    
    
    UIView * vLineBreak3 = [[UIView alloc]initWithFrame:CGRectMake(3*ScreenWidth/4 - 0.5, 0, 1, 40)];
    vLineBreak3.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vLineBreak3];
    
    
    UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 10)];
    vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    //    vPadding.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vPadding];
    
    UIImageView * vDownBreak = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/4 - 12, 16, 8, 8)];
    vDownBreak.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak];
    
    UIImageView * vDownBreak2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 12, 16, 8, 8)];
    vDownBreak2.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak2];
    
    UIImageView * vDownBreak3 = [[UIImageView alloc]initWithFrame:CGRectMake(3*ScreenWidth/4 - 12, 16, 8, 8)];
    vDownBreak3.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak3];
    
    UIImageView * vDownBreak4 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 12, 16, 8, 8)];
    vDownBreak4.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak4];
    
    [self.view addSubview:viewMenu];
}

-(void)initDataMenu
{
    arrMenu1 = [[NSMutableArray alloc]init];
    MenuObject * item = [MenuObject new];
    item.strName = @"TẤT CẢ";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"THỜI TRANG NAM";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"THỜI TRANG NỮ";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"THỜI TRANG TRẺ EM";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"KHÁC";
    [arrMenu1 addObject:item];
    
    arrMenu1_1 = [[NSMutableArray alloc]init];
    MenuObject * item1_1 = [MenuObject new];
    item1_1.strName = @"VÁY ĐẦM";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"CÔNG SỞ";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"QUẦN";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"ÁO";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"GIÀY";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"DÉP";
    [arrMenu1_1 addObject:item1_1];
    
    item1_1 = [MenuObject new];
    item1_1.strName = @"PHỤ KIỆN";
    [arrMenu1_1 addObject:item1_1];
    
    
    arrMenu2 = [[NSMutableArray alloc]init];
    MenuObject * item2 = [MenuObject new];
    item2.strName = @"TẤT CẢ";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"1 SAO";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"2 SAO";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"3 SAO";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"4 SAO";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"5 SAO";
    [arrMenu2 addObject:item2];
    
    
    arrMenu3 = [[NSMutableArray alloc]init];
    MenuObject * item3 = [MenuObject new];
    item3.strName = @"MỚI NHẤT";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"LƯỢT MUA";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"GIÁ";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"ĐÁNH GIÁ";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"SẮP HẾT HẠN";
    [arrMenu3 addObject:item3];
}
-(void)showMenu
{
    if(isShowSortMenu2 == NO)
    {
        isShowSortMenu2 = YES;
        [self setDimView:YES];
        if (iIndexMenu == 2) {
            [self initCollectionWithNumOfItem:[arrMenu2 count]];
        }
        if (iIndexMenu == 4)
        {
            [self initCollectionWithNumOfItem:[arrMenu3 count]];
        }
    }
    else
    {
        isShowSortMenu2 = NO;
        [self dissmissMenu];
    }
}

-(void)removeAllMenu
{
    [viewPrice removeFromSuperview];
    [tableViewSubCategory1 removeFromSuperview];
    [tableViewSubCategory2 removeFromSuperview];
    [tableViewSubCategory3 removeFromSuperview];
}
-(void)dissmissMenu
{
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConvenient setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self removeAllMenu];
    isShowSortMenu3 = YES;
    isShowPriceMenu = YES;
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, 50, ScreenWidth, collectionView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.collectionView removeFromSuperview];
                         dimView.alpha = 0;
                     }];
    
}
#pragma mark collection datasource + delegate
-(void)initCollectionWithNumOfItem:(int)quantity
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    double d = (double)quantity/3; int i = quantity/3;
    if (d > i) {
        iMenuRow1 = i + 1;
    }
    else
        iMenuRow1 = i;
    //    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (self.collectionView != nil) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
    }
    if (iIndexMenu == 2) {
        //    if (iIndexMenu == 1){
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, iMenuRow1*CollectionItemHeight1 + 30) collectionViewLayout:flowLayout];
        [btnConvenient setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
    }
    
    if (iIndexMenu == 4)    {
        [btnFilter setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, iMenuRow1*CollectionItemHeight2) collectionViewLayout:flowLayout];
    }
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionItem" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionItem"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (iIndexMenu == 2) {
                             collectionView.frame = CGRectMake(0, 41, ScreenWidth, iMenuRow1*CollectionItemHeight1 + 30);
                         }
                         if(iIndexMenu == 4)
                         {
                             collectionView.frame = CGRectMake(0, 41, ScreenWidth, iMenuRow1*CollectionItemHeight2 + 30);
                         }
                         
                     }
                     completion:^(BOOL finished){
                     }];
    //    [self.view addSubview:self.postStatusView];
    
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (iIndexMenu == 2) {
        return [arrMenu2 count];
    }
    if (iIndexMenu == 4)
    {
        return [arrMenu3 count];
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionItem * cell = (CustomCollectionItem*)[collectionViews cellForItemAtIndexPath:indexPath];
    [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    
    if (iIndexMenu == 2) {
        lastIndexPathMenu2 = indexPath;
        [btnConvenient setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
    }
    if (iIndexMenu == 4) {
        lastIndexPathMenu3 = indexPath;
        [btnFilter setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
    }
    [self dissmissMenu];
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isShowSortMenu2 = NO;
}

- (void)buttonClicked:(UIButton *)button
{
    UA_log(@"%@", button.titleLabel.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [[collectionView delegate] collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    if (iIndexMenu == 2) {
        lastIndexPathMenu2 = indexPath;
        [btnKind setTitle:button.titleLabel.text forState:UIControlStateNormal];
    }
    if (iIndexMenu == 3) {
        lastIndexPathMenu3 = indexPath;
        [btnFilter setTitle:button.titleLabel.text forState:UIControlStateNormal];
    }
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CustomCollectionItem";
    CustomCollectionItem *cell = [collectionViews dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.btnName.titleLabel.numberOfLines = 2;
    cell.btnName.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.btnName addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    MenuObject * item  = [MenuObject new];
    if (iIndexMenu == 2) {
        item = [arrMenu2 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu2]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
    }
    if (iIndexMenu == 4) {
        item = [arrMenu3 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu3]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
    }
    [cell.btnName setTitle:item.strName forState:UIControlStateNormal];
    cell.btnName.layer.cornerRadius = 3;
    cell.btnName.layer.masksToBounds = YES;
    cell.btnName.tag = indexPath.row;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (iIndexMenu == 2) {
        if (IS_IPHONE_6) {
            return  CGSizeMake(105, 50);
        }
        if (IS_IPHONE_6_PLUS) {
            return  CGSizeMake(115, 50);
        }
        return CGSizeMake(90, 50);
    }
    else
    {
        if (IS_IPHONE_6) {
            return  CGSizeMake(105, 33);
        }
        if (IS_IPHONE_6_PLUS) {
            return  CGSizeMake(115, 33);
        }
        return CGSizeMake(90, 33);
    }
}
- (void)buttonClicked2:(UIButton *)button
{
    UA_log(@"%@", button.titleLabel.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [[tableViewSubCategory1 delegate] tableView:tableViewSubCategory1 didSelectRowAtIndexPath:indexPath];
    lastIndexPathMenu1 = indexPath;
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tableViewSubCategory1 reloadData];
}

- (void)buttonClicked3:(UIButton *)button
{
    UA_log(@"%@", button.titleLabel.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [[tableViewSubCategory2 delegate] tableView:tableViewSubCategory2 didSelectRowAtIndexPath:indexPath];
    lastIndexPathMenu1_2 = indexPath;
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tableViewSubCategory2 reloadData];
}

- (void)buttonClicked4:(UIButton *)button
{
    UA_log(@"%@", button.titleLabel.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [[tableViewSubCategory3 delegate] tableView:tableViewSubCategory3 didSelectRowAtIndexPath:indexPath];
    lastIndexPathMenu1_3 = indexPath;
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self dissmissMenu];
}

@end
