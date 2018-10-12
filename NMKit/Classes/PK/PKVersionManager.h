//
//  PKVersionManager.h
//
//  Created by 彭鹏 on 2017/6/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreInfoDM : NSObject

@property (nonatomic, copy) NSString *trackViewUrl; // 下载地址
@property (nonatomic, copy) NSString *releaseNotes; // 更新描述
@property (nonatomic, copy) NSString *trackId;      // 应用名
@property (nonatomic, copy) NSString *bundleId;     // 包名
@property (nonatomic, copy) NSString *version;      // 版本信息

@end

typedef void(^VersionCheckCompleted)(NSError *error, AppStoreInfoDM *dmInfo);

@interface PKVersionManager : NSObject

/**
 获取单例对象
 @return PKVersionManager实例
 */
+ (instancetype)shared;

/**
 检测应用更新

 @param appId 应用ID(iTunes Content中)
 @param completed 完成回调方法
 */
- (void)checkWithAppId:(NSString *)appId completed:(VersionCheckCompleted)completed;

@end
