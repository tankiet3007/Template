//
//  ImageSlide.m
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import "ImageSlide.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation ImageSlide
{
    int currentPage;
    CGRect oldRect;
    BOOL isFullscreen;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentPage = 0;
        oldRect = frame;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
//        tapGesture.numberOfTapsRequired = 2;
//        [self addGestureRecognizer:tapGesture];

        
    }
    return self;
}

-(void)initScroll2
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    //    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0 + self.frame.size.height -10, self.frame.size.width, 30)];
    _pageControl.hidden = NO;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    //    _pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:_pageControl];

    
    for (int i = 0; i < [_galleryImages count]; i++) {//arr object with link and image
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
//        NSString *filePath = [_galleryImages objectAtIndex:i];
        NSString * urlImage = @"";
        
        NSString *photourl;
        if ([urlImage containsString:@"http://"]||[urlImage containsString:@"https://"]) {
            photourl = urlImage;
        }

        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        button.tag = i;
        [button addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.0f;
        button.frame = scrollView.bounds;
        [scrollView addSubview:button];
        
         [button sd_setImageWithURL:[NSURL URLWithString:photourl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_loading_sun_2"]];
        [_scrollView addSubview:scrollView];
//        }
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture2)];
    tapGesture.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:tapGesture];

    
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [_galleryImages count], _scrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.galleryImages count];
    _scrollView.delegate = self;
    
}
//@"1",@"type", @"http://tuyn.info/data/video2.mp4", @"linkType",@"action_2.2.png", @"urlImage", nil];
-(void)initScrollLocal2
{
    //    [[NSTimer scheduledTimerWithTimeInterval:3
    //                                      target:self
    //                                    selector:@selector(scrollPages)
    //                                    userInfo:Nil
    //                                     repeats:YES] fire];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    //    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0 + self.frame.size.height-30, self.frame.size.width, 30)];
    _pageControl.hidden = NO;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    //    _pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    for (int i = 0; i < [_galleryImages count]; i++) {
        NSString * urlImage = [_galleryImages objectAtIndex:i];
        
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        NSString *filePath = urlImage;
        UIImage *imageT = [UIImage imageNamed:filePath];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button setImage:imageT forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(topCellClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.0f;
        button.frame = scrollView.bounds;
        [scrollView addSubview:button];
        
        
        [_scrollView addSubview:scrollView];
    }
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [_galleryImages count], _scrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.galleryImages count];
    _scrollView.delegate = self;
    
}

-(void)topCellClick:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    long index = (long)btnSelected.tag;
    UA_log(@"%ld",index);
    [self.delegate topCellClick:index];
}
//@"1",@"type", @"http://tuyn.info/data/video2.mp4", @"linkType",@"action_2.2.png", @"urlImage", nil];
-(void)showMessage:(id)sender
{
}
-(void)scrollPages{
    [self scrollToPage:currentPage%[self.galleryImages count]];
    currentPage++;
}

-(void)initScroll
{
//    [self initScroll2];
//    return;
    //    [[NSTimer scheduledTimerWithTimeInterval:3
    //                                      target:self
    //                                    selector:@selector(scrollPages)
    //                                    userInfo:Nil
    //                                     repeats:YES] fire];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    //    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0 + self.frame.size.height -10, self.frame.size.width, 30)];
    _pageControl.hidden = NO;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    //    _pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    for (int i = 0; i < [_galleryImages count]; i++) {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        NSString *filePath = [_galleryImages objectAtIndex:i];
        NSString * strStandarURL = filePath;
        NSString *photourl;
        if ([strStandarURL containsString:@"http://"]||[strStandarURL containsString:@"https://"]) {
            photourl = strStandarURL;
        }
        
        UIImageView *imageView;
        imageView = [[UIImageView alloc] init];
        
        
        
//        NSString *filePath = [_galleryImages objectAtIndex:i];
//        UIImage *imageT = [UIImage imageWithContentsOfFile:filePath];
//        UIImageView *imageView;
//        imageView = [[UIImageView alloc] initWithImage:imageT];
        imageView.clipsToBounds = YES;
        imageView.tag = 1;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.0f;
        imageView.frame = scrollView.bounds;
        [scrollView addSubview:imageView];
        [imageView setImageWithURL:[NSURL URLWithString:photourl]
       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_scrollView addSubview:scrollView];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    tapGesture.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:tapGesture];
    
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [_galleryImages count], _scrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.galleryImages count];
    _scrollView.delegate = self;
    
}

-(void)handleTapGesture
{
    NSArray * arrSupView = [self subviews];
    for (UIView * vItem in arrSupView) {
        [vItem removeFromSuperview];

    }
    [self initScroll];
}

-(void)handleTapGesture2
{
    NSArray * arrSupView = [self subviews];
    for (UIView * vItem in arrSupView) {
        [vItem removeFromSuperview];
        
    }
    [self initScroll2];
}


-(void)scrollToPage:(NSInteger)aPage{
    float myPageWidth = [_scrollView frame].size.width;
    [_scrollView setContentOffset:CGPointMake(aPage*myPageWidth,_scrollView.frame.origin.y) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:1];
}

-(void)initScrollLocalForSetting:(int)indexSelected
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height)];
    //    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0 + self.frame.size.height-70, self.frame.size.width, 30)];
    _pageControl.hidden = NO;
    
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    
    //    _pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    for (int i = 0; i < [_galleryImages count]; i++) {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;
        NSString *filePath = [_galleryImages objectAtIndex:i];
        UIImage *imageT = [UIImage imageNamed:filePath];
        UIImageView *imageView;
        imageView = [[UIImageView alloc] initWithImage:imageT];
        imageView.clipsToBounds = YES;
        imageView.tag = 1;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-60)];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(frame.origin.x + ScreenWidth/2-80, scrollView.frame.size.height + 20, 160, 40);
        [button.layer setCornerRadius:5];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        
        if (i == indexSelected) {
            [button setTitle:@"ĐANG SỬ DỤNG" forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"XÁC NHẬN" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(configSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
        
        scrollView.delegate = self;
//        scrollView.maximumZoomScale = 1.8f;
        imageView.frame = scrollView.bounds;
        [scrollView addSubview:imageView];
        
        [_scrollView addSubview:scrollView];
    }
    _scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [_galleryImages count], _scrollView.frame.size.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.galleryImages count];
    _scrollView.delegate = self;
}
-(void)configSelected:(id)sender
{
    
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
