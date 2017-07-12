//
//  NSData+YQCategory.h
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YQCategory)

/**
 *  利用AES加密数据
 */
- (NSData*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  @brief  利用AES解密据
 */
- (NSData*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  利用3DES加密数据
 */
- (NSData*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  @brief   利用3DES解密数据
 */
- (NSData*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end
