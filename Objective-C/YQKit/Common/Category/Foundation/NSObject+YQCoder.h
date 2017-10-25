//
//  NSObject+YQCoder.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YQCoder)

// 在NSCoding的协议方法中直接调用此方法即可
- (void)yq_encodeWithCoder:(NSCoder *)aCoder;
- (void)yq_decodeWithCoder:(NSCoder *)aDecoder;

@end
