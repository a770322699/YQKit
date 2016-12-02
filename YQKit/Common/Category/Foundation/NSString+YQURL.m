//
//  NSString+YQURL.m
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSString+YQURL.h"

@implementation NSString (YQURL)

// url参数字符串
+ (NSString *)yq_parameterStringWithDictionary:(NSDictionary *)parameterDictionary
{
    NSMutableString *resultString = nil;
    for (NSString *key in parameterDictionary) {
        if (resultString == nil) {
            resultString = [NSMutableString stringWithFormat:@"%@=%@",key,[NSString yq_urlStringWithString:[NSString stringWithFormat:@"%@",[parameterDictionary objectForKey:key]]]];
        }else{
            [resultString appendFormat:@"&%@=%@",key,[NSString yq_stringWithUrlString:[NSString stringWithFormat:@"%@",[parameterDictionary objectForKey:key]]]];
        }
    }
    return resultString;
}

// url 编码
+ (NSString *)yq_urlStringWithString:(NSString *)string
{
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// url 解码
+ (NSString *)yq_stringWithUrlString:(NSString *)urlString
{
    return [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
