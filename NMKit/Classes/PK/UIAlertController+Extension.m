//
//  UIAlertController+Extension.m
//
//  Created by 彭鹏 on 2017/8/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

/** 单个按键的 alertView */
+ (UIAlertController *)showWithTitle:(NSString *)title
                              message:(NSString *)message
                             btnTitle:(NSString *)btnTitle
                              handler:(void (^)(void))handler {
    
    NSArray *btnTitles = [NSArray arrayWithObjects:btnTitle, nil];
    UIAlertController *alert =
    [self showWithStyle:UIAlertControllerStyleAlert
                  title:title
                message:message
              btnTitles:btnTitles
                handler:^(NSUInteger index, NSString *title) {
                         !handler ?: handler();
                 }];
    return alert;
}

/** 双按键的 alertView */
+ (UIAlertController *)showWithTitle:(NSString *)title
                             message:(NSString *)message
                           leftTitle:(NSString *)leftTitle
                          rightTitle:(NSString *)rightTitle
                             handler:(AlertButtonBlock)handler {
    
    NSMutableArray *btnTitles = [NSMutableArray arrayWithCapacity:2];
    if (leftTitle) {
        [btnTitles addObject:leftTitle];
    }
    if (rightTitle) {
        [btnTitles addObject:rightTitle];
    }
    UIAlertController *alert =
    [self showWithStyle:UIAlertControllerStyleAlert
                  title:title
                message:message
              btnTitles:btnTitles
                handler:handler];
    return alert;
}

+ (UIAlertController *)showWithStyle:(UIAlertControllerStyle)style
                               title:(NSString *)title
                             message:(NSString *)message
                           btnTitles:(NSArray<NSString *> *)btnTitles
                            btnStyle:(NSArray<NSNumber *> *)btnStyle
                             handler:(AlertButtonBlock)handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int i = 0; i < btnTitles.count; i++) {
        
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (i < btnStyle.count) {
            style = [btnStyle[i] integerValue];
        }
        
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:btnTitles[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            handler(i, btnTitles[i]);
        }];
        [alert addAction:confimAction];
    }
    
    [kRootViewController presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

+ (UIAlertController *)showWithStyle:(UIAlertControllerStyle)style
                               title:(NSString *)title
                             message:(NSString *)message
                           btnTitles:(NSArray *)btnTitles
                             handler:(AlertButtonBlock)handler {
    
    UIAlertController *alert =
    [self showWithStyle:style title:title message:message btnTitles:btnTitles btnStyle:nil handler:handler];
    
    return alert;
}

+ (UIAlertController *)showInputWithTitle:(NSString *)title
                                  message:(NSString *)message
                                btnTitles:(NSArray *)btnTitles
                                 btnStyle:(NSArray *)btnStyle
                                  handler:(AlertButtonBlock)handler
                              textHandler:(void (^)(UITextField *))textHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < btnTitles.count; i++) {
        
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (i < btnStyle.count) {
            style = [btnStyle[i] integerValue];
        }
        
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:btnTitles[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            handler(i, btnTitles[i]);
        }];
        [alert addAction:confimAction];
    }
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        !textHandler ?: textHandler(textField);
    }];
    [kRootViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end
