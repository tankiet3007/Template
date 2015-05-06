//
//  EmailPromotionViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProvineDelegate;
@interface EmailPromotionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<ProvineDelegate> delegate;
}
@property id<ProvineDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableProvine;

@end
@protocol ProvineDelegate <NSObject>
-(void)updateProvine;
@end