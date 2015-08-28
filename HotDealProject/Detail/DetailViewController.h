//
//  DetailViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/21/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSlide.h"
#import "DealObject.h"
#import "ShoppingCartController.h"
#import "CustomCollectionView.h"
#import "Payment/PaymentTemplate.h"
@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,slideImageDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,CustomCollectionViewDelegate, SNImagePickerDelegate, PaymentTemplateDelegate>
@property(nonatomic,strong)UITableView * tableViewDetail;
@property (nonatomic, strong)DealObject * dealObj;
@property (nonatomic,strong)NSMutableArray * arrDealRelateds;
@property (nonatomic, assign)int  iProductID;
@property (strong, nonatomic) SNImagePickerNC *imagePickerNavigationController;

@end
