//
//  SNImagePickerNC.h
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNAssetsVC.h"

#define APP_DELEGATE ((SNAppDelegate*) ([UIApplication sharedApplication].delegate))

typedef enum{
    kPickerTypePhoto,
    kPickerTypeMovie
}SNPickerType;

@class SNImagePickerNC;
@protocol SNImagePickerDelegate <NSObject>
- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info;
- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker;
@end

@interface SNImagePickerNC : UINavigationController


@property (weak, nonatomic) id<SNImagePickerDelegate> imagePickerDelegate;
@property (nonatomic) SNPickerType pickerType;

@end
