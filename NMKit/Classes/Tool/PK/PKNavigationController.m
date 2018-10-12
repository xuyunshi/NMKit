//
//  PKNavigationController.m
//
//  Created by 彭鹏 on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PKNavigationController.h"
#import "UIImage+Extension.h"
#import "PKNavigationBar.h"
#import "UIKitFactory.h"

@interface PKNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation PKNavigationController

// 标题颜色和字体 默认为0x333333 苹方常规18号字体
#define PKNavTitleColor   [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]
#define PKNavTitleFont    [UIFont fontWithName:@"PingFangSC-Regular" size:18] ?: [UIFont systemFontOfSize:18]

#pragma mark - Life Cycle
+ (void)initialize
{
    // 类初始化的时候调用,可以做些仅需初始化一次的操作
    [super initialize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNaviBar];
    
    [self setupNaviTheme];
    
    // 设置为自己的代理是监听代理方法
    self.delegate = self;
}

// 配置导航栏基本样式
- (void)setupNaviBar
{
    @try {
        // 更换系统自带的UINavigationBar
        UINavigationBar *customBar = [[PKNavigationBar alloc] init];
        [self setValue:customBar forKeyPath:@"navigationBar"];
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void)setupNaviTheme
{
    // 设置导航栏标题字体和颜色
    NSMutableDictionary *dictAttribute = [NSMutableDictionary dictionaryWithCapacity:2];
    [dictAttribute setObject:PKNavTitleColor forKey:NSForegroundColorAttributeName];
    [dictAttribute setObject:PKNavTitleFont forKey:NSFontAttributeName];
    [self.navigationBar setTitleTextAttributes:dictAttribute];
    
    // 设置导航栏背景图片
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                             forBarMetrics:UIBarMetricsDefault];
    
    // 去掉导航栏边界阴影线
    self.navigationBar.shadowImage = [[UIImage alloc] init];
}

#pragma mark - 设置状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

#pragma mark - 控制屏幕旋转方向
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - 自定义返回按钮事件
- (void)popViewController
{
    UIViewController *topVC = self.topViewController;
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)topVC;
        topVC = tabbar.selectedViewController;
    }
    
    if ([topVC respondsToSelector:@selector(onClickNavigationBack)]) {
        [topVC onClickNavigationBack];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.pushing == YES) {
        return;
    }
    
    self.pushing = YES;
    if (self.viewControllers.count > 0)
    {
        // 底部工具栏必须在push前hide
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *leftItem = [UIKitFactory itemWithImage:@"com_nav_back_nor"
                                                       hltImage:@"com_nav_back_sel"
                                                         target:self
                                                         action:@selector(popViewController)];
        [viewController.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    // 解决在push动画过程中激活手势返回会crash的问题
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    viewController.extendedLayoutIncludesOpaqueBars = NO;
    viewController.modalPresentationCapturesStatusBarAppearance = NO;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.pushing = NO;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        // 自定义返回按钮后需要清空手势代理
        self.interactivePopGestureRecognizer.delegate = nil;
        if (self.viewControllers.count > 1)
        {
            // 进入二级页面才需要有手势返回
            self.interactivePopGestureRecognizer.enabled = YES;
        }
        else
        {
            // 解决在rootController下手势返回再push下一个页面没有反应
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

@end
