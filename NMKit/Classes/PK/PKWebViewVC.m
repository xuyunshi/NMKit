//
//  PKWebViewVC.m
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "PKWebViewVC.h"

@protocol PKScriptMessageDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface PKScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<PKScriptMessageDelegate> delegate;

@end

@implementation PKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

@interface PKWebViewVC () <WKNavigationDelegate, WKScriptMessageHandler, PKScriptMessageDelegate>

@property (nonatomic, strong) UIView    *viewFail;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *vProgress;
@property (nonatomic, strong) NSMutableArray *listMethods;
@property (nonatomic, strong) NSMutableDictionary *dictHandle;
@property (nonatomic, strong) PKScriptMessageHandler *scriptMessage;

@end

@implementation PKWebViewVC

/** 进度条颜色 */
#define kProgressColor  [UIColor colorWithRed:25/255.0f green:149/255.0f blue:251/255.0f alpha:1]

static  NSString * const kEstimatedProgress = @"estimatedProgress";
static  NSString * const kWKWebViewTitle = @"title";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    if (self.webUrl.length > 0) {
        [self loadWebWithUrl:self.webUrl];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dynamicTitle = YES;
    }
    return self;
}

- (void)createUI
{
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    self.webView.scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:1];
    
    NSArray *constraints = @[leftConstraint, rightConstraint, bottomConstraint, topConstraint];
    [self.view addConstraints:constraints];
    
    [self.webView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.webView addObserver:self forKeyPath:kWKWebViewTitle options:NSKeyValueObservingOptionNew context:nil];
}

- (WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (void)dealloc
{
    @try {
        [self.webView removeObserver:self forKeyPath:kEstimatedProgress];
        [self.webView removeObserver:self forKeyPath:kWKWebViewTitle];
        
        // 解决内存泄漏问题，WKWebView与self之间循环引用
        for (NSString *methods in self.listMethods) {
            [[self.webView configuration].userContentController removeScriptMessageHandlerForName:methods];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)addScriptMethod:(NSString *)name handle:(ComWebScriptHandle)handle
{
    if (name) {
        [self.listMethods addObject:name];
        [self.dictHandle setValue:handle forKey:name];
    }
    // OC注册供JS调用的方法
    // 解决内存泄漏问题，WKWebView与self之间循环引用
    [[self.webView configuration].userContentController addScriptMessageHandler:self.scriptMessage name:name];
}

- (BOOL)loadWebWithUrl:(NSString *)webUrl
{
    _webUrl = webUrl;
    if ([webUrl hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        return YES;
    }
    return NO;
}

- (void)loadHTMLString:(NSString *)string
{
    if (string.length > 0) {
        [self.webView loadHTMLString:string baseURL:nil];
    }
}

- (BOOL)reloadWebWithUrl:(NSString *)webUrl
{
    BOOL success = [self loadWebWithUrl:webUrl];
    [self.webView reload];
    return success;
}

#pragma mark - 屏幕旋转控制
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFailView
{
    if (self.viewFail == nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:self.view.bounds];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(reloadAfterFail) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 0;
        [button setTitle:@"加载失败\n点击屏幕重试" forState:UIControlStateNormal];
        
        self.viewFail = button;
        [self.view addSubview:self.viewFail];
    }
    self.viewFail.hidden = NO;
}

- (UIProgressView *)vProgress
{
    if (_vProgress == nil) {
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 4.0f);
        
        _vProgress = [[UIProgressView alloc] initWithFrame:frame];
        _vProgress.tintColor = kProgressColor;
        _vProgress.trackTintColor = [UIColor clearColor];
        
        [self.view addSubview:_vProgress];
    }
    return _vProgress;
}

#pragma mark - 懒加载
- (PKScriptMessageHandler *)scriptMessage
{
    if (_scriptMessage == nil) {
        _scriptMessage = [[PKScriptMessageHandler alloc] init];
        _scriptMessage.delegate = self;
    }
    return _scriptMessage;
}

- (NSMutableDictionary *)dictHandle
{
    if (_dictHandle == nil) {
        _dictHandle = [NSMutableDictionary dictionary];
    }
    return _dictHandle;
}

- (NSMutableArray *)listMethods
{
    if (_listMethods == nil) {
        _listMethods = [NSMutableArray array];
    }
    return _listMethods;
}

#pragma mark - Private Method
- (void)reloadAfterFail
{
    self.viewFail.hidden = YES;
    [self reloadWebWithUrl:self.webUrl];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        CGFloat oldProgress = [[change objectForKey:NSKeyValueChangeOldKey] doubleValue];
        // 进度条倒退的问题
        if (newProgress <= oldProgress) {
            [self.vProgress setProgress:newProgress animated:NO];
            return;
        }
        [self.vProgress setProgress:newProgress animated:YES];
        if (newProgress == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.vProgress.layer.opacity = 0.5;
            } completion:^(BOOL finished) {
                self.vProgress.hidden = YES;
            }];
        } else {
            self.vProgress.layer.opacity = 1;
            self.vProgress.hidden = NO;
        }
    } else if ([keyPath isEqualToString:kWKWebViewTitle]) {
        if (self.dynamicTitle) {
            self.navigationItem.title = self.webView.title;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKScriptMessageHandler
// OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    ComWebScriptHandle handle = [self.dictHandle objectForKey:message.name];
    !handle ?: handle(message.name, message.body);
}

#pragma mark - WKNavigationDelegate
// 根据webView、navigationAction相关信息决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //NSLog(@"%s", __FUNCTION__);
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:@"https://itunes.apple.com"] || [url hasPrefix:@"tel://"] ||
        [url hasPrefix:@"sms://"] || [url hasPrefix:@"mailto://"])
    {
        if ([[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {
            policy = WKNavigationActionPolicyCancel;
        }
    }
    decisionHandler(policy);
}

// 当客户端收到服务器的响应头，根据response相关信息，可以决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 启动时加载数据发生错误就会调用这个方法
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    [self showFailView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 当一个正在提交的页面在跳转过程中出现错误时调用这个方法
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}

@end
