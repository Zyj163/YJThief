//
//  YJInnerViewController.m
//  YJThief
//
//  Created by ddn on 2017/8/9.
//  Copyright © 2017年 Zyj163. All rights reserved.
//

#import "YJInnerViewController.h"
#import "YJTimerManager.h"

@interface YJInnerViewController () <YJTimerManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;

@end

@implementation YJInnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	__weak typeof(self) ws = self;
	
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"one").delegate(ws).resume();
	}];
	
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"two").duration(60).interval(0.1).handler(^(NSString *key, NSInteger time){
			ws.labelTwo.text = [NSString stringWithFormat:@"%zd", time];
		});
	}];
	
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"three").duration(60).handler(^(NSString *key, NSInteger time){
			ws.labelThree.text = [NSString stringWithFormat:@"%zd", time];
		});
	}];
	
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"four").handler(^(NSString *key, NSInteger time){
			ws.labelFour.text = [NSString stringWithFormat:@"%zd", time];
		});
	}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	__weak typeof(self) ws = self;
	//更换handler
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"four").handler(^(NSString *key, NSInteger time){
			ws.labelFour.text = [NSString stringWithFormat:@"%zd", time];
		});
	}];
}

- (void)dealloc
{
	[YJTimerManager does:^(YJTimerMaker *maker) {
		maker.key(@"one").key(@"four").stop();
	}];
}

#pragma mark - delegate
- (void)timer:(NSString *)key didChanged:(NSInteger)time
{
	if ([key isEqualToString:@"one"]) {
		self.labelOne.text = [NSString stringWithFormat:@"%zd", time];
	}
}

- (void)timerDidResumed:(NSString *)key
{
	NSLog(@"%@==timerDidResumed", key);
}

- (void)timerWillStop:(NSString *)key
{
	NSLog(@"%@==timerWillStop", key);
}

@end
