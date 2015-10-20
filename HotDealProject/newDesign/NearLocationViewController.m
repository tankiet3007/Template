//
//  NearLocationViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//
#import "AppDelegate.h"
#import "HotNewDetailViewController.h"
#import "SupplierCell.h"
#import "NearLocationViewController.h"
#import "SVPullToRefresh.h"
#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"

@interface NearLocationViewController ()

@end

@implementation NearLocationViewController
{
    //    BBBadgeBarButtonItem *barButton;
    NSMutableArray * arrMapItem;
    
    MBProgressHUD *HUD;
    BOOL bForceStop;
    NSMutableArray * arrDeals;
}
@synthesize mapView;
@synthesize tableDeal;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavigationbar:@"Gần đây"];
     [self initHUD];
    arrDeals = [[NSMutableArray alloc]init];
    [self initData2:10 wOffset:1 wType:@"default"];
    
    [self setMapView:nil wIZoom:12];
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
}
-(void)initData2:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    F(@"%d", 437), @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    @"",@"q",
                                    nil];
    
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequestAF:jsonDictionary withURL:URL_SEARCH_DEAL completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        for (NSDictionary * dictItem in arrProducts) {
            DealObject * item = [[DealObject alloc]init];
            if ([dictItem objectForKey:@"title"] == [NSNull null]) {
                item.strTitle = @"";
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.strTitle = [dictItem objectForKey:@"title"];
            }

            if ([dictItem objectForKey:@"product_id"] == [NSNull null]) {
                item.product_id = 0;
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            }
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            if ([dictItem objectForKey:@"price"] == [NSNull null]) {
                item.lDiscountPrice = 0;
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            }
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.isNew = YES;
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iKind = [[dictItem objectForKey:@"product_kind"]intValue];
            item.strType = [dictItem objectForKey:@"type"];
            [arrDeals addObject:item];

        }
        UA_log(@"%lu item", [arrDeals count]);
        //        [tableViewSearch reloadData];
        [self initUITableView];
    }];
    
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:strTitle];
}

-(void)setMapView:(NSArray *)arrLocation wIZoom:(int)iZoom
{
    if (arrMapItem != nil &&  [arrMapItem count]>0) {
        [arrMapItem removeAllObjects];
        arrMapItem = nil;
    }
    
    arrMapItem= [[NSMutableArray alloc]init];
    if (mapView != nil) {
        mapView = nil;
        [mapView removeFromSuperview];
    }
    mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    mapView.zoomLevel = iZoom;
    //    for (NSDictionary * outletItem in arrLocation) {
    //        BasicMapAnnotation *  mapItem = [[BasicMapAnnotation alloc]init];
    //        NSString * strTitle = [outletItem objectForKey:@"name"];
    //        NSString * strContent = F(@"%@\n%@", [outletItem objectForKey:@"address"], [outletItem objectForKey:@"phone"]);
    //        NSString * strLogo = [outletItem objectForKey:@"urlLogo"];
    //        float latTiTude = [[outletItem objectForKey:@"gpsLatitude"] floatValue];
    //        float longTitude = [[outletItem objectForKey:@"gpsLongitude"] floatValue];
    //        mapItem._content = strContent;
    //        mapItem._title = strTitle;
    //        mapItem._logo = strLogo;
    //        mapItem._latitude = latTiTude;
    //        mapItem._longitude = longTitude;
    //
    //        [arrMapItem addObject:mapItem];
    //    }
    BasicMapAnnotation *  mapItem = [[BasicMapAnnotation alloc]init];//10.751597, 106.669512
    mapItem._content = @"Đường Nguyễn Tri Phương";
    mapItem._title = @"Đường Nguyễn Tri Phương";
    mapItem._logo = nil;
    mapItem.iID = 12;
    mapItem._latitude = 10.770951;
    mapItem._longitude = 106.650588;
    [arrMapItem addObject:mapItem];
    
    mapItem = [[BasicMapAnnotation alloc]init];//10.751597, 106.669512
    mapItem._content = @"Đường Nguyễn Tri Phương";
    mapItem._title = @"Đường Nguyễn Tri Phương";//10.753320, 106.674855
    mapItem._logo = nil;//10.762881, 106.658308
    mapItem._latitude = 10.771847;
    mapItem._longitude = 106.652809;
    mapItem.iID = 13;
    [arrMapItem addObject:mapItem];
    
    mapItem = [[BasicMapAnnotation alloc]init];//10.751597, 106.669512
    mapItem._content = @"Đường Nguyễn Tri Phương";
    mapItem._title = @"Đường Nguyễn Tri Phương";//10.753320, 106.674855
    mapItem._logo = nil;//10.762881, 106.658308
    mapItem._latitude = 10.768569;
    mapItem._longitude = 106.652616;
        mapItem.iID = 14;
    [arrMapItem addObject:mapItem];
    
    [mapView initMap:arrMapItem];
    [self.view addSubview:mapView];
    [mapView startLocationRequest];
}

