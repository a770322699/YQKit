//
//  NSString+YQRegular.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YQRegular)

//邮箱
- (BOOL)yq_validateEmail;
//手机号码验证
- (BOOL)yq_validateMobile;
//车牌号验证
- (BOOL)yq_validateCarNo;
//身份证号
- (BOOL)yq_validateIdentityCard;

@end
