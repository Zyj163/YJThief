//
//  YJTimerManager.h
//  yyox
//
//  Created by ddn on 2017/1/6.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJSingleton.h"

typedef void(^YJTimerHandler)(NSString *key, NSInteger time);

@protocol YJTimerManagerDelegate <NSObject>

- (void)timer:(NSString *)key didChanged:(NSInteger)time;
- (void)timerWillStop:(NSString *)key;
- (void)timerDidResumed:(NSString *)key;

@end

@interface YJTimerMaker : NSObject

/**
 设置时长，如果与之前的值不同，会重新计时，默认无限制（小于0）
 */
- (YJTimerMaker * (^)(NSTimeInterval duration))duration;

/**
 设置周期，如果与之前的值不同，会重新初始化定时器，默认是1s
 */
- (YJTimerMaker * (^)(NSTimeInterval interval))interval;
- (YJTimerMaker * (^)(YJTimerHandler handler))handler;
- (YJTimerMaker * (^)(id<YJTimerManagerDelegate> delegate))delegate;

/**
 这个方法必须调用
 */
- (YJTimerMaker * (^)(NSString *key))key;


/**
 这两个方法必须有且只有一个调用（默认会调用resume）
 */

- (YJTimerMaker * (^)())resume;
/**
 如果没有设置有效的duration，一定要在不使用后调用stop方法
 */
- (YJTimerMaker * (^)())stop;

@end

@interface YJTimerManager : NSObject

+ (void)does:(void(^)(YJTimerMaker *maker))does;

YJSingleton_h(TimerManager)

@end
