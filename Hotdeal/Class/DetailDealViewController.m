//
//  DetailDealViewController.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/29/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "DetailDealViewController.h"
#import "DYRateView.h"

#define kGetMaxMainScroll detailScroll.contentSize.height + detailScroll.contentOffset.x
#define kTagForIntroWebView         24001
#define kTagForconditionsWebView    25001
#define kTagForDecriptionWebView    26001;

@interface DetailDealViewController ()

@end

@implementation DetailDealViewController

- (id)initWithProduct:(ProductObj *)product {
    self = [super init];
    if(self) {
        self.productSelected = product;
        self.view.backgroundColor = [UIColor colorWithWhite:242.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    
    detailScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    detailScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, 0)];
    [self.view addSubview:detailScroll];
    
    self.listView = [[NSMutableArray alloc] init];
    [self getDataDetailPage:self.productSelected.productId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)getDataDetailPage:(int)product {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + [AppDelegate sharedDelegate].distanTimeServer;
    NSString *signAPI = [[AppDelegate sharedDelegate] getSignAPI:currentDate withAPIName:kBOGetDetailPage];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetDetailPage forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    [param setObject:[NSNumber numberWithInt:[locationStored.locationID intValue]] forKey:@"stateId"];
    [param setObject:[NSNumber numberWithInt:product] forKey:@"productId"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSDictionary *dataGet = [[json objectForKey:@"data"] objectForKey:@"product"];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.productSelected updateDataForDetail:dataGet];
                [self createImageSlideView:self.productSelected.imageSlide];
                [self createInfoDealView];
                [self createIntroDealView:2];
//                [self createAddressView];
                [self createConditionsView:4];
                [self createDecriptionView:5];
            });
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"error message %s = %@", __PRETTY_FUNCTION__, error.localizedDescription);
    }];
}

#pragma mark - Handle Action



#pragma mark - Create View

- (void)createImageSlideView:(NSArray *)listImage {
    imageSlideView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 200)];
    imageSlideView.backgroundColor = [UIColor whiteColor];
    imageSlideView.delegate = self;
    imageSlideView.pagingEnabled = YES;
    [detailScroll addSubview:imageSlideView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [imageSlideView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, imageSlideView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [imageSlideView addSubview:bottomBorderView];
    
    for(int i = 0; i < [listImage count]; i++) {
        int startX = SCREEN_WIDTH * i;
        NSString *linkImage = [listImage objectAtIndex:i];
        UIImageView *imageSlide = [[UIImageView alloc] initWithFrame:CGRectMake(startX, 0, SCREEN_WIDTH, imageSlideView.bounds.size.height)];
        imageSlide.contentMode = UIViewContentModeScaleAspectFill;
        [imageSlide setImageWithURL:[NSURL URLWithString:linkImage] placeholderImage:[UIImage imageNamed:@"img_thumb.png"]];
        imageSlide.userInteractionEnabled = NO;
        [imageSlideView addSubview:imageSlide];
    }
    imageSlideView.contentSize = CGSizeMake(SCREEN_WIDTH*[listImage count], imageSlideView.bounds.size.height);
    
    int heightSet = kGetMaxMainScroll + imageSlideView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:imageSlideView];
}

