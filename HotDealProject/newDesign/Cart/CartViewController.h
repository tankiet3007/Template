//
//  CartViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol ShoppingCartDelegate;
@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UITextFieldDelegate>
//{
//    id<ShoppingCartDelegate> delegate;
//}
//@property id<ShoppingCartDelegate>delegate;
@property(nonatomic,strong)UITableView * tableViewProduct;
@property(nonatomic,strong)NSMutableArray * arrProduct;
@end
//@protocol ShoppingCartDelegate <NSObject>
//-(void)updateTotal;
//@end
