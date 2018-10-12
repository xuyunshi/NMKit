//
//  UIView+HUDProgress.h
//
//  Created by 彭鹏 on 2017/6/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUDProgress)

/**
 *  @brief  指示器类型的HUD提示
 *
 *  @param  text   文字描述
 */
- (void)showIndicatorWithText:(NSString *)text;

/**
 *  @brief  简单的文字的HUD提示
 *
 *  @param  text   文字描述
 */
- (void)showToastText:(NSString *)text;
- (void)showToastText:(NSString *)text afterDelay:(NSTimeInterval)delay;

/**
 *  @brief  带成功图片的HUD提示
 *
 *  @param  text   文字描述
 */
- (void)showSuccessWithText:(NSString *)text;

/**
 *  @brief  带错误图片的HUD提示
 *
 *  @param  text   文字描述
 */
- (void)showErrorWithText:(NSString *)text;

/**
 *  @brief 隐藏HUD显示
 *
 */
- (void)dismissHUD;

@end