- (void)createInfoDealView {
    infoDealView = [[UIView alloc] initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 170)];
    infoDealView.backgroundColor = [UIColor whiteColor];
    [detailScroll addSubview:infoDealView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [infoDealView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, infoDealView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [infoDealView addSubview:bottomBorderView];
    
    UILabel *titleDeal = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 55)];
    titleDeal.font = kSystemFonSizeRevert(16);
    titleDeal.textColor = [UIColor colorWithWhite:18.0/255.0 alpha:1.0];
    titleDeal.numberOfLines = 2;
    titleDeal.text = _productSelected.nameProduct;
    [infoDealView addSubview:titleDeal];
    
    NSString *priceString = [NSString stringWithFormat:@"%dđ",_productSelected.listPrice];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:attributes];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBaselineOffsetAttributeName : @5} range:NSMakeRange([priceString length] - 1, 1)];
    
    UILabel *priceDeal = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH - 30, 20)];
    priceDeal.font = kSystemFonSizeRevert(10);
    priceDeal.textColor = [UIColor colorWithWhite:18.0/255.0 alpha:1.0];
    priceDeal.attributedText = attributedString;
    [infoDealView addSubview:priceDeal];
    
    NSString *discountString = [NSString stringWithFormat:@"%dđ",_productSelected.priceProduct];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:discountString attributes:nil];
    [attributedString1 setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([discountString length] - 1, 1)];
    
    UILabel *discountPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, SCREEN_WIDTH - 30, 20)];
    discountPriceLabel.font = kSystemFonSizeRevert(13);
    discountPriceLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:28.0/255.0 alpha:1.0];
    discountPriceLabel.attributedText = attributedString1;
    [infoDealView addSubview:discountPriceLabel];
    
    UIView *contentRateView = [[UIView alloc] initWithFrame:CGRectMake(15, 97, 120, 20)];
    [infoDealView addSubview:contentRateView];
    
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 3, contentRateView.bounds.size.width - 50, 14) fullStar:[UIImage imageNamed:@"start_yellow.png"] emptyStar:[UIImage imageNamed:@"start_grey.png"]];
    rateView.padding = 0;
    rateView.alignment = RateViewAlignmentLeft;
    rateView.rate = _productSelected.rateValue;
    rateView.editable = NO;
    [contentRateView addSubview:rateView];
    
    UILabel *totalRating = [[UILabel alloc] initWithFrame:CGRectMake(rateView.bounds.size.width+2, 0, 35, 20)];
    totalRating.backgroundColor = [UIColor clearColor];
    totalRating.textColor = [UIColor colorWithWhite:118.0/255.0 alpha:1.0];
    totalRating.font = kSystemFonSizeRevert(11);
    totalRating.text = [NSString stringWithFormat:@"(%d)", _productSelected.rateTotal];
    [contentRateView addSubview:totalRating];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(SCREEN_WIDTH - 95, 92, 80, 25);
    shareButton.layer.borderWidth = 1;
    shareButton.layer.borderColor = [UIColor grayColor].CGColor;
    [shareButton setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [infoDealView addSubview:shareButton];
    
    int heightSet = kGetMaxMainScroll + infoDealView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:infoDealView];
}

- (void)createIntroDealView:(int)indexTag {
    introDealView = [[UIView alloc] initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 250)];
    introDealView.backgroundColor = [UIColor whiteColor];
    [detailScroll addSubview:introDealView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [introDealView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, introDealView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [introDealView addSubview:bottomBorderView];
    
    UILabel *titleIntro = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 35)];
    titleIntro.backgroundColor = [UIColor clearColor];
    titleIntro.textColor = [UIColor colorWithWhite:61.0/255.0 alpha:1.0];
    titleIntro.text = @"GIỚI THIỆU";
    titleIntro.font = [UIFont systemFontOfSize:14];
    [introDealView addSubview:titleIntro];
    
    UIView *redSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 31, titleIntro.bounds.size.width, 4)];
    redSpaceLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:30.0/255.0 alpha:1.0];
    redSpaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [titleIntro addSubview:redSpaceLine];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 1)];
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    spaceLine.backgroundColor = [UIColor colorWithWhite:206.0/255.0 alpha:1.0];
    [introDealView addSubview:spaceLine];
    
    UIWebView *introWebView = [[UIWebView alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 30, introDealView.bounds.size.height - 70)];
    introWebView.delegate = self;
    introWebView.tag = kTagForIntroWebView;
    introWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    introWebView.scrollView.scrollEnabled = NO;
    introWebView.backgroundColor = [UIColor clearColor];
    [introWebView sizeThatFits:CGSizeZero];
    introWebView.scrollView.scrollsToTop = NO;
    [introDealView addSubview:introWebView];
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", kSystemFonSizeRevert(12).fontName, [NSNumber numberWithInt:12], _productSelected.introduceDeal];
    [introWebView loadHTMLString:myDescriptionHTML baseURL:nil];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, introDealView.bounds.size.height - 70, SCREEN_WIDTH, 70);
    moreButton.tag = indexTag;
    moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [moreButton setBackgroundImage:[UIImage imageNamed:@"bar_covertext.png"] forState:UIControlStateNormal];
    [moreButton setTitle:@"Xem thêm" forState:UIControlStateNormal];
    moreButton.titleLabel.font = kSystemFonSizeRevert(12);
    [moreButton setTitleColor:[UIColor colorWithWhite:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [introDealView addSubview:moreButton];
    
    int heightSet = kGetMaxMainScroll + introDealView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:introDealView];
}

