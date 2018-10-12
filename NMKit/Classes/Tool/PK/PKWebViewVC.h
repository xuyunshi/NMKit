//
//  PKWebViewVC.h
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ComWebScriptHandle)(NSString *method, id param);

@interface PKWebViewVC : UIViewController

/** Web页面URL地址 */
@property (nonatomic, copy) NSString *webUrl;

/** 动态获取标题(默认YES) */
@property (nonatomic, assign) BOOL dynamicTitle;

/**
 注册供JS调用的方法

 @param name JS回调方法
 @param handle JS回调处理
 */
- (void)addScriptMethod:(NSString *)name handle:(ComWebScriptHandle)handle;

/**
 加载Web页面
 
 @param webUrl 地址
 */
- (BOOL)loadWebWithUrl:(NSString *)webUrl;

/**
 加载Web页面
 
 @param string HTML内容
 */
- (void)loadHTMLString:(NSString *)string;

/**
 重新加载Web页面

 @param webUrl 地址
 */
- (BOOL)reloadWebWithUrl:(NSString *)webUrl;

@end
