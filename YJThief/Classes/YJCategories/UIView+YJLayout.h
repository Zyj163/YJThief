//
//  UIView+YJLayout.h
//  Pods
//
//  Created by ddn on 2017/8/10.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YJAttachedViewShowType) {
	YJAttachedViewShowTypeNone,
	YJAttachedViewShowTypeError,
	YJAttachedViewShowTypeCorrect,
	YJAttachedViewShowTypeCustom
};

@interface UIView (YJLayout)

#pragma mark - edge line
@property (assign, nonatomic) UIEdgeInsets yj_edgeLines;
@property (strong, nonatomic) NSMutableArray *yj_edgeLineViews;


#pragma mark - attached show view
@property (strong, nonatomic) UIView *yj_attachedView;
@property (copy, nonatomic) void(^yj_specLayoutShowView)(UIView *showView);
@property (copy, nonatomic) void(^yj_tapOnShowView)(UIView *showView, YJAttachedViewShowType type);
- (void)yj_show:(YJAttachedViewShowType)showType;
- (void)yj_hide:(YJAttachedViewShowType)showType;
- (BOOL)yj_typeIsVisiable:(YJAttachedViewShowType)showType;
- (void)yj_setErrorImage:(UIImage *)errorImage;
- (void)yj_setCorrectImage:(UIImage *)correctImage;
- (YJAttachedViewShowType)yj_currentShowType;


@end
