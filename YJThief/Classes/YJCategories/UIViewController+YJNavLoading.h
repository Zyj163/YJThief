//
//  UIViewController+YJNavLoading.h
//  yyox
//
//  Created by ddn on 2017/1/10.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJNavLoading <NSObject>

@property (assign, nonatomic, getter=isAnimating) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end

@interface UIViewController (YJNavLoading)

- (void)yj_setTitle:(NSString *)title;
- (void)yj_setTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font;

- (void)yj_startLoadingByActivityIndicatorView:(UIView<YJNavLoading> *)activityIndicatorView;

- (void)yj_startLoading;

- (void)yj_stopLoading;

@property (assign, nonatomic, readonly) BOOL yj_loading;
@property (assign, nonatomic, readonly) CGSize yj_activityIndicatorViewSize;

@end
