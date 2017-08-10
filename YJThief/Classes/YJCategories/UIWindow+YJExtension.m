//
//  UIWindow+YJExtension.m
//  yyox
//
//  Created by ddn on 2017/1/12.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "UIWindow+YJExtension.h"
#import <objc/runtime.h>

NSString *const UIWindowClickOnAnimationContainer = @"UIWindowClickOnAnimationContainer";

NSString *const DidAddSubviewToWindow = @"DidAddSubviewToWindow";
NSString *const DidAddSubviewToWindowKey = @"DidAddSubviewToWindowKey";

@implementation UIWindow (YJExtension)

- (void)setContainerView:(UIButton *)containerView
{
	[self willChangeValueForKey:@"containerView"];
	objc_setAssociatedObject(self, _cmd, containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"containerView"];
}

- (UIButton *)containerView
{
	return objc_getAssociatedObject(self, @selector(setContainerView:));
}

- (void)setShown:(BOOL)shown
{
	[self willChangeValueForKey:@"shown"];
	objc_setAssociatedObject(self, _cmd, @(shown), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"shown"];
}

- (BOOL)shown
{
	NSNumber *s = objc_getAssociatedObject(self, @selector(setShown:));
	if (!s) {
		[self setShown:NO];
		return NO;
	}
	return s.boolValue;
}

+ (void)load
{
	Method oriMethod = class_getInstanceMethod(self, @selector(didAddSubview:));
	Method myMethod = class_getInstanceMethod(self, @selector(my_didAddSubview:));
	
	method_exchangeImplementations(oriMethod, myMethod);
}

- (void)my_didAddSubview:(UIView *)subview
{
	if (![self respondsToSelector:@selector(my_didAddSubview:)]) return;
	[self my_didAddSubview:subview];
	
	[[NSNotificationCenter defaultCenter]postNotificationName:@"DidAddSubviewToWindow" object:nil userInfo:@{DidAddSubviewToWindowKey : subview}];
}

UIWindow *getCurrentWindow ()
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	UIWindow *tmpWin;
	for(NSInteger i = windows.count - 1; i >= 0; i --)
		{
		tmpWin = windows[i];
		if (tmpWin.windowLevel == UIWindowLevelNormal && tmpWin.rootViewController)
			{
			return tmpWin;
			}
		}
	return nil;
}

UIViewController *getCurrentVC (UIWindow *window)
{
	if (!window) {
		window = getCurrentWindow();
	}
	UIViewController *result = nil;
	
	id nextResponder = nil;
	UIView *frontView = nil;
	
	for (NSInteger i = window.subviews.count - 1; i >= 0; i --) {
		
		frontView = window.subviews[i];
		if ([frontView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
			frontView = [frontView.subviews lastObject];
		}
		nextResponder = [frontView nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]])
			result = nextResponder;
		else {
			frontView = nil;
			continue;
		}
		result = topViewController(result);
		break;
	}
	if (frontView == nil) {
		result = window.rootViewController;
		result = topViewController(result);
	}
	return result;
}

UIViewController *topViewController(UIViewController *result)
{
	if ([result isKindOfClass:[UINavigationController class]]) {
		result = [result valueForKeyPath:@"topViewController"];
	} else if ([result isKindOfClass:[UITabBarController class]]) {
		result = [result valueForKeyPath:@"selectedViewController"];
	} else {
		return result;
	}
	return topViewController(result);
}

- (void)clickOnContainer:(UIButton *)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:UIWindowClickOnAnimationContainer object:nil userInfo:nil];
}

- (UIView *)initialIfNotContainerView
{
	UIButton *containerView = [self containerView];
	if (!containerView) {
		containerView = [UIButton new];
		[self setContainerView:containerView];
		containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
		[containerView addTarget:self action:@selector(clickOnContainer:) forControlEvents:UIControlEventTouchUpInside];
	}
	return containerView;
}


- (void)showInDuration:(NSTimeInterval)duration withAnimation:(void (^)(UIView *))animation
{
	if (self.shown) return;
	UIView *containerView = [self initialIfNotContainerView];
	
	[self addSubview:containerView];
	[self bringSubviewToFront:containerView];
	containerView.frame = self.bounds;
	
	dispatch_group_t group = dispatch_group_create();
	
	dispatch_group_enter(group);
	
	dispatch_block_t finish = ^(){
		dispatch_group_leave(group);
	};
	
	animation(containerView);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		finish();
	});
	
	__weak typeof(self) ws = self;
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		__strong typeof(ws) self = ws;
		[self setShown:@(YES)];
	});
}

- (void)dismissInDuration:(NSTimeInterval)duration withAnimation:(void(^)(UIView *container))animation
{
	if (!self.shown) return;
	
	UIView *containerView = [self initialIfNotContainerView];
	
	dispatch_group_t group = dispatch_group_create();
	
	dispatch_group_enter(group);
	
	dispatch_block_t finish = ^(){
		dispatch_group_leave(group);
	};
	
	animation(containerView);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		finish();
	});
	
	__weak typeof(self) ws = self;
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		__strong typeof(ws) self = ws;
		[containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[containerView removeFromSuperview];
		[self setShown:NO];
	});
}

@end