- (void)createAddressView {
    locationUseView = [[UIView alloc]initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 110)];
    locationUseView.backgroundColor = [UIColor whiteColor];
    [detailScroll addSubview:locationUseView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [locationUseView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, locationUseView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [locationUseView addSubview:bottomBorderView];
    
    UILabel *titleLocation = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 35)];
    titleLocation.backgroundColor = [UIColor clearColor];
    titleLocation.textColor = [UIColor colorWithWhite:61.0/255.0 alpha:1.0];
    titleLocation.font = [UIFont systemFontOfSize:14];
    titleLocation.text = @"ĐỊA ĐIỂM SỬ DỤNG";
    [locationUseView addSubview:titleLocation];
    
    UIView *redSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 31, titleLocation.bounds.size.width, 4)];
    redSpaceLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:30.0/255.0 alpha:1.0];
    redSpaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [titleLocation addSubview:redSpaceLine];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 1)];
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    spaceLine.backgroundColor = [UIColor colorWithWhite:206.0/255.0 alpha:1.0];
    [locationUseView addSubview:spaceLine];
    
    UILabel *locationDetail = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 30, 75)];
    locationDetail.font = kSystemFonSizeRevert(12);
    locationDetail.numberOfLines = 3;
    locationDetail.textColor = [UIColor colorWithWhite:57.0/255.0 alpha:1.0];
    [locationUseView addSubview:locationDetail];
    
    NSString *adressString = @"";
    NSString *phoneString = @"";
    
    int heightSet = kGetMaxMainScroll + locationUseView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:locationUseView];
}

- (void)createConditionsView:(int)indexTag {
    conditionsView = [[UIView alloc]initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 250)];
    conditionsView.backgroundColor = [UIColor whiteColor];
    [detailScroll addSubview:conditionsView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [conditionsView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, conditionsView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [conditionsView addSubview:bottomBorderView];
    
    UILabel *titleConditions = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 140, 35)];
    titleConditions.backgroundColor = [UIColor clearColor];
    titleConditions.textColor = [UIColor colorWithWhite:61.0/255.0 alpha:1.0];
    titleConditions.font = [UIFont systemFontOfSize:14];
    titleConditions.text = @"ĐIỀU KIỆN SỬ DỤNG";
    [conditionsView addSubview:titleConditions];
    
    UIView *redSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 31, titleConditions.bounds.size.width, 4)];
    redSpaceLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:30.0/255.0 alpha:1.0];
    redSpaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [titleConditions addSubview:redSpaceLine];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 1)];
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    spaceLine.backgroundColor = [UIColor colorWithWhite:206.0/255.0 alpha:1.0];
    [conditionsView addSubview:spaceLine];
    
    UIWebView *conditionWebView = [[UIWebView alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 30, conditionsView.bounds.size.height - 70)];
    conditionWebView.delegate = self;
    conditionWebView.tag = kTagForconditionsWebView;
    conditionWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    conditionWebView.backgroundColor = [UIColor clearColor];
    [conditionWebView sizeThatFits:CGSizeZero];
    conditionWebView.scrollView.scrollEnabled = NO;
    conditionWebView.scrollView.scrollsToTop = NO;
    [conditionsView addSubview:conditionWebView];
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", kSystemFonSizeRevert(12).fontName, [NSNumber numberWithInt:12], _productSelected.conditionsDeal];
    [conditionWebView loadHTMLString:myDescriptionHTML baseURL:nil];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, conditionsView.bounds.size.height - 70, SCREEN_WIDTH, 70);
    moreButton.tag = indexTag;
    moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [moreButton setBackgroundImage:[UIImage imageNamed:@"bar_covertext.png"] forState:UIControlStateNormal];
    [moreButton setTitle:@"Xem thêm" forState:UIControlStateNormal];
    moreButton.titleLabel.font = kSystemFonSizeRevert(12);
    [moreButton setTitleColor:[UIColor colorWithWhite:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [conditionsView addSubview:moreButton];
    
    int heightSet = kGetMaxMainScroll + conditionsView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:conditionsView];
}

