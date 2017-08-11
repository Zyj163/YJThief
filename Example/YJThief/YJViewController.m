//
//  YJViewController.m
//  YJThief
//
//  Created by Zyj163 on 08/09/2017.
//  Copyright (c) 2017 Zyj163. All rights reserved.
//

#import "YJViewController.h"
#import "YJCategories.h"
#import "YJImagePickerManager.h"
#import "Masonry.h"

@interface YJViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self yj_setTitle:@"托尔斯泰"];
	
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor redColor];
	view.bounds = CGRectMake(0, 0, 40, 40);
	_textField.yj_attachedView = view;
	
	NSLog(@"%@", yj_getCurrentVC(yj_getCurrentWindow()));
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOnCover:) name:YJWindowClickOnAnimationContainer object:nil];
}

- (IBAction)popoverView:(UIBarButtonItem *)sender {
	UIView *testView = [UIView new];
	testView.backgroundColor = [UIColor redColor];
	testView.layer.anchorPoint = CGPointMake(0.5, 0.5);
	testView.layer.bounds = CGRectMake(0, 0, 0, 0);
	testView.layer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
	
	[yj_getCurrentWindow() yj_showInDuration:0.25 withAnimation:^(UIView *container) {
		[container addSubview:testView];
		[UIView animateWithDuration:0.25 animations:^{
			testView.layer.bounds = CGRectMake(0, 0, 200, 200);
		}];
	}];
}

- (void)clickOnCover:(NSNotification *)notify
{
	NSLog(@"%@", notify);
	[yj_getCurrentWindow() yj_dismissInDuration:0.25 withAnimation:^(UIView *container) {
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
	self.yj_loading ? [self yj_stopLoading] : [self yj_startLoading];
	
	
//	BOOL v = [self.textField yj_typeIsVisiable:YJAttachedViewShowTypeCustom];
//	!v ? [self.textField show:YJAttachedViewShowTypeCustom] : [self.textField hide:YJAttachedViewShowTypeCustom];
	
	YJAttachedViewShowType type = [self.textField yj_currentShowType];
	if (type == YJAttachedViewShowTypeCustom) {
		[self.textField yj_show:YJAttachedViewShowTypeError];
	} else {
		[self.textField yj_show:YJAttachedViewShowTypeCustom];
	}
}

@end
