//
//  YJViewController.m
//  YJThief
//
//  Created by Zyj163 on 08/09/2017.
//  Copyright (c) 2017 Zyj163. All rights reserved.
//

#import "YJViewController.h"
#import "UIWindow+YJExtension.h"
#import "UIViewController+YJNavLoading.h"

@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self yj_setTitle:@"托尔斯泰"];
	
	NSLog(@"%@", getCurrentVC(getCurrentWindow()));
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOnCover:) name:UIWindowClickOnAnimationContainer object:nil];
}

- (IBAction)popoverView:(UIBarButtonItem *)sender {
	UIView *testView = [UIView new];
	testView.backgroundColor = [UIColor redColor];
	testView.layer.anchorPoint = CGPointMake(0.5, 0.5);
	testView.layer.bounds = CGRectMake(0, 0, 0, 0);
	testView.layer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
	
	[getCurrentWindow() showInDuration:0.25 withAnimation:^(UIView *container) {
		[container addSubview:testView];
		[UIView animateWithDuration:0.25 animations:^{
			testView.layer.bounds = CGRectMake(0, 0, 200, 200);
		}];
	}];
}

- (void)clickOnCover:(NSNotification *)notify
{
	NSLog(@"%@", notify);
	[getCurrentWindow() dismissInDuration:0.25 withAnimation:^(UIView *container) {
		[UIView animateWithDuration:0.25 animations:^{
			container.subviews[0].layer.bounds = CGRectMake(0, 0, 0, 0);
		}];
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//	UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//	v.tintColor = [UIColor redColor];
//	self.loading ? [self stopLoading] : [self startLoadingByActivityIndicatorView:(UIView<YJNavLoading> *)v];
	
	self.loading ? [self stopLoading] : [self startLoading];
}

@end
