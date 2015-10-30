//
//  SearchViewController.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/29/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize historySearchList;
@synthesize tableviewSearch;
@synthesize tfSearch;
@synthesize isShowHistory;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHex:@"#F5F5F5" alpha:1];
    [self initTableViewFilter];
    [self initData];
    [self initNavigationBar];
    isShowHistory = TRUE;
}

-(void)initNavigationBar
{
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"Huỷ" forState:UIControlStateNormal];
    [cancel setFrame:CGRectMake(0, 0, 50, 30)];
    [cancel.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    self.navigationItem.leftBarButtonItem = barItem;
    
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setFrame:CGRectMake(0, 0, 50, 30)];
    [search.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [search setTitle:@"Tìm" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:search];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:rightButton,nil];
    [self.navigationItem setRightBarButtonItems:myButtonArray];
    
    tfSearch = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 22)];
    tfSearch.placeholder = @"Nhập từ khoá tìm kiếm";
    [tfSearch setFont:[UIFont systemFontOfSize:14]];
    tfSearch.textColor = [UIColor blackColor];
    tfSearch.textAlignment = NSTextAlignmentLeft;
    tfSearch.delegate = self;
    tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfSearch.returnKeyType = UIReturnKeyDone;
    [tfSearch becomeFirstResponder];
    self.navigationItem.titleView = tfSearch;
}

-(void)search
{
    [tfSearch resignFirstResponder];
    [self saveHistoryList:tfSearch.text];
    tableviewSearch.hidden = YES;
//    [tableviewSearch reloadData];
//    [self loadHistory];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL) textFieldShouldClear:(UITextField *)textField{
    [self loadHistory];
    [textField resignFirstResponder];
    return YES;
}
-(void)backbtn_click:(id)sender
{
    [tfSearch resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData
{
    [self loadHistory];
   
//    historySearchList = [[NSMutableArray alloc]init];
//    [historySearchList addObject:@"1"];
//    [historySearchList addObject:@"2"];
//    [historySearchList addObject:@"3"];
//    [historySearchList addObject:@"4"];
}
-(void)saveHistoryList:(NSString *)newKeyword
{
    if (newKeyword!= nil && ![newKeyword.trim isEqualToString:@""]) {
        if ([historySearchList containsObject:newKeyword]) {
            ALERT(@"Thông báo", @"Từ khoá đã tồn tại");
            return;
        }
        [historySearchList addObject:newKeyword];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:historySearchList forKey:@"historySearchList"];
        [defaults synchronize];
    }
   
}
-(void)loadHistory
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray * history = [ud objectForKey:@"historySearchList"];
    UA_log(@"%@", history);
    historySearchList = [NSMutableArray arrayWithArray:history];
    
    if ([historySearchList count] == 0) {
        tableviewSearch.hidden = YES;
    }
    else
    {
        tableviewSearch.hidden = NO;
        [tableviewSearch reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTableViewFilter
{
    tableviewSearch = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableviewSearch];
    tableviewSearch.backgroundColor = [UIColor whiteColor];
    tableviewSearch.dataSource = self;
    tableviewSearch.delegate = self;
    tableviewSearch.separatorColor = [UIColor clearColor];
    tableviewSearch.showsVerticalScrollIndicator = NO;
    tableviewSearch.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historySearchList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [historySearchList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    vHeader.backgroundColor =[UIColor colorWithHex:@"#F1F2F3" alpha:1];
    UILabel * headerName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    headerName.textColor = [UIColor blackColor];
    if (isShowHistory) {
        headerName.text = @"LỊCH SỬ TÌM KIẾM";
        UIButton * clear = [UIButton buttonWithType:UIButtonTypeCustom];
        [clear setFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 80, 30)];
        [clear.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [clear addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        [clear setTitle:@"Xoá lịch sử" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [vHeader addSubview:clear];
    }
    else
    {
        headerName.text = @"TỪ KHOÁ THÔNG DỤNG";
    }
    headerName.font  = [UIFont boldSystemFontOfSize:13];
    headerName.textAlignment = NSTextAlignmentLeft;
    [vHeader addSubview:headerName];
    
    
    return vHeader;
}
-(void)clearHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"historySearchList"];
    [self loadHistory];
    [tableviewSearch reloadData];
}
@end
