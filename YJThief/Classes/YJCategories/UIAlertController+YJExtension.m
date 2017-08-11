//
//  UIAlertController+YJExtension.m
//  yyox
//
//  Created by ddn on 2017/1/11.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "UIAlertController+YJExtension.h"
#import "YJCategories.h"

@implementation UIAlertController (YJExtension)

+ (void)yj_showTitle:(NSString *)title message:(NSString *)message callback:(void (^)())callback
{
	[self yj_showTitle:title message:message cancel:@"取消" sure:@"确定" callback:callback];
}

+ (void)yj_showTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel sure:(NSString *)sure callback:(void (^)())callback
{
	UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *cancelbtn = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertVc dismissViewControllerAnimated:YES completion:nil];
	}];
	UIAlertAction *surebtn = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		if (callback) {
			callback();
		}
	}];
	
	[alertVc addAction:cancelbtn];
	[alertVc addAction:surebtn];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[yj_getCurrentVC(yj_getCurrentWindow()) presentViewController:alertVc animated:YES completion:nil];
	});
}

+ (void)yj_showSheetTitle:(NSString *)title message:(NSString *)message actionNames:(NSArray<NSString *>*)actionNames callback:(void(^)(NSString *actionName))callback
{
	UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
	for (NSString *actionName in actionNames) {
		UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			if (callback) {
				callback(actionName);
			}
		}];
		[alertVc addAction:alertAction];
	}
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertVc dismissViewControllerAnimated:YES completion:nil];
	}];
	[alertVc addAction:cancel];
	dispatch_async(dispatch_get_main_queue(), ^{
		[yj_getCurrentVC(yj_getCurrentWindow()) presentViewController:alertVc animated:YES completion:nil];
	});
}

@end
