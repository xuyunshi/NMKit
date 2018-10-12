//
//  PKVersionManager.m
//
//  Created by 彭鹏 on 2017/6/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PKVersionManager.h"
#import <UIKit/UIKit.h>

#define kServerUrl      @"http://itunes.apple.com/lookup"

@interface AppStoreInfoDM ()

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@implementation AppStoreInfoDM

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.version = [dict objectForKey:@"version"];
        self.bundleId = [dict objectForKey:@"bundleId"];
        self.trackId = [dict objectForKey:@"trackId"];
        self.releaseNotes = [dict objectForKey:@"releaseNotes"];
        self.trackViewUrl = [dict objectForKey:@"trackViewUrl"];
    }
    return self;
}

@end

@interface PKVersionManager () <UIAlertViewDelegate>

@property (nonatomic, strong) AppStoreInfoDM *dmInfo;
@property (nonatomic, copy) VersionCheckCompleted completed;

@end

@implementation PKVersionManager

static id instance = nil;

+ (instancetype)shared
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)checkWithAppId:(NSString *)appId completed:(VersionCheckCompleted)completed
{
    self.completed = completed;
    if (appId.length == 0) {
        NSError *error = [NSError errorWithDomain:@"App ID not is nil" code:404 userInfo:nil];
        [self handleError:error];
        return;
    }
    
    // 拼接请求地址&参数
    NSString *strUrl = [NSString stringWithFormat:@"%@?id=%@", kServerUrl, appId];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    // 网络请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"网络请求错误: %@", error);
            [self handleError:error];;
            return;
        }
        
        // 解析数据处理
        NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            NSLog(@"数据解析失败: %@", error);
            [self handleError:error];
            return;
        }
        
        NSArray *results = [dictResult objectForKey:@"results"];
        if (results.count == 0) {
            NSLog(@"error : results is nil");
            [self handleError:error];
            return;
        }
        
        NSDictionary *appInfo = [results firstObject];
        
        AppStoreInfoDM *dmInfo = [[AppStoreInfoDM alloc] initWithDict:appInfo];
        self.dmInfo = dmInfo;
        
        if (self.completed) {
            if ([NSThread isMainThread]) {
                self.completed(nil, dmInfo);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.completed(nil, dmInfo);
                });
            }
        } else {
            if ([self compareVersion:dmInfo.version]) {
                [self showUpdateAlert:dmInfo];
            }
        }
    }];
    
    [task resume];
}

- (void)handleError:(NSError *)error
{
    if ([NSThread isMainThread]) {
        !self.completed ?: self.completed(error, nil);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            !self.completed ?: self.completed(error, nil);
        });
    }
}

- (void)showUpdateAlert:(AppStoreInfoDM *)dmInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:dmInfo.releaseNotes delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"升级", nil];
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:self.dmInfo.trackViewUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 与本地版本比较
- (BOOL)compareVersion:(NSString *)newVersion
{
    // 获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSComparisonResult result = [curVersion compare:newVersion options:NSCaseInsensitiveSearch];
    
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        // 本地版本 >= App Store版本
        return NO;
    }
}

@end

