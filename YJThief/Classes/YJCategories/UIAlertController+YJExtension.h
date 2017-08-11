//
//  UIAlertController+YJExtension.h
//  yyox
//
//  Created by ddn on 2017/1/11.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (YJExtension)

+ (void)yj_showTitle:(NSString *)title message:(NSString *)message callback:(void(^)())callback;

+ (void)yj_showTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel sure:(NSString *)sure callback:(void(^)())callback;

+ (void)yj_showSheetTitle:(NSString *)title message:(NSString *)message actionNames:(NSArray<NSString *>*)actionNames callback:(void(^)(NSString *actionName))callback;

@end
