//
//  FWAccountWebKitViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountWebKitViewController.h"
#import "FWAccountWebKitViewModel.h"

@interface FWAccountWebKitViewController () <WKNavigationDelegate>

/// WKWebView
@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;

/// ViewModel
@property (strong, nonatomic) FWAccountWebKitViewModel *viewModel;

@end

@implementation FWAccountWebKitViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 初始化UI
/// 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置背景色
    self.view.backgroundColor = RGBOF(0xF7F8FA);
    /// 设置代理
    self.wkWebView.navigationDelegate = self;
    /// 设置滚动视图
    self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWAccountWebKitViewModel alloc] initWithType:self.tag];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听订阅参会入口类型
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        NSString *title = NSLocalizedString(@"免责声明", nil);
        NSString *loadingHost = FWACCOUNTASSERTHOST;
        switch (value.integerValue) {
            case FWAccountWebTypeAssert:
                /// 免责声明
                title = NSLocalizedString(@"免责声明", nil);
                loadingHost = FWACCOUNTASSERTHOST;
                break;
            case FWAccountWebTypePersonal:
                /// 个人信息收集清单
                title = NSLocalizedString(@"个人信息收集清单", nil);
                loadingHost = FWACCOUNTPERSONALHOST;
                break;
            case FWAccountWebTypeThirdParty:
                /// 第三方信息共享清单
                title = NSLocalizedString(@"第三方信息共享清单", nil);
                loadingHost = FWACCOUNTTHIRDPARTYHOST;
                break;
            case FWAccountWebTypeAgreement:
                /// 用户协议
                title = NSLocalizedString(@"用户协议", nil);
                loadingHost = FWACCOUNTAGREEMENTHOST;
                break;
            case FWAccountWebTypePrivacy:
                /// 隐私协议
                title = NSLocalizedString(@"隐私协议", nil);
                loadingHost = FWACCOUNTPRIVACYHOST;
                break;
            default:
                break;
        }
        /// 设置标题
        self.navigationItem.title = title;
        /// 加载网页资源
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadingHost]]];
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
}

#pragma mark ------- WKNavigationDelegate的代理方法 -------
#pragma mark 是否允许这个导航
/// 是否允许这个导航
/// - Parameters:
///   - webView: 网页视图对象
///   - navigationAction: 导航活动
///   - decisionHandler: 回调处理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 知道返回内容之后，是否允许加载
/// 知道返回内容之后，是否允许加载
/// - Parameters:
///   - webView: 网页视图对象
///   - navigationResponse: 导航相应
///   - decisionHandler: 回调处理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 网页开始加载
/// 网页开始加载
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    /// 标记加载状态
    self.viewModel.loading = YES;
}

#pragma mark 网页加载失败
/// 网页加载失败
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
///   - error: 错误信息
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    /// 恢复加载状态
    self.viewModel.loading = NO;
}

#pragma mark 网页加载完毕
/// 网页加载完毕
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    /// 恢复加载状态
    self.viewModel.loading = NO;
}

#pragma mark 网页加载失败
/// 网页加载失败
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
///   - error: 错误信息
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    /// 恢复加载状态
    self.viewModel.loading = NO;
}

@end
