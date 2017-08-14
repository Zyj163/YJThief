//
//  UIView+YJLayout.Y
//  Pods
//
//  Created by ddn on 2017/8/10.
//
//

#import "UIView+YJLayout.h"
#import "YYCategories.h"
#import "Masonry.h"
#import <objc/runtime.h>

@implementation UIView (YJLayout)

#pragma mark - line layout
- (void)yj_lineLayout:(NSArray<UIView *> *)views withPadding:(UIEdgeInsets)padding andSpace:(CGFloat)space withSetting:(void(^)(NSInteger idx, UIView *view))setting
{
	if (views.count == 0) return;
	for (NSInteger i=0; i<views.count; i++) {
		UIView *view = views[i];
		CGFloat h = self.bounds.size.height - padding.top - padding.bottom;
		CGFloat y = padding.top;
		
		CGFloat w = (self.bounds.size.width - padding.left - padding.right - space * (views.count - 1)) / views.count;
		
		CGFloat x = padding.left + i * (w + space);
		
		view.frame = CGRectMake(x, y, w, h);
		
		if (setting) {
			setting(i, view);
		}
	}
}

- (void)yj_vlineLayout:(NSArray<UIView *> *)views withPadding:(UIEdgeInsets)padding andSpace:(CGFloat)space withSetting:(void(^)(NSInteger idx, UIView *view))setting
{
	if (views.count == 0) return;
	for (NSInteger i=0; i<views.count; i++) {
		UIView *view = views[i];
		CGFloat w = self.bounds.size.width - padding.left - padding.right;
		CGFloat x = padding.left;
		
		CGFloat h = (self.bounds.size.height - padding.top - padding.bottom - space * (views.count - 1)) / views.count;
		
		CGFloat y = padding.top + i * (h + space);
		
		view.frame = CGRectMake(x, y, w, h);
		
		if (setting) {
			setting(i, view);
		}
	}
}

- (void)yj_lineButNoEqualWithLayout:(NSArray<UIView *> *)views withPadding:(UIEdgeInsets)padding andSpace:(CGFloat)space withSetting:(void(^)(NSInteger idx, UIView *view))setting
{
	if (views.count == 0) return;
	UIView *preView;
	for (NSInteger i=0; i<views.count; i++) {
		UIView *view = views[i];
		CGFloat h = self.bounds.size.height - padding.top - padding.bottom;
		CGFloat y = padding.top;
		
		[view sizeToFit];
		
		if (setting) {
			setting(i, view);
		}
		
		CGFloat w = view.bounds.size.width;
		
		CGFloat x = i == 0 ? padding.left : CGRectGetMaxX(preView.frame) + space;
		
		view.frame = CGRectMake(x, y, w, h);
		
		preView = view;
	}
	if ([self isKindOfClass:[UIScrollView class]]) {
		UIScrollView *s = (UIScrollView *)self;
		s.contentSize = CGSizeMake(CGRectGetMaxX(views.lastObject.frame) + padding.right, self.bounds.size.height);
	}
}

- (void)yj_vlineButNoEqualWithLayout:(NSArray<UIView *> *)views withPadding:(UIEdgeInsets)padding andSpace:(CGFloat)space withSetting:(void(^)(NSInteger idx, UIView *view))setting
{
	if (views.count == 0) return;
	UIView *preView;
	for (NSInteger i=0; i<views.count; i++) {
		UIView *view = views[i];
		CGFloat w = self.bounds.size.width - padding.left - padding.right;
		CGFloat x = padding.left;
		
		[view sizeToFit];
		
		if (setting) {
			setting(i, view);
		}
		
		CGFloat h = view.bounds.size.height;
		
		CGFloat y = i == 0 ? padding.top : CGRectGetMaxY(preView.frame) + space;
		
		view.frame = CGRectMake(x, y, w, h);
		
		preView = view;
	}
	if ([self isKindOfClass:[UIScrollView class]]) {
		UIScrollView *s = (UIScrollView *)self;
		s.contentSize = CGSizeMake(self.bounds.size.width, CGRectGetMaxY(views.lastObject.frame) + padding.bottom);
	}
}


