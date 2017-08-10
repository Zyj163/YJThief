//
//  UIViewController+YJNavLoading.m
//  yyox
//
//  Created by ddn on 2017/1/10.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "UIViewController+YJNavLoading.h"
#import "UIView+YJLayout.h"
#import <objc/runtime.h>

@implementation UIViewController (YJAddProperty)

- (void)yj_setTitle:(NSString *)title
{
	[self yj_setTitle:title color:self.navigationController.navigationBar.barTintColor font:self.navigationController.navigationBar.titleTextAttributes[NSFontAttributeName]];
}

- (void)yj_setTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font
{
	UIView *titleView = [UIView new];
	UILabel *label = nil;
	if (self.navigationItem.titleView) {
		label = objc_getAssociatedObject(titleView, "titleLabel");
	}
	
	if (!label) {
		label = [UILabel new];
		label.textColor = color;
		label.textAlignment = NSTextAlignmentCenter;
		label.font = font;
		
		[titleView addSubview:label];
		
		objc_setAssociatedObject(titleView, "titleLabel", label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	label.text = title;
	titleView.yj_h = 44;
	
	[label sizeToFit];
	label.yj_h = 44;
	label.yj_x = 0;
	
	titleView.yj_w = label.yj_w;
	
	self.navigationItem.titleView = titleView;
}

- (BOOL)loading
{
	UIView<YJNavLoading> *indicatorView;
	for (UIView *view in self.navigationItem.titleView.subviews) {
		if ([view respondsToSelector:@selector(startAnimating)] && [view respondsToSelector:@selector(stopAnimating)] && [view respondsToSelector:@selector(isAnimating)]) {
			indicatorView = (UIView<YJNavLoading> *)view;
			break;
		}
	}
	if(!indicatorView) indicatorView = objc_getAssociatedObject(self.navigationItem.titleView, "indicatorView");
	return indicatorView ? indicatorView.isAnimating : NO;
}

- (void)startLoading
{
	[self startLoadingByActivityIndicatorView:nil];
}

- (void)startLoadingByActivityIndicatorView:(UIView<YJNavLoading> *)activityIndicatorView
{
	if (!self.navigationItem.titleView) return;
	if (!activityIndicatorView) {
		activityIndicatorView = objc_getAssociatedObject(self.navigationItem.titleView, "indicatorView");
		if (!activityIndicatorView) {
			activityIndicatorView = (UIView<YJNavLoading> *)[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			
			objc_setAssociatedObject(self.navigationItem.titleView, "indicatorView", activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
	}
	activityIndicatorView.hidesWhenStopped = YES;
	
	for (UIView *view in self.navigationItem.titleView.subviews) {
		if ([view respondsToSelector:@selector(startAnimating)] && [view respondsToSelector:@selector(stopAnimating)] && [view respondsToSelector:@selector(isAnimating)]) {
			[view removeFromSuperview];
			break;
		}
	}
	
	[self.navigationItem.titleView addSubview:activityIndicatorView];
	
	activityIndicatorView.yj_size = CGSizeMake(44, 44);
	activityIndicatorView.yj_origin = CGPointMake(0, 0);
	
	if (activityIndicatorView.isAnimating) return;
	[activityIndicatorView startAnimating];
	
	UILabel *label = objc_getAssociatedObject(self.navigationItem.titleView, "titleLabel");
	
	label.yj_x = CGRectGetMaxX(activityIndicatorView.frame);
	self.navigationItem.titleView.yj_w = 44 + label.yj_w;
}

- (void)stopLoading
{
	if (!self.navigationItem.titleView) return;
	
	UIView<YJNavLoading> *indicatorView;
	for (UIView *view in self.navigationItem.titleView.subviews) {
		if ([view respondsToSelector:@selector(startAnimating)] && [view respondsToSelector:@selector(stopAnimating)] && [view respondsToSelector:@selector(isAnimating)]) {
			indicatorView = (UIView<YJNavLoading> *)view;
			break;
		}
	}
	
	if (!indicatorView) indicatorView = objc_getAssociatedObject(self.navigationItem.titleView, "indicatorView");
	if (!indicatorView) return;
	if (!indicatorView.isAnimating) return;
	[indicatorView stopAnimating];
	[indicatorView removeFromSuperview];
	UILabel *label = objc_getAssociatedObject(self.navigationItem.titleView, "titleLabel");
	
	label.yj_x = 0;
	self.navigationItem.titleView.yj_w = label.yj_w;
}

@end