-(void)initUITableView
{
    tableDeal = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT(mapView), ScreenWidth, ScreenHeight - HEIGHT(mapView)) style:UITableViewStylePlain];
    [self.view addSubview:tableDeal];
    tableDeal.backgroundColor = [UIColor whiteColor];
    tableDeal.dataSource = self;
    tableDeal.delegate = self;
    tableDeal.separatorColor = [UIColor clearColor];
    tableDeal.showsVerticalScrollIndicator = NO;
    tableDeal.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrDeals count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.isDragging) {
//        UIView *myView = cell.contentView;
//        CALayer *layer = myView.layer;
//        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*0.5, 1.0f, 0.0f, 0.0f);
//
//        layer.transform = rotationAndPerspectiveTransform;
//        [UIView animateWithDuration:.5 animations:^{
//            layer.transform = CATransform3DIdentity;
//        }];
//    }
//
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SupplierCell";
    
    SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(indexPath.row != arrDeals.count-1){
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
    //        cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    //        NSString *photourl = F(@"%@&size=250x250", item.strBrandImage);;
    //    if (isNetworkConnected == TRUE) {
    //        [[SDImageCache sharedImageCache] removeImageForKey:photourl fromDisk:YES];
    //    }
    //    [cell.imgLogo setImageWithURL:[NSURL URLWithString:photourl]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    //        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://dev.hotdeal.vn/index.php?dispatch=products.image_mapi&product_id=288045&size=250x250"] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    float calculatePercent = (1-(float)((float)item.lDiscountPrice/(float)item.lStandarPrice)) *100;
    cell.lblPercentage.text = F(@"%.0f%%", calculatePercent);
    
    DLStarRatingControl *starRating = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(100, 41, 100, 26)];
    if (IS_IPHONE_6_PLUS) {
        [starRating setFrame:CGRectMake(92, 41, 100, 26)];
    }
    starRating.tag = indexPath.row +101;
    starRating.backgroundColor = [UIColor clearColor];
    //        cell.starRating.rating =  item.iRate ;
    starRating.rating = 3.5;
    //        starRating.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
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
    attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strDiscountPrice) attributes:attributes];
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

-(void)loadMoreDeal
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    F(@"%d", 437), @"city",
                                    [NSNumber numberWithInteger:[arrDeals count]], @"fetch_count",
                                    [NSNumber numberWithInt:30], @"offset",
                                    @"newest",@"fetch_type",
                                    @"",@"q",
                                    nil];
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
            if ([dictItem objectForKey:@"title"] == [NSNull null]) {
                item.strTitle = @"";
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.strTitle = [dictItem objectForKey:@"title"];
            }

            if ([dictItem objectForKey:@"product_id"] == [NSNull null]) {
                item.product_id = 0;
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            }
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            if ([dictItem objectForKey:@"price"] == [NSNull null]) {
                item.lDiscountPrice = 0;
                if (FLAG_EMPTY_PARAMETER) {
                    continue;
                }
            }
            else
            {
                item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            }
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.isNew = YES;
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iKind = [[dictItem objectForKey:@"product_kind"]intValue];
            item.strType = [dictItem objectForKey:@"type"];
            [arrDeals addObject:item];

        }
        UA_log(@"%lu item", [arrDeals count]);
        [tableDeal reloadData];
    }];
    
}


@end