#pragma mark - edge line
- (void)setYj_edgeLineViews:(NSMutableArray *)yj_edgeLineViews
{
	objc_setAssociatedObject(self, _cmd, yj_edgeLineViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)yj_edgeLineViews
{
	NSMutableArray *views = objc_getAssociatedObject(self, @selector(setYj_edgeLineViews:));
	if (!views) {
		views = [NSMutableArray array];
		[self setYj_edgeLineViews:views];
	}
	return views;
}

- (void)setYj_edgeLines:(UIEdgeInsets)yj_edgeLines
{
	[self willChangeValueForKey:@"edgeLines"];
	NSValue *value = [NSValue value:&yj_edgeLines withObjCType:@encode(UIEdgeInsets)];
	objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"edgeLines"];
	
	[self.yj_edgeLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj removeFromSuperview];
	}];
	[self.yj_edgeLineViews removeAllObjects];
	
	if (yj_edgeLines.left > 0.2) {
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor colorWithRGB:0xcccccc];
		[self addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.left.bottom.mas_equalTo(0);
			make.width.mas_equalTo(yj_edgeLines.left);
		}];
		[self.yj_edgeLineViews addObject:view];
	}
	if (yj_edgeLines.right > 0.2) {
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor colorWithRGB:0xcccccc];
		[self addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.right.bottom.mas_equalTo(0);
			make.width.mas_equalTo(yj_edgeLines.right);
		}];
		[self.yj_edgeLineViews addObject:view];
	}
	if (yj_edgeLines.top > 0.2) {
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor colorWithRGB:0xcccccc];
		[self addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.right.left.mas_equalTo(0);
			make.height.mas_equalTo(yj_edgeLines.top);
		}];
		[self.yj_edgeLineViews addObject:view];
	}
	if (yj_edgeLines.bottom > 0.2) {
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor colorWithRGB:0xcccccc];
		[self addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.right.left.mas_equalTo(0);
			make.height.mas_equalTo(yj_edgeLines.bottom);
		}];
		[self.yj_edgeLineViews addObject:view];
	}
}

- (UIEdgeInsets)yj_edgeLines
{
	UIEdgeInsets edgeLines = UIEdgeInsetsZero;
	NSValue *value = objc_getAssociatedObject(self, @selector(setYj_edgeLines:));
	if (!value) {
		[self setYj_edgeLines:UIEdgeInsetsZero];
	}
	[value getValue:&edgeLines];
	return edgeLines;
}




#pragma mark - attached show view
- (NSString *)yj_pathForImage:(NSString *)imageName
{
	NSBundle *currentBundle = [NSBundle bundleForClass:NSClassFromString(@"YJResponseModel")];
	int scale = (int)[UIScreen mainScreen].scale;
	if (scale < 2) {
		scale = 2;
	}
	NSString *imageFile = [currentBundle pathForResource:[NSString stringWithFormat:@"%@@%dx.png",imageName, scale] ofType:nil inDirectory:@"YJThief.bundle"];
	return imageFile;
}

- (UIImageView *)yj_errorImageView
{
	UIImageView *errorImageView = objc_getAssociatedObject(self, @selector(setYj_errorImageView:));
	if (!errorImageView) {
		errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self yj_pathForImage:@"errorIndicator"]]];
		errorImageView.contentMode = UIViewContentModeCenter;
		[errorImageView sizeToFit];
		[self setYj_errorImageView:errorImageView];
	}
	return errorImageView;
}

- (void)setYj_errorImageView:(UIImageView *)yj_errorImageView
{
	[self willChangeValueForKey:@"yj_errorImageView"];
	objc_setAssociatedObject(self, _cmd, yj_errorImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"yj_errorImageView"];
}

- (UIImageView *)yj_correctImageView
{
	UIImageView *correctImageView = objc_getAssociatedObject(self, @selector(setYj_correctImageView:));
	if (!correctImageView) {
		correctImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self yj_pathForImage:@"correctIndicator"]]];
		correctImageView.contentMode = UIViewContentModeCenter;
		[correctImageView sizeToFit];
		[self setYj_correctImageView:correctImageView];
	}
	return correctImageView;
}

- (void)setYj_correctImageView:(UIImageView *)yj_correctImageView
{
	[self willChangeValueForKey:@"yj_correctImageView"];
	objc_setAssociatedObject(self, _cmd, yj_correctImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"yj_correctImageView"];
}

- (void)setYj_attachedView:(UIView *)yj_attachedView
{
	[self willChangeValueForKey:@"yj_attachedView"];
	objc_setAssociatedObject(self, _cmd, yj_attachedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"yj_attachedView"];
}

