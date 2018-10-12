//
//  UIAlertController+Extension.h
//
//  Created by 彭鹏 on 2017/8/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Alert 按钮点击回调事件

 @param index 按钮索引 (从0开始)
 @param title 按钮标题
 */
typedef void(^AlertButtonBlock)(NSUInteger index, NSString *title);

@interface UIAlertController (Extension)

/**
 *  单按钮的 AlertView (如: 知道了)
 *
 *  @param title        标题
 *  @param message      内容信息
 *  @param btnTitle     按钮标题
 */
+ (UIAlertController *)showWithTitle:(NSString *)title
                             message:(NSString *)message
                            btnTitle:(NSString *)btnTitle
                             handler:(void(^)(void))handler;

/**
 *  双按钮的 AlertView (如:确定、取消)
 *
 *  @param title        标题
 *  @param message      内容信息
 *  @param leftTitle    左标题
 *  @param rightTitle   右标题
 *  @param handler      左按键回调
 */
+ (UIAlertController *)showWithTitle:(NSString *)title
                             message:(NSString *)message
                           leftTitle:(NSString *)leftTitle
                          rightTitle:(NSString *)rightTitle
                             handler:(AlertButtonBlock)handler;

/**
 自定义样式类型
 
 @param style 样式
 @param title 标题
 @param message 内容信息
 @param btnTitles 按钮标题数组
 @param btnStyle  按钮风格数组
（对应UIAlertActionStyle，nil则默认为UIAlertActionStyleDefault）
 
 @param handler   按钮事件回调
 */
+ (UIAlertController *)showWithStyle:(UIAlertControllerStyle)style
                               title:(NSString *)title
                             message:(NSString *)message
                           btnTitles:(NSArray <NSString *>*)btnTitles
                            btnStyle:(NSArray <NSNumber *>*)btnStyle
                             handler:(AlertButtonBlock)handler;

/**
 *  输入类型的 AlertView (如:输入账号密码)
 *
 *  @param title        标题
 *  @param message      内容信息
 *  @param btnTitles    按钮标题数组
 *  @param handler      按钮事件回调
 *  @param textHandler  输入框改变回调
 */
+ (UIAlertController *)showInputWithTitle:(NSString *)title
                                  message:(NSString *)message
                                btnTitles:(NSArray *)btnTitles
                                 btnStyle:(NSArray *)btnStyle
                                  handler:(AlertButtonBlock)handler
                              textHandler:(void(^)(UITextField *tf))textHandler;

@end
