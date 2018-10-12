//
//  PKSecurityTool.h
//
//  Created by 彭鹏 on 14-9-20.
//  Copyright (c) 2014年 PP. All rights reserved.
//

#import "PKSecurityTool.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation PKSecurityTool

#pragma mark - MD5加密算法
+ (NSString *)md5Encode:(NSString *)input encodeType:(MD5EncodeType)encodeType
{
    if (input.length > 0)
    {
        const char *cStr = [input UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        switch (encodeType)
        {
            case MD5EncodeType16Lowercase:
            case MD5EncodeType32Lowercase:
                for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                {
                    [output appendFormat:@"%02x", digest[i]];
                }
                break;
            case MD5EncodeType16Capital:
            case MD5EncodeType32Capital:
                for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                {
                    [output appendFormat:@"%02X", digest[i]];
                }
                break;
                
            default:
                break;
        }
        
        NSString *result = output;
        
        if (MD5EncodeType16Lowercase == encodeType || MD5EncodeType16Capital == encodeType)
        {
            // 16位取的是32位字符串中间16位
            result = [output substringWithRange:NSMakeRange(8, 16)];
        }
        return result;
    }
    return nil;
}

#pragma mark - AES加解密算法
+ (NSString *)aesDecode:(NSString *)input secretKey:(NSString *)secretKey
{
    if (input.length > 0)
    {
        // 先进行Base64解码
        NSData *inputData = [[NSData alloc] initWithBase64EncodedString:input options:0];
        NSData *decodeData = [self aes256Decrypt:inputData secretKey:secretKey];
        
        NSString *strResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
        
        return strResult;
    }
    
    return nil;
}

+ (NSString *)aesEncode:(NSString *)input secretKey:(NSString *)secretKey
{
    if (input.length > 0)
    {
        NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encodeData = [self aes256Encrypt:inputData secretKey:secretKey];
        
        // Base64编码
        NSString *strResult = [encodeData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
        
        return strResult;
    }
    
    return nil;
}

#pragma mark AES加密
+ (NSData *)aes256Encrypt:(NSData *)inputData secretKey:(NSString *)secretKey
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    // fetch key data
    [secretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inputData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [inputData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

#pragma mark AES解密
+ (NSData *)aes256Decrypt:(NSData *)inputData secretKey:(NSString *)secretKey
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    // fetch key data
    [secretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [inputData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [inputData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

#pragma mark - SHA256加密
+ (NSString *)sha256Encode:(NSString *)input
{
    const char *cstr = [input UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",digest[i]];
    }
    
    return output;
}
@end
