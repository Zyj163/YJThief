//
//  YJGlobalWeakHoldManager.h
//  yyox
//
//  Created by ddn on 2017/2/27.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJSingleton.h"

@interface YJGlobalWeakHoldManager : NSObject

YJSingleton_h(GlobalWeakHoldManager)

/**
 添加值

 @param value 值
 */
+ (void)addValue:(id)value;

/**
 查找值

 @param callback 回调
 */
+ (void)findValue:(void(^)(id value))callback;

/**
 删除值

 @param value 值
 */
+ (void)removeValue:(id)value;

/**
 设置值

 @param value 值
 @param key 键
 */
+ (void)setValue:(id)value forKey:(id)key;

/**
 获取值

 @param key 键
 @return 值
 */
+ (id)getValueForKey:(id)key;

/**
 删除值

 @param key 键
 */
+ (void)removeValueForKey:(id)key;

@end
