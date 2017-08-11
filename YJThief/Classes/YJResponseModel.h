//
//  YJResponseModel.h
//  yyox
//
//  Created by ddn on 2017/1/9.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJResponseModel : NSObject

@property (assign, nonatomic) NSInteger code;

@property (copy, nonatomic) NSString *msg;

@property (strong, nonatomic) id data;

@end
