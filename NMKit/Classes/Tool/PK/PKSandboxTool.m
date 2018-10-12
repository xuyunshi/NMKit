//
//  PKSandboxTool.m
//
//  Created by PP on 15/8/13.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  

#import "PKSandboxTool.h"

@implementation PKSandboxTool

static float sUnitKB = 1024.0;
static float sUnitMB = 1024.0 * 1024.0;
static float sUnitGB = 1024.0 * 1024.0 * 1024.0;

#pragma mark - 获取Sandbox目录路径
+ (NSString *)getTempDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString *)getDocumentDirectory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [directories firstObject];
}

+ (NSString *)getCachesDirectory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [directories firstObject];
}

+ (NSString *)fileInboxDirectory
{
    NSString *folderPath = [NSString stringWithFormat:@"%@/Inbox", [self getDocumentDirectory]];
    return folderPath;
}

+ (NSString *)descriptionOfSize:(unsigned long long)size
{
    if (size <= sUnitKB) {
        return [NSString stringWithFormat:@"%lluB", size];
    } else if (size >= sUnitKB && size <= sUnitMB) {
        return [NSString stringWithFormat:@"%.2fKB", size / sUnitKB];
    } else if (size >= sUnitMB && size <= sUnitGB) {
        return [NSString stringWithFormat:@"%.2fMB", size / sUnitMB];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", size / sUnitGB];
    }
}

+ (unsigned long long)sizeWithFilePath:(NSString *)file
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:file]) {
        return [[manager attributesOfItemAtPath:file error:nil] fileSize];
    }
    return 0;
}

+ (BOOL)deleteFileWithPath:(NSString *)file
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:file]) {
        return YES;
    }
    
    return [manager removeItemAtPath:file error:nil];
}

+ (NSString *)currentDirAppendDir:(NSString *)currentDir appendDir:(NSString *)appendDir
{
    NSString *pathDir = [currentDir stringByAppendingPathComponent:appendDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return pathDir;
}

#pragma mark - Private Method
+ (NSString *)getUserDataDir
{
    NSString *filePath = [self currentDirAppendDir:[self getDocumentDirectory] appendDir:Data_Store_Folder];
    return filePath;
}
@end
