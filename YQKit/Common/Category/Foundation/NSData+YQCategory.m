//
//  NSData+YQCategory.m
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonCryptor.h>

#import "NSData+YQCategory.h"

@implementation NSData (YQCategory)

/**
 *  利用AES加密数据
 */
- (NSData*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding,keyData.bytes,keyData.length,iv.bytes,self.bytes,self.length,encryptedData.mutableBytes, encryptedData.length,&dataMoved);
    
    if (status == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }
    
    return nil;
}

/**
 *  @brief  利用AES解密据
 */
- (NSData*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding,keyData.bytes,keyData.length,iv.bytes,self.bytes,self.length,decryptedData.mutableBytes, decryptedData.length,&dataMoved);
    
    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }
    
    return nil;
    
}

/**
 *  利用3DES加密数据
 */
- (NSData*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt,kCCAlgorithm3DES,kCCOptionPKCS7Padding,keyData.bytes,keyData.length,iv.bytes,self.bytes,self.length,encryptedData.mutableBytes,encryptedData.length,&dataMoved);
    
    if (result == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }
    
    return nil;
    
}
/**
 *  @brief   利用3DES解密数据
 */
- (NSData*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,kCCAlgorithm3DES,kCCOptionPKCS7Padding,keyData.bytes,keyData.length,iv.bytes,self.bytes,self.length,decryptedData.mutableBytes,decryptedData.length,&dataMoved);
    
    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }
    
    return nil;
    
}

@end
