//
//  UIBarButtonItem+YJExtension.h
//  yyox
//
//  Created by ddn on 2017/1/10.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YJExtension)

+ (UIBarButtonItem *)customView:(NSString *)imageName title:(NSString *)title withTarget:(id)target action:(SEL)action;
- (void)changeTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)customView:(NSString *)imageName title:(NSString *)title block:(void (^)(id sender))block;
- (void)changeBlock:(void (^)(id sender))block;

@end
