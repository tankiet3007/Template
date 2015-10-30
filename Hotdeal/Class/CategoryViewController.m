//
//  CategoryViewController.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "DetailDealViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithProductID:(int)idItem withTitle:(NSString *)title {
    self = [super init];
    if(self) {
        productID = idItem;
        self.titleCategory = title;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    totalItemInRow = 2;
    limitProductGet = 10;
    
    tableCategoryView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tableCategoryView.backgroundColor = [UIColor whiteColor];//
    tableCategoryView.dataSource = self;
    tableCategoryView.delegate = self;
    tableCategoryView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableCategoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableCategoryView];
    
    UIView *hearder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    tableCategoryView.tableHeaderView = hearder;
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    tableCategoryView.tableHeaderView = footer;
    
    [self getDataCategoryWithId:productID withOffset:0 withLimit:limitProductGet];
    [self initNavigationBar];
}

-(void)initNavigationBar
{
    AppDelegate * app = [AppDelegate sharedDelegate];
    [app initNavigationbar:self withTitle:self.titleCategory];
}
-(void)backbtn_click
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Action

- (void)opendDetailDeal:(NSNumber *)indexItem {
    ProductObj *item = [_dataSource objectAtIndex:[indexItem intValue]];
    DetailDealViewController *aVC = [[DetailDealViewController alloc] initWithProduct:item];
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - API

-(void)getDataCategoryWithId:(int)idProduct withOffset:(int)offset withLimit:(int)limit {
    
    [AppDelegate showGlobalProgressHUDWithTitle:@""];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + [AppDelegate sharedDelegate].distanTimeServer;
    NSString *signAPI = [[AppDelegate sharedDelegate] getSignAPI:currentDate withAPIName:kBOGetProductInCategory];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetProductInCategory forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    [param setObject:[NSNumber numberWithInt:[locationStored.locationID intValue]] forKey:@"stateId"];
    [param setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
    [param setObject:[NSNumber numberWithInt:limit] forKey:@"limit"];
    [param setObject:[NSNumber numberWithInt:idProduct] forKey:@"categoryId"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSArray *dataGet = [[json objectForKey:@"data"] objectForKey:@"listProduct"];
            totalProduct = [[[json objectForKey:@"data"] objectForKey:@"total"] intValue];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                [AppDelegate dismissGlobalHUD];
                if(offset == 0) {
                    if(self.dataSource) {
                        self.dataSource = nil;
                    }
                    self.dataSource = [[NSMutableArray alloc]init];
                }
                
                for(int i = 0; i < [dataGet count];i++) {
                    NSDictionary *item = [dataGet objectAtIndex:i];
                    ProductObj *category = [[ProductObj alloc]initWithData:item];
                    [_dataSource addObject:category];
                }
                [tableCategoryView reloadData];
                isLoadMore = NO;
            });
            
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        isLoadMore = NO;
        NSLog(@"error message %s = %@", __PRETTY_FUNCTION__, error.localizedDescription);
    }];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = _dataSource!=nil?((int)[_dataSource count]/totalItemInRow+[_dataSource count]%totalItemInRow):0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"HomePageCell";
    static NSString *cellIdentifier = @"HomePageDealCell";
    
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier numberItem:totalItemInRow];
        cell.rootView = self;
    }
    NSMutableArray *dataSetup = [[NSMutableArray alloc] init];
    for(int i = 0;i < totalItemInRow;i++) {
        int indexGet = (int)indexPath.row*totalItemInRow + i;
        if(indexGet < [_dataSource count]) {
            [dataSetup addObject:[_dataSource objectAtIndex:indexGet]];
        }
    }
    if([dataSetup count] > 0) {
        [cell setupDataForeCell:dataSetup withStartIndex:((int)indexPath.row*totalItemInRow)];
    }
    
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.layer.shouldRasterize = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (((indexPath.row + 1) * totalItemInRow) >= ([_dataSource count]) && isLoadMore == NO && [_dataSource count] < totalProduct)
    {
        isLoadMore = YES;
        [self getDataCategoryWithId:productID withOffset:((int)[_dataSource count]-1) withLimit:limitProductGet];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 236;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ProductObj *item = [_dataSource objectAtIndex:indexPath.row];
//    DetailDealViewController *aVC = [[DetailDealViewController alloc] initWithProduct:item];
//    [self.navigationController pushViewController:aVC animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
