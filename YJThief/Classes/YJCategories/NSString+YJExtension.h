//
//  NSString+YJExtension.h
//  yyox
//
//  Created by ddn on 2017/1/23.
//  Copyright © 2017年 Panjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YJExtension)

#pragma mark - Regexte

- (BOOL)yj_isTelNumber;

- (BOOL)yj_isEmail;

- (BOOL)yj_isCardID;

- (BOOL)yj_isZipcode;

- (BOOL)yj_isChineseName;

- (BOOL)yj_isOnlyChinese;

- (BOOL)yj_hasChinese;

- (BOOL)yj_isMoney;

- (BOOL)yj_containsOneOfStrings:(NSArray<NSString *> *)strings;


+ (NSString *)yj_timeDistanceTo:(NSString *)time;

@end
