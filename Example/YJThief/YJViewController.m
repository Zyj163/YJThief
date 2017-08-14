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
@property (weak, nonatomic) IBOutlet UIView *lineLayoutView1;
@property (weak, nonatomic) IBOutlet UIScrollView *lineLayoutView2;
@property (weak, nonatomic) IBOutlet UIView *lineLayoutView3;
@property (weak, nonatomic) IBOutlet UIView *lineLayoutView4;

@property (strong, nonatomic) NSMutableArray *svs;

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
	_svs = [NSMutableArray array];
	for (NSInteger i=0; i<4; i++) {
		UIView *view1 = [UIView new];
		UIView *view2 = [UIView new];
		UIView *view3 = [UIView new];
		UIView *view4 = [UIView new];
		
		[_lineLayoutView1 addSubview:view1];
		[_lineLayoutView2 addSubview:view2];
		[_lineLayoutView3 addSubview:view3];
		[_lineLayoutView4 addSubview:view4];
		
		[_svs addObject:view2];
	}
	
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	[_lineLayoutView1 yj_lineLayout:_lineLayoutView1.subviews withPadding:UIEdgeInsetsMake(5, 5, 5, 5) andSpace:5 withSetting:^(NSInteger idx, UIView *view) {
		view.backgroundColor = [UIColor redColor];
	}];
	
	[_lineLayoutView2 yj_lineButNoEqualWithLayout:_svs withPadding:UIEdgeInsetsMake(5, 5, 5, 5) andSpace:5 withSetting:^(NSInteger idx, UIView *view) {
		view.backgroundColor = [UIColor blueColor];
		view.bounds = (CGRect){CGPointZero, CGSizeMake(self.view.bounds.size.width / 5 + idx * 15, 0)};
	}];
	
	[_lineLayoutView3 yj_vlineLayout:_lineLayoutView3.subviews withPadding:UIEdgeInsetsMake(5, 5, 5, 5) andSpace:5 withSetting:^(NSInteger idx, UIView *view) {
		view.backgroundColor = [UIColor orangeColor];
	}];
	
	[_lineLayoutView4 yj_vlineButNoEqualWithLayout:_lineLayoutView4.subviews withPadding:UIEdgeInsetsMake(5, 5, 5, 5) andSpace:5 withSetting:^(NSInteger idx, UIView *view) {
		view.backgroundColor = [UIColor whiteColor];
		view.bounds = (CGRect){CGPointZero, CGSizeMake(0, _lineLayoutView4.bounds.size.height / 6 + idx * 15)};
	}];
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
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOnCover:) name:YJWindowClickOnAnimationContainer object:nil];
	}];
}

- (void)clickOnCover:(NSNotification *)notify
{
	[yj_getCurrentWindow() yj_dismissInDuration:0.25 withAnimation:^(UIView *container) {
		[UIView animateWithDuration:0.25 animations:^{
			container.subviews[0].layer.bounds = CGRectMake(0, 0, 0, 0);
		}];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:YJWindowClickOnAnimationContainer object:nil];
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
