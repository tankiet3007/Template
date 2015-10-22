//
//  CollectionMenu.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/21/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import "CollectionMenu.h"
#import "Appdelegate.h"
@interface CollectionMenu ()

@end

@implementation CollectionMenu
@synthesize collectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationbar];
    [self initCollectionView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backbtn_click:(id)sender
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Danh Mục"];
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(100, 100);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 80, ScreenWidth-10, ScreenHeight-110) collectionViewLayout:flowLayout];
    collectionView.scrollEnabled = NO;
    
    collectionView.alwaysBounceVertical = YES;
    [collectionView registerNib:[UINib nibWithNibName:@"VTVHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VTVHomeCollectionViewCell"];
    [collectionView setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:1]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"VTVHomeCollectionViewCell";
//    VTVHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.imgLogo.layer.cornerRadius = 15;
//    cell.imgLogo.layer.masksToBounds = YES;
//    cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
//    cell.imgLogo.image = [UIImage imageNamed:@""]];
//    cell.lblTitle.text = @"Something";
//    return cell;
    return nil;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 120);
}

@end