- (void)createDecriptionView:(int)indexTag {
    decriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, kGetMaxMainScroll, SCREEN_WIDTH, 350)];
    decriptionView.backgroundColor = [UIColor whiteColor];
    [detailScroll addSubview:decriptionView];
    
    UIView *topBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    topBorderView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [decriptionView addSubview:topBorderView];
    
    UIView *bottomBorderView = [[UIView alloc]initWithFrame:CGRectMake(0, decriptionView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    bottomBorderView.backgroundColor = [UIColor colorWithWhite:218.0/255.0 alpha:1.0];
    bottomBorderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [decriptionView addSubview:bottomBorderView];
    
    UILabel *titleDecription = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 35)];
    titleDecription.backgroundColor = [UIColor clearColor];
    titleDecription.textColor = [UIColor colorWithWhite:61.0/255.0 alpha:1.0];
    titleDecription.font = [UIFont systemFontOfSize:14];
    titleDecription.text = @"CHI TIẾT";
    [decriptionView addSubview:titleDecription];
    
    UIView *redSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 31, titleDecription.bounds.size.width, 4)];
    redSpaceLine.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0.0 blue:30.0/255.0 alpha:1.0];
    redSpaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [titleDecription addSubview:redSpaceLine];
    
    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 1)];
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    spaceLine.backgroundColor = [UIColor colorWithWhite:206.0/255.0 alpha:1.0];
    [decriptionView addSubview:spaceLine];
    
    UIWebView *decriptionWebView = [[UIWebView alloc]initWithFrame:CGRectMake(15, 35, SCREEN_WIDTH - 30, decriptionView.bounds.size.height - 70)];
    decriptionWebView.delegate = self;
    decriptionWebView.tag = kTagForDecriptionWebView;
    decriptionWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    decriptionWebView.backgroundColor = [UIColor clearColor];
    [decriptionWebView sizeThatFits:CGSizeZero];
    decriptionWebView.scrollView.scrollEnabled = NO;
    decriptionWebView.scrollView.scrollsToTop = YES;
    [decriptionView addSubview:decriptionWebView];
    
    NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", kSystemFonSizeRevert(12).fontName, [NSNumber numberWithInt:12], _productSelected.descriptionDeal];
    [decriptionWebView loadHTMLString:myDescriptionHTML baseURL:nil];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, decriptionView.bounds.size.height - 70, SCREEN_WIDTH, 70);
    moreButton.tag = indexTag;
    moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [moreButton setTitle:@"Xem thêm" forState:UIControlStateNormal];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"bar_covertext.png"] forState:UIControlStateNormal];
    moreButton.titleLabel.font = kSystemFonSizeRevert(12);
    [moreButton setTitleColor:[UIColor colorWithWhite:154.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [decriptionView addSubview:moreButton];
    
    int heightSet = kGetMaxMainScroll + decriptionView.bounds.size.height + 10;
    [detailScroll setContentSize:CGSizeMake(detailScroll.contentSize.width, heightSet)];
    [_listView addObject:decriptionView];
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
