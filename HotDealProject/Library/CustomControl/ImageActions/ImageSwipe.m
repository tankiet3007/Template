//
//  ImageSwipe.m
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//
#import "ImageSwipe.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@implementation ImageSwipe
@synthesize imgBack, imgFront, galleryImages, viewBack, viewFront, scrollBack, scrollFront;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    if ([aScrollView isEqual: scrollFront]) {
        return  imgFront;
    }
    return imgBack;
}


-(void)initView:(NSArray *)arrImage
{
    viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollBack = [[UIScrollView alloc]initWithFrame:viewBack.frame];
    
    viewFront = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollFront = [[UIScrollView alloc]initWithFrame:viewFront.frame];
    viewFront = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:viewFront];
    [self addSubview:viewBack];
    
    imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    imgBack.image = [UIImage imageWithContentsOfFile:arrImage[1]];
    imgBack.contentMode = UIViewContentModeScaleAspectFit;
    [scrollBack addSubview:imgBack];
    
    imgFront = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    imgFront.image = [UIImage imageWithContentsOfFile:arrImage[0]];
    imgFront.contentMode = UIViewContentModeScaleAspectFit;
    [scrollFront addSubview:imgFront];
    
    // For supporting zoom,
    scrollFront.minimumZoomScale = 1.0;
    scrollFront.maximumZoomScale = 2.0;
    
    scrollBack.minimumZoomScale = 1.0;
    scrollBack.maximumZoomScale = 2.0;
    
    scrollFront.contentSize = imgFront.frame.size;
    scrollBack.contentSize = imgBack.frame.size;
    scrollFront.delegate = self;
    scrollBack.delegate = self;
    [viewBack addSubview:scrollBack];
    [viewFront addSubview:scrollFront];
    
    NSString *photourl = @"";
    
    [imgBack setImageWithURL:[NSURL URLWithString:photourl]
 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [imgFront setImageWithURL:[NSURL URLWithString:@""]
  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    viewFront.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(flipViews2)
                                   userInfo:Nil
                                    repeats:NO];
    //    [self flipViews2];
}
#pragma mark animation views
- (void)FlipUI
{
    UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:leftSwipe];
    [self addGestureRecognizer:rightSwipe];
    
}

-(void)autoRotate
{
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(flipViews2)
                                   userInfo:Nil
                                    repeats:NO];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    //    UA_log(@"%s", __FUNCTION__);
    
    switch (recognizer.direction)
    {
        case (UISwipeGestureRecognizerDirectionRight):
        {
            [self flipViews];
            break;
        }
            
        case (UISwipeGestureRecognizerDirectionLeft):
        {
            [self flipViews2];
            break;
            
        }
        default:
            break;
    }
}

-(void)flipViews
{
    viewFront.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
    if ([viewBack superview])
    {
        [viewBack removeFromSuperview];
        [self addSubview:viewFront];
        [self sendSubviewToBack:viewBack];
    }
    else
    {
        [viewFront removeFromSuperview];
        [self addSubview:viewBack];
        [self sendSubviewToBack:viewFront];
        
    }
    
    [UIView commitAnimations];
}

-(void)flipViews2
{
    viewFront.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
    if ([viewBack superview])
    {
        [viewBack removeFromSuperview];
        [self addSubview:viewFront];
        [self sendSubviewToBack:viewBack];
    }
    else
    {
        [viewFront removeFromSuperview];
        [self addSubview:viewBack];
        [self sendSubviewToBack:viewFront];
        
    }
    
    [UIView commitAnimations];
}

