//
//  NSArray+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YQCategory)

// 将数组中元素的某一属性用separator连接起来
- (NSString *)yq_componentsJoinedKeyPath:(NSString *)keyPath ByString:(NSString *)separator;

// 通过orderset创建数组
+ (instancetype)yq_arrayWithOrderSet:(NSOrderedSet *)orderSet;
- (instancetype)yq_addObjectsFromOrderSet:(NSOrderedSet *)orderSet;
- (instancetype)yq_addObjectsFromArray:(NSArray *)array;
- (instancetype)yq_addObject:(id)object;
- (instancetype)yq_insetObject:(id)object atIndex:(NSInteger)index;

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the binary plist data, or nil if an error occurs.
 */
+ (instancetype)yq_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (instancetype)yq_arrayWithPlistString:(NSString *)plist;

// 从多个数组创建一个数组
+ (instancetype)yq_arrayWithArrays:(NSArray *)firstArray, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Serialize the array to a binary property list data.
 
 @return A binary plist data, or nil if an error occurs.
 */
- (nullable NSData *)yq_plistData;

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)yq_plistString;

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (nullable id)yq_randomObject;

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (nullable id)yq_objectOrNilAtIndex:(NSUInteger)index;


@end

@interface NSMutableArray (YQCategory)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the binary plist data, or nil if an error occurs.
 */
+ (instancetype)yq_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (instancetype)yq_arrayWithPlistString:(NSString *)plist;

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)yq_removeFirstObject;

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
- (void)yq_removeLastObject;

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)yq_popFirstObject;

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)yq_popLastObject;

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)yq_appendObject:(id)anObject;

/**
 Inserts a given object at the beginning of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)yq_prependObject:(id)anObject;

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)yq_appendObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)yq_prependObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)yq_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)yq_reverse;

/**
 Sort the object in this array randomly.
 */
- (void)yq_shuffle;

@end

NS_ASSUME_NONNULL_END
