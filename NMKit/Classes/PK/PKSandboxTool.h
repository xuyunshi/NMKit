//
//  PKSandboxTool.h
//
//  Created by PP on 15/8/13.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  数据存储工具类(本地持久化)

#import <Foundation/Foundation.h>

// 数据存储默认文件夹
#define Data_Store_Folder           @"user_data"

@interface PKSandboxTool : NSObject

#pragma mark - 获取Sandbox目录路径
/**
 *  @brief  获取Documents目录
 *
 *  @return Documents目录
 */
+ (NSString *)getDocumentDirectory;

/**
 *  @brief  获取Library下的Caches目录
 *
 *  @return Caches目录
 */
+ (NSString *)getCachesDirectory;

/**
 *  @brief  获取Temp目录
 *
 *  @return Temp目录
 */
+ (NSString *)getTempDirectory;

/**
 获取共享文件接收目录

 @return 文件路径
 */
+ (NSString *)fileInboxDirectory;

/**
 *  @brief  获取用户数据存储目录(默认Document/user_data)
 *
 *  @return 目录路径
 */
+ (NSString *)getUserDataDir;

/**
 文件大小转换成字符串描述
 如 B/KB/MB/GB
 
 @param size 字节大小
 @return 格式描述
 */
+ (NSString *)descriptionOfSize:(unsigned long long)size;

/**
 获取文件大小
 
 @param file 文件路径
 @return 文件大小
 */
+ (unsigned long long)sizeWithFilePath:(NSString *)file;

/**
 删除文件
 
 @param file 文件路径
 @return 成功失败
 */
+ (BOOL)deleteFileWithPath:(NSString *)file;

/**
 *  @brief  从当前目录追加目录(不存在则创建)
 *
 *  @param currentDir 当前目录
 *  @param appendDir  追加目录
 *
 *  @return 追加后完整的路径
 */
+ (NSString *)currentDirAppendDir:(NSString *)currentDir appendDir:(NSString *)appendDir;

@end
