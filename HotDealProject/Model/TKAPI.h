//
//  TKAPI.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/16/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark for user
//get_location
static NSString * const URL_GET_LOCATION = @"http://dev.hotdeal.vn/mapi/get_location";
static NSString * const URL_SIGN_UP = @"http://dev.hotdeal.vn/mapi/sign-up";
static NSString * const URL_SIGN_IN = @"http://dev.hotdeal.vn/mapi/sign-in";
static NSString * const URL_CONNECT_SOCICAL = @"http://dev.hotdeal.vn/mapi/connect-socical";
static NSString * const URL_SIGN_OUT = @"http://dev.hotdeal.vn/mapi/sign-out";
static NSString * const URL_FORGOT_PASSWORD = @"http://dev.hotdeal.vn/mapi/reset-password";
static NSString * const URL_GET_USERINFO = @"http://dev.hotdeal.vn/mapi/get_user_info";//http://hotdeal.vn/mapi/update-user-info
static NSString * const URL_UPDATE_USER = @"http://dev.hotdeal.vn/mapi/update-user-info";
static NSString * const URL_CHANGE_PASSWORD = @"http://dev.hotdeal.vn/mapi/change-password";

#pragma mark for deal
static NSString * const URL_GET_ODER_LIST = @"http://dev.hotdeal.vn/mapi/get-order-list";
static NSString * const URL_DEAL_LIST = @"http://dev.hotdeal.vn/mapi/get-latest-deals";
static NSString * const URL_SEARCH_DEAL = @"http://dev.hotdeal.vn/mapi/get_latest_deals";//http://hotdeal.vn/mapi/get-deal-content

static NSString * const URL_GET_DEAL_CONTENT = @"http://dev.hotdeal.vn/mapi/get-deal-content";
static NSString * const URL_ADD_TO_CART = @"http://dev.hotdeal.vn/mapi/add_to_cart";
static NSString * const URL_LIST_CART = @"http://dev.hotdeal.vn/mapi/list_cart";

#pragma mark payment
static NSString * const URL_GET_PAYMENT_METHOD = @"http://dev.hotdeal.vn/mapi/get_payment_methods";
static NSString * const URL_GET_SHIPPING_METHOD = @"http://dev.hotdeal.vn/mapi/get_shipping_methods";
static NSString * const URL_UPDATE_CART = @"http://dev.hotdeal.vn/mapi/update_cart";
static NSString * const URL_GET_USER_POINT = @"http://dev.hotdeal.vn/mapi/get-user-points";
//http://hotdeal.vn/mapi/get-user-points
@interface TKAPI : NSObject


+ (TKAPI*)sharedInstance;
- (void)postRequestAF:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion;
+ (NSString *)postRequest:(NSDictionary *)params withURL:(NSString *)url;
- (void)getRequestAF:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion;
- (void)getRequest:(NSString *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion;
- (void)getRequestAFarr:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSArray*, NSError*))completion;
@end
