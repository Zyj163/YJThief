//
//  YJTimerButton.m
//  yyox
//
//  Created by ddn on 2017/1/6.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "YJTimerManager.h"

@interface YJTimerModel : NSObject

@property (weak, nonatomic) id<YJTimerManagerDelegate> delegate;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSTimeInterval interval;
@property (copy, nonatomic) YJTimerHandler handler;

@property (assign, nonatomic) BOOL system;

@end

@implementation YJTimerModel

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.duration = -1;
		self.interval = 1;
		self.handler = nil;
		self.time = -1;
	}
	return self;
}

@end

typedef enum : NSUInteger {
	YJTimerMakerControlResume,
	YJTimerMakerControlStop
} YJTimerMakerControl;

@interface YJTimerMaker()

@property (weak, nonatomic) id<YJTimerManagerDelegate> yj_delegate;
@property (assign, nonatomic) NSInteger yj_time;
@property (assign, nonatomic) NSTimeInterval yj_duration;
@property (assign, nonatomic) NSTimeInterval yj_interval;
@property (strong, nonatomic) NSMutableArray<NSString *> *yj_keys;
@property (copy, nonatomic) YJTimerHandler yj_handler;


@property (assign, nonatomic) BOOL yj_update_delegate;
@property (assign, nonatomic) BOOL yj_update_time;
@property (assign, nonatomic) BOOL yj_update_duration;
@property (assign, nonatomic) BOOL yj_update_interval;
@property (assign, nonatomic) BOOL yj_update_handler;


@property (assign, nonatomic) YJTimerMakerControl yj_control;

@end

@implementation YJTimerMaker

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.yj_delegate = nil;
		self.yj_duration = -1;
		self.yj_interval = 1;
		self.yj_keys = [NSMutableArray array];
		self.yj_handler = nil;
		self.yj_control = YJTimerMakerControlResume;
	}
	return self;
}

- (YJTimerModel *)makeModel:(YJTimerModel *)model
{
	if (!model) {
		model = [YJTimerModel new];
	}
	if (self.yj_update_delegate) model.delegate = self.yj_delegate;
	if (self.yj_update_duration) {
		if (model.duration != self.yj_duration) {
			model.time = (NSInteger)self.yj_duration;
		}
		model.duration = self.yj_duration;
	}
	if (self.yj_update_interval) {
		if (model.interval != self.yj_interval) {
			[model.timer invalidate];
			model.timer = nil;
		}
		model.interval = self.yj_interval;
	}
	if (self.yj_update_handler) model.handler = self.yj_handler;
	
	return model;
}

- (YJTimerMaker * (^)(NSString *key))key
{
	return ^id(NSString * key) {
		[self.yj_keys addObject:key];
		return self;
	};
}

- (YJTimerMaker * (^)(NSTimeInterval duration))duration
{
	return ^id(NSTimeInterval duration) {
		self.yj_update_duration = YES;
		self.yj_duration = duration;
		return self;
	};
}

- (YJTimerMaker * (^)(NSTimeInterval interval))interval
{
	return ^id(NSTimeInterval interval) {
		self.yj_update_interval = YES;
		self.yj_interval = interval;
		return self;
	};
}

- (YJTimerMaker * (^)(YJTimerHandler handler))handler
{
	return ^id(YJTimerHandler handler) {
		self.yj_update_handler = YES;
		self.yj_handler = handler;
		return self;
	};
}

- (YJTimerMaker * (^)(id<YJTimerManagerDelegate> delegate))delegate
{
	return ^id(id<YJTimerManagerDelegate> delegate) {
		self.yj_update_delegate = YES;
		self.yj_delegate = delegate;
		return self;
	};
}

- (YJTimerMaker * (^)())resume
{
	return ^id() {
		self.yj_control = YJTimerMakerControlResume;
		return self;
	};
}

- (YJTimerMaker * (^)())stop {
	return ^id() {
		self.yj_control = YJTimerMakerControlStop;
		return self;
	};
}

@end

@interface YJTimerManager()

@property (strong, nonatomic) NSMutableDictionary<NSString *, YJTimerModel *> *timers;

@end

@implementation YJTimerManager

YJSingleton_m(TimerManager)

+ (void)does:(void (^)(YJTimerMaker *))does
{
	YJTimerManager *mgr = [self sharedTimerManager];
	
	YJTimerMaker *maker = [YJTimerMaker new];
	does(maker);
	
	NSAssert(maker.yj_keys.count > 0, @"没有传入key值");
	
	[maker.yj_keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
		if (maker.yj_control == YJTimerMakerControlStop) {
			[mgr endForKey:key];
			return;
		}
		
		YJTimerModel *timerModel = mgr.timers[key];
		timerModel = [maker makeModel:timerModel];
		mgr.timers[key] = timerModel;
		
		if (!timerModel.timer || !timerModel.timer.isValid) {
			timerModel.timer = [NSTimer timerWithTimeInterval:timerModel.interval target:mgr selector:@selector(followTimer:) userInfo:@{@"key": key} repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timerModel.timer forMode:NSRunLoopCommonModes];
			if ([timerModel.delegate respondsToSelector:@selector(timerDidResumed:)]) {
				[timerModel.delegate timerDidResumed:key];
			}
		}
	}];
}


- (NSMutableDictionary *)timers
{
	if (!_timers) {
		_timers = [NSMutableDictionary dictionary];
	}
	return _timers;
}

- (void)endForKey:(NSString *)key
{
	YJTimerModel *timerModel = self.timers[key];
	if (timerModel) {
		if ([timerModel.delegate respondsToSelector:@selector(timerWillStop:)]) {
			[timerModel.delegate timerWillStop:key];
		}
		[timerModel.timer invalidate];
		[self.timers removeObjectForKey:key];
	}
}

- (void)followTimer:(NSTimer *)timer
{
	NSString *key = timer.userInfo[@"key"];
	if (!key) return;
	
	YJTimerModel *timerModel = self.timers[key];
	if (!timerModel) {
		return [timer invalidate];
	}
	
	timerModel.time --;
	id<YJTimerManagerDelegate> delegate = timerModel.delegate;
	if ([delegate respondsToSelector:@selector(timer:didChanged:)]) {
		[delegate timer:key didChanged:timerModel.time];
	}
	if (timerModel.handler) {
		timerModel.handler(key, timerModel.time);
	}
	
	if (timerModel.time == 0) {
		[self endForKey:key];
	}
}

- (void)dealloc
{
	[_timers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YJTimerModel * _Nonnull obj, BOOL * _Nonnull stop) {
		[self endForKey:key];
	}];
	[_timers removeAllObjects];
}

@end




