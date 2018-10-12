//
//  PKNavigationBar.m
//
//  Created by 彭鹏 on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PKNavigationBar.h"

@implementation PKNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version >= 11.0f) {
        // 调整边距
        self.layoutMargins = UIEdgeInsetsZero;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5); // 可修正iOS11之后的偏移
                break;
            }
        }
    }
}

@end
