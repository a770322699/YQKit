//
//  YQBuildingManager.h
//  Demo
//
//  Created by maygolf on 17/6/21.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YQSynthesizeSingleton.h"

@interface YQBuildingManager : NSObject
YQ_DECLARE_SINGLETON_FOR_CLASS(YQBuildingManager)

// 计算label的高度
- (CGSize)labelSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
// 计算textView的高度(此接口尚未测试)
- (CGSize)textViewSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
