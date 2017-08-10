#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIWindow+YJExtension.h"
#import "YJSingleton.h"
#import "YJTimerManager.h"

FOUNDATION_EXPORT double YJThiefVersionNumber;
FOUNDATION_EXPORT const unsigned char YJThiefVersionString[];

