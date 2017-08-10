//
//  UIView+YJLayout.Y
//  Pods
//
//  Created by ddn on 2017/8/10.
//
//

#import "UIView+YJLayout.h"

@implementation UIView (YJLayout)

- (void)setYj_x:(CGFloat)yj_x
{
	CGRect fraYe = self.frame;
	fraYe.origin.x = yj_x;
	self.frame = fraYe;
}

- (CGFloat)yj_x
{
	return self.frame.origin.x;
}

- (void)setYj_y:(CGFloat)yj_y
{
	CGRect fraYe = self.frame;
	fraYe.origin.y = yj_y;
	self.frame = fraYe;
}

- (CGFloat)yj_y
{
	return self.frame.origin.y;
}

- (void)setYj_w:(CGFloat)yj_w
{
	CGRect fraYe = self.frame;
	fraYe.size.width = yj_w;
	self.frame = fraYe;
}

- (CGFloat)yj_w
{
	return self.frame.size.width;
}

- (void)setYj_h:(CGFloat)yj_h
{
	CGRect fraYe = self.frame;
	fraYe.size.height = yj_h;
	self.frame = fraYe;
}

- (CGFloat)yj_h
{
	return self.frame.size.height;
}

- (void)setYj_size:(CGSize)yj_size
{
	CGRect fraYe = self.frame;
	fraYe.size = yj_size;
	self.frame = fraYe;
}

- (CGSize)yj_size
{
	return self.frame.size;
}

- (void)setYj_origin:(CGPoint)yj_origin
{
	CGRect fraYe = self.frame;
	fraYe.origin = yj_origin;
	self.frame = fraYe;
}

- (CGPoint)yj_origin
{
	return self.frame.origin;
}


@end
