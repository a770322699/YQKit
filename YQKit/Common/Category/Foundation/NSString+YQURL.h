//
//  NSString+YQURL.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YQURL)

// url参数字符串
+ (NSString *)yq_parameterStringWithDictionary:(NSDictionary *)parameterDictionary;


// url 编码
+ (NSString *)yq_urlStringWithString:(NSString *)string;
// url 解码
+ (NSString *)yq_stringWithUrlString:(NSString *)urlString;

// 添加参数
- (NSString *)yq_appendURLParameter:(NSDictionary *)parameter;

@end