-(void)initView2:(NSString *)strTemplateData;
{
    NSData *data = [strTemplateData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString * test = [json objectForKey:@"text1"];
    NSLog(@"TEST IS %@", test);
    
    viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    viewBack.backgroundColor = [UIColor whiteColor];
    scrollBack = [[UIScrollView alloc]initWithFrame:viewBack.frame];
    
    viewFront = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    viewFront.backgroundColor = [UIColor whiteColor];
    scrollFront = [[UIScrollView alloc]initWithFrame:viewFront.frame];
    [self addSubview:viewFront];
    [self addSubview:viewBack];
    
    UIImageView * imageVTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    imageVTop.image = [UIImage imageNamed:@"pkm_no"];
    [viewBack addSubview:imageVTop];
    
    
    UIView * vMiddle;
    UILabel *lblDiscount;
    UILabel *lblDiscountValue;
    UILabel *lblExchangRate;
    UILabel *lblExchangVoucherValue;
    UILabel *lblExchangVoucherCondition;
    UIImageView * imgLogo;
    if (!IS_IPHONE_5) {
        vMiddle = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 90)];
        vMiddle.backgroundColor = [UIColor blueColor];
        lblDiscount = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 110, 20)];
        lblDiscount.textColor = [UIColor whiteColor];
        lblDiscount.font = [UIFont boldSystemFontOfSize:15];
        lblDiscount.text =[json objectForKey:@"text1"];// @"CHIẾT KHẤU";
        [vMiddle addSubview:lblDiscount];
        
        lblDiscountValue = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, 160, 35)];
        lblDiscountValue.text = [json objectForKey:@"text2"];//@"150.000";
        lblDiscountValue.font = [UIFont boldSystemFontOfSize:30];
        lblDiscountValue.textColor = [UIColor whiteColor];
        [vMiddle addSubview:lblDiscountValue];
        
        lblExchangRate = [[UILabel alloc]initWithFrame:CGRectMake(250, 12, 40, 25)];
        lblExchangRate.text = [json objectForKey:@"text3"];//@"VNĐ";
        lblExchangRate.font = [UIFont boldSystemFontOfSize:17];
        lblExchangRate.textColor = [UIColor whiteColor];
        [vMiddle addSubview:lblExchangRate];
        
        lblExchangVoucherValue = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, 260, 18)];
        lblExchangVoucherValue.text =[json objectForKey:@"text4"];// @"CHO HOÁ ĐƠN TRÊN 400.000 VNĐ";
        lblExchangVoucherValue.textAlignment = NSTextAlignmentCenter;
        lblExchangVoucherValue.font = [UIFont boldSystemFontOfSize:15];
        lblExchangVoucherValue.textColor = [UIColor whiteColor];
        [vMiddle addSubview:lblExchangVoucherValue];
        
        lblExchangVoucherCondition = [[UILabel alloc]initWithFrame:CGRectMake(60, 55, 240, 30)];
        lblExchangVoucherCondition.text = [json objectForKey:@"text5"];//@"(Phiếu không quy đổi tiền mặt có giá trị từ ngày 16/9 đến ngày 15/10/2014)";
        lblExchangVoucherCondition.textAlignment = NSTextAlignmentCenter;
        lblExchangVoucherCondition.numberOfLines = 2;
        lblExchangVoucherCondition.font = [UIFont italicSystemFontOfSize:12];
        lblExchangVoucherCondition.textColor = [UIColor whiteColor];
        [vMiddle addSubview:lblExchangVoucherCondition];
        
        imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(100, 145, 120, 120)];
        NSString *photourl = @"";
        [imgLogo setImageWithURL:[NSURL URLWithString:photourl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //        imgLogo.image = [json objectForKey:@"image1"];//[UIImage imageNamed:@"pkm_logo"];//
        [self.viewBack addSubview:imgLogo];
        
        lblExchangVoucherCondition = [[UILabel alloc]initWithFrame:CGRectMake(70, 270, 200, 35)];
        lblExchangVoucherCondition.text = [json objectForKey:@"text6"];//@"HÃY ĐẾN UHOUSE ĐỂ TẬN HƯỞNG NIỀM VUI BẤT TẬN";
        lblExchangVoucherCondition.numberOfLines = 2;
        lblExchangVoucherCondition.textAlignment = NSTextAlignmentCenter;
        lblExchangVoucherCondition.font = [UIFont boldSystemFontOfSize:14];
        lblExchangVoucherCondition.textColor = [UIColor blackColor];
        [viewBack addSubview:lblExchangVoucherCondition];
        
        UIImageView * imageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight-150, 320, ScreenHeight - 330)];
        photourl = @"";
        //        imageBottom.image = [json objectForKey:@"image2"];//[UIImage imageNamed:@"pkm_hinhduoi"];
        [imageBottom setImageWithURL:[NSURL URLWithString:photourl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [viewBack addSubview:imageBottom];
        [viewBack addSubview:vMiddle];
    }
    UIImageView * imaLogo = [[UIImageView alloc]initWithFrame:CGRectMake(90, 0, 120, 120)];
    NSString * photourl = @"";
    [imaLogo setImageWithURL:[NSURL URLWithString:photourl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //    imaLogo.image =  [json objectForKey:@"image1"];//[UIImage imageNamed:@"pkm_logo"];
    [viewFront addSubview:imaLogo];
    
    UIImageView * imaTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 125, 320, 60)];
    photourl = @"";
    //    imaTop.image = [json objectForKey:@"image3"];;
    [imaTop setImageWithURL:[NSURL URLWithString:photourl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [viewFront addSubview:imaTop];
    
    UIImageView * imageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight-150, 320, ScreenHeight - 330)];
    photourl = @"";
    //    imaTop.image = [json objectForKey:@"image3"];;
    [imageBottom setImageWithURL:[NSURL URLWithString:photourl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //    imageBottom.image = [json objectForKey:@"image4"];//[UIImage imageNamed:@"pkm_hinhduoi"];
    [viewFront addSubview:imageBottom];
    
    UILabel * lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(15, 200, 290, 35)];
    lblAddress.font = [UIFont boldSystemFontOfSize:14];
    lblAddress.textAlignment = NSTextAlignmentCenter;
    lblAddress.numberOfLines = 2;
    lblAddress.text = [json objectForKey:@"text7"];//@"Số 1, Công Trường Quốc Tế, Phường 6, Quận 3, TP.Hồ Chí Minh";
    [viewFront addSubview:lblAddress];
    
    UILabel * lblSubAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 320, 35)];
    lblSubAddress.font = [UIFont systemFontOfSize:14];
    lblSubAddress.text = [json objectForKey:@"text8"];//@"(Vòng xoay Hồ Con Rùa)";
    lblSubAddress.textAlignment = NSTextAlignmentCenter;
    [viewFront addSubview:lblSubAddress];
    
    UILabel * lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 265, 320, 17)];
    lblPhone.font = [UIFont boldSystemFontOfSize:14];
    lblPhone.text = F(@"Điện thoại: %@",[json objectForKey:@"text9"]);//@"Điện thoại: 08 3827 0708";
    lblPhone.textAlignment = NSTextAlignmentCenter;
    [viewFront addSubview:lblPhone];
    
    UILabel * lblSubPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 290, 320, 17)];
    lblSubPhone.font = [UIFont boldSystemFontOfSize:14];
    lblSubPhone.text =  F(@"Hotline: %@",[json objectForKey:@"text10"]);//[json objectForKey:@"text10"];//@"Hotline: 0934 544 758";
    lblSubPhone.textAlignment = NSTextAlignmentCenter;
    [viewFront addSubview:lblSubPhone];
    
    //    imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    imgBack.contentMode = UIViewContentModeScaleAspectFit;
    //    [viewBack addSubview:imgBack];
    //
    //    imgFront = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    imgFront.contentMode = UIViewContentModeScaleAspectFit;
    //    [viewFront addSubview:imgFront];
    
    //    NSString *photourl =F(@"%@%@%@%@", [[WorkWithServer shareInstance] getIP], PORT, URL_IMAGE, pCard.strImageView1);
    //    NSString *photourl2 =F(@"%@%@%@%@", [[WorkWithServer shareInstance] getIP], PORT, URL_IMAGE, pCard.strImageView2);
    //
    //    [imgBack setImageWithURL:[NSURL URLWithString:photourl]
    // usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //
    //    [imgFront setImageWithURL:[NSURL URLWithString:photourl2]
    //  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    viewFront.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(flipViews2)
                                   userInfo:Nil
                                    repeats:NO];
    //    [self flipViews2];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
