//
//  UIWindow+YJExtension.h
//  yyox
//
//  Created by ddn on 2017/1/12.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UIWindowClickOnAnimationContainer;

UIKIT_EXTERN NSString *const DidAddSubviewToWindow;
UIKIT_EXTERN NSString *const DidAddSubviewToWindowKey;

UIKIT_EXTERN UIWindow *getCurrentWindow();
UIKIT_EXTERN UIViewController *getCurrentVC(UIWindow *window);

@interface UIWindow (YJExtension)

- (void)showInDuration:(NSTimeInterval)duration withAnimation:(void(^)(UIView *container))animation;
- (void)dismissInDuration:(NSTimeInterval)duration withAnimation:(void(^)(UIView *container))animation;

@end
