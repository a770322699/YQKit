//
//  YQSynthesizeSingleton.h
//  YQPublicCode
//
//  Created by maygolf on 16/9/18.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 快速定义一个单例

#import <objc/runtime.h>

#ifndef YQSynthesizeSingleton_h
#define YQSynthesizeSingleton_h

#define YQ_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
+ (classname *)accessorMethodName;

#if __has_feature(objc_arc)
#define YQ_SYNTHESIZE_SINGLETON_RETAIN_METHODS
#else
#define YQ_SYNTHESIZE_SINGLETON_RETAIN_METHODS \
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}
#endif

#define YQ_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
\
static classname *accessorMethodName##Instance = nil; \
\
+ (classname *)accessorMethodName \
{ \
@synchronized(self) \
{ \
if (accessorMethodName##Instance == nil) \
{ \
accessorMethodName##Instance = [super allocWithZone:NULL]; \
accessorMethodName##Instance = [accessorMethodName##Instance init]; \
method_exchangeImplementations(\
class_getClassMethod([accessorMethodName##Instance class], @selector(accessorMethodName)),\
class_getClassMethod([accessorMethodName##Instance class], @selector(yq_lockless_##accessorMethodName)));\
method_exchangeImplementations(\
class_getInstanceMethod([accessorMethodName##Instance class], @selector(init)),\
class_getInstanceMethod([accessorMethodName##Instance class], @selector(yq_onlyInitOnce)));\
} \
} \
\
return accessorMethodName##Instance; \
} \
\
+ (classname *)yq_lockless_##accessorMethodName \
{ \
return accessorMethodName##Instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self accessorMethodName]; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
- (id)yq_onlyInitOnce \
{ \
return self;\
} \
\
YQ_SYNTHESIZE_SINGLETON_RETAIN_METHODS

#define YQ_DECLARE_SINGLETON_FOR_CLASS(classname) YQ_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, sharedInstance)
#define YQ_SYNTHESIZE_SINGLETON_FOR_CLASS(classname) YQ_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, sharedInstance)

#endif /* YQSynthesizeSingleton_h */
