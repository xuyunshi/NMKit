//
//  PKNavigationController.h
//
//  Created by 彭鹏 on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//
//  自定义导航栏控制器, 提供导航栏基础功能

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBack)

/**
 导航栏返回按钮事件
 如需拦截事件，重写该方法处理
 */
- (void)onClickNavigationBack;

@end

@interface PKNavigationController : UINavigationController

/**
 配置导航栏主题(如标题字体颜色、背景颜色、背景图片等)
 如需修改样式，重写该方法处理
 */
- (void)setupNaviTheme;

@end