- (UIView *)yj_attachedView
{
	return objc_getAssociatedObject(self, @selector(setYj_attachedView:));
}

- (UIView *)yj_realShowView {
	return objc_getAssociatedObject(self, @selector(setYj_realShowView:));
}

- (void)setYj_realShowView:(UIView *)yj_realShowView
{
	[self willChangeValueForKey:@"yj_realShowView"];
	objc_setAssociatedObject(self, _cmd, yj_realShowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"yj_realShowView"];
	if (!yj_realShowView) return;
	
	if (objc_getAssociatedObject(yj_realShowView, "yj_showView_tap")) return;
	
	yj_realShowView.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnShowView:)];
	[yj_realShowView addGestureRecognizer:tap];
	objc_setAssociatedObject(yj_realShowView, "yj_showView_type", @(self.yj_currentShowType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYj_currentShowType:(YJAttachedViewShowType)yj_currentShowType
{
	[self willChangeValueForKey:@"yj_currentShowType"];
	objc_setAssociatedObject(self, _cmd, @(yj_currentShowType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"yj_currentShowType"];
}

- (YJAttachedViewShowType)yj_currentShowType
{
	NSNumber *typeNum = objc_getAssociatedObject(self, @selector(setYj_currentShowType:));
	if (!typeNum) {
		[self setYj_currentShowType:YJAttachedViewShowTypeNone];
		typeNum = @(YJAttachedViewShowTypeNone);
	}
	return typeNum.integerValue;
}

- (void)setYj_tapOnShowView:(void (^)(UIView *, YJAttachedViewShowType))yj_tapOnShowView
{
	objc_setAssociatedObject(self, _cmd, yj_tapOnShowView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UIView *, YJAttachedViewShowType))yj_tapOnShowView
{
	return objc_getAssociatedObject(self, @selector(setYj_tapOnShowView:));
}

- (void)setYj_specLayoutShowView:(void (^)(UIView *))yj_specLayoutShowView
{
	objc_setAssociatedObject(self, _cmd, yj_specLayoutShowView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UIView *))yj_specLayoutShowView
{
	return objc_getAssociatedObject(self, @selector(setYj_specLayoutShowView:));
}

- (void)clickOnShowView:(UITapGestureRecognizer *)tap
{
	if (!self.yj_tapOnShowView) return;
	YJAttachedViewShowType type = [objc_getAssociatedObject(tap.view, "yj_showView_type") integerValue];
	self.yj_tapOnShowView(tap.view, type);
}

- (UIView *)yj_showView:(YJAttachedViewShowType)showType
{
	switch (showType) {
		case YJAttachedViewShowTypeError:
			return self.yj_errorImageView;
		case YJAttachedViewShowTypeCorrect:
			return self.yj_correctImageView;
		case YJAttachedViewShowTypeCustom:
			return self.yj_attachedView;
		default:
			return self.yj_realShowView;
	}
}

- (void)yj_show:(YJAttachedViewShowType)showType
{
	if (self.yj_currentShowType == showType) {
		self.yj_realShowView.hidden = NO;
		return;
	}
	self.yj_currentShowType = showType;
	[self.yj_realShowView setHidden:YES];
	self.yj_realShowView = [self yj_showView:showType];
	self.yj_realShowView.hidden = NO;
	if (!self.yj_realShowView.superview) {
		[self.superview addSubview:self.yj_realShowView];
	}
	if (self.yj_specLayoutShowView) {
		self.yj_specLayoutShowView(self.yj_realShowView);
	} else {
		self.yj_realShowView.left = CGRectGetMaxX(self.frame) + 5;
		self.yj_realShowView.top = self.top;
		self.yj_realShowView.height = self.height;
	}
}

- (void)yj_hide:(YJAttachedViewShowType)showType
{
	UIView *showView = [self yj_showView:showType];
	showView.hidden = YES;
}

- (BOOL)yj_typeIsVisiable:(YJAttachedViewShowType)showType
{
	UIView *showView = [self yj_showView:showType];
	if (!showView.superview) return NO;
	return ![showView isHidden];
}

- (void)yj_setErrorImage:(UIImage *)errorImage
{
	self.yj_errorImageView.image = errorImage;
	[self.yj_errorImageView sizeToFit];
}

- (void)yj_setCorrectImage:(UIImage *)correctImage
{
	self.yj_correctImageView.image = correctImage;
	[self.yj_correctImageView sizeToFit];
}









@end
