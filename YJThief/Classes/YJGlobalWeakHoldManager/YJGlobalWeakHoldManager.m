//
//  YJGlobalWeakHoldManager.m
//  yyox
//
//  Created by ddn on 2017/2/27.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "YJGlobalWeakHoldManager.h"

@interface YJGlobalWeakHoldManager()

@property (strong, nonatomic) NSPointerArray *weaks;

@property (strong, nonatomic) NSMapTable<id, id> *weakMaps;

@end

@implementation YJGlobalWeakHoldManager

YJSingleton_m(GlobalWeakHoldManager)

- (NSPointerArray *)weaks
{
	if (!_weaks) {
		_weaks = [NSPointerArray weakObjectsPointerArray];
	}
	return _weaks;
}

- (NSMapTable *)weakMaps
{
	if (!_weakMaps) {
		_weakMaps = [NSMapTable weakToWeakObjectsMapTable];
	}
	return _weakMaps;
}

+ (void)addValue:(id)value
{
	YJGlobalWeakHoldManager *mgr = [self sharedGlobalWeakHoldManager];
	[mgr.weaks addPointer:(__bridge void * _Nullable)(value)];
}

+ (void)findValue:(void (^)(id))callback
{
	[[YJGlobalWeakHoldManager sharedGlobalWeakHoldManager].weaks.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj) {
			if (callback) {
				callback(obj);
			}
			*stop = YES;
		}
	}];
}

+ (void)removeValue:(id)value
{
	[[YJGlobalWeakHoldManager sharedGlobalWeakHoldManager].weaks.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isEqual:value]) {
			[[YJGlobalWeakHoldManager sharedGlobalWeakHoldManager].weaks removePointerAtIndex:idx];
			*stop = YES;
		}
	}];
}

+ (void)setValue:(id)value forKey:(id)key
{
	YJGlobalWeakHoldManager *mgr = [self sharedGlobalWeakHoldManager];
	[mgr.weakMaps setObject:value forKey:key];
}

+ (id)getValueForKey:(id)key
{
	YJGlobalWeakHoldManager *mgr = [self sharedGlobalWeakHoldManager];
	return [mgr.weakMaps objectForKey:key];
}

+ (void)removeValueForKey:(id)key
{
	YJGlobalWeakHoldManager *mgr = [self sharedGlobalWeakHoldManager];
	[mgr.weakMaps removeObjectForKey:key];
}

@end
