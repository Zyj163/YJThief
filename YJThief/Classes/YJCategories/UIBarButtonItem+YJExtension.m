//
//  UIBarButtonItem+YJExtension.m
//  yyox
//
//  Created by ddn on 2017/1/10.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import "UIBarButtonItem+YJExtension.h"
#import "YYCategories.h"

@implementation UIBarButtonItem (YJExtension)

+ (UIBarButtonItem *)customView:(NSString *)imageName title:(NSString *)title withTarget:(id)target action:(SEL)action
{
	UIButton *btn = [self setupWithImageName:imageName title:title];
	[self setEvent:target action:action block:nil forBtn:btn];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
	return item;
}

- (void)changeTarget:(id)target action:(SEL)action
{
	if ([self.customView isKindOfClass:[UIButton class]]) {
		UIButton *btn = (UIButton *)self.customView;
		[self.class setEvent:target action:action block:nil forBtn:btn];
	}
}

+ (UIBarButtonItem *)customView:(NSString *)imageName title:(NSString *)title block:(void (^)(id))block
{
	UIButton *btn = [self setupWithImageName:imageName title:title];
	[self setEvent:nil action:nil block:block forBtn:btn];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
	return item;
}

- (void)changeBlock:(void (^)(id))block
{
	if ([self.customView isKindOfClass:[UIButton class]]) {
		UIButton *btn = (UIButton *)self.customView;
		[self.class setEvent:nil action:nil block:block forBtn:btn];
	}
}

+ (UIButton *)setupWithImageName:(NSString *)imageName title:(NSString *)title
{
	UIButton *btn = [UIButton new];
	[btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	btn.titleLabel.font = [UIFont systemFontOfSize:14];
	[btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
	[btn setContentEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
	[btn sizeToFit];
	return btn;
}

+ (void)setEvent:(id)target action:(SEL)action block:(void (^)(id))block forBtn:(UIButton *)btn
{
	if (block) {
		[btn setBlockForControlEvents:UIControlEventTouchUpInside block:block];
	} else {
		[btn setTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	}
}

@end
