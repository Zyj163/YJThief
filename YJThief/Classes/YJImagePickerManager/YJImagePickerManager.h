//
//  YJImagePickerManager.h
//  yyox
//
//  Created by ddn on 2017/1/22.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJResponseModel.h"
#import "YJSingleton.h"

@interface YJImagePickerManager : NSObject

YJSingleton_h(ImagePickerManager)

+ (void)showImagePicker:(void(^)(YJResponseModel *))callback fromController:(UIViewController *)vc;

+ (void)scaleImage:(UIImage *)image toSize:(CGFloat)size callback:(void(^)(YJResponseModel *))callback;

@end
