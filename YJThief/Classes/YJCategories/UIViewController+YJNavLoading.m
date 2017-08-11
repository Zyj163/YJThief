//
//  UIViewController+YJNavLoading.m
//  yyox
//
//  Created by ddn on 2017/1/10.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "UIViewController+YJNavLoading.h"
#import "YYCategories.h"
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
	titleView.left = 44;
	
	[label sizeToFit];
	label.height = 44;
	label.left = 0;
	
	titleView.width = label.width;
	
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

- (CGSize)activityIndicatorViewSize
{
	return CGSizeMake(30, 40);
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
	
	for (UIView *view in self.navigationItem.titleView.subviews) {
		if ([view respondsToSelector:@selector(startAnimating)] && [view respondsToSelector:@selector(stopAnimating)] && [view respondsToSelector:@selector(isAnimating)]) {
			[view removeFromSuperview];
			break;
		}
	}
	
	[self.navigationItem.titleView addSubview:activityIndicatorView];
	
	activityIndicatorView.size = self.activityIndicatorViewSize;
	activityIndicatorView.origin = CGPointMake(0, 0);
	
	if (activityIndicatorView.isAnimating) return;
	[activityIndicatorView startAnimating];
	
	UILabel *label = objc_getAssociatedObject(self.navigationItem.titleView, "titleLabel");
	
	label.left = CGRectGetMaxX(activityIndicatorView.frame);
	self.navigationItem.titleView.width = self.activityIndicatorViewSize.width + label.width;
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
	
	label.left = 0;
	self.navigationItem.titleView.width = label.width;
}

@end
