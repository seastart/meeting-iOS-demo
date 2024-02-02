//
//  FWRoomWhiteboardView.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/1.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomWhiteboardView.h"

@interface FWRoomWhiteboardView() <WKNavigationDelegate, UIGestureRecognizerDelegate>

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 标题标签
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/// 退出按钮
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
/// WKWebView
@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;

/// 是否拥有读写权限
@property (assign, nonatomic) BOOL readwrite;

@end

@implementation FWRoomWhiteboardView

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init {

    self = [super init];
    if (self) {
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化视图
/// 初始化视图
/// @param aDecoder 解码器
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重新装载
    [self.wkWebView reload];
}

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 默认音频视图
    self.hidden = YES;
    /// 设置代理
    self.wkWebView.navigationDelegate = self;
    /// 设置滚动视图
    self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定退出按钮事件
    [[self.leaveButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(whiteboardView:didSelectLeaveButton:)]) {
            [self.delegate whiteboardView:self didSelectLeaveButton:control];
        }
    }];
}

#pragma mark - 添加视图手势
/// 添加视图手势
- (void)appendRecognizer {
    
    /// 添加视图手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.numberOfTapsRequired = 2;
    [self.wkWebView addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 视图手势事件处理
/// 视图手势事件处理
- (void)handleGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    /// SGLOG(@"视图手势事件处理");
}

#pragma mark - 显示视图
/// 显示视图
/// - Parameters:
///   - host: 画板地址
///   - userId: 用户标识
///   - roomNo: 房间号码
///   - readwrite: 是否拥有读写权限
- (void)showView:(NSString *)host userId:(NSString *)userId roomNo:(NSString *)roomNo readwrite:(BOOL)readwrite {
    
    /// 保存是否拥有读写权限
    self.readwrite = readwrite;
    /// 构建请求地址
    NSString *requestUrl = [NSString stringWithFormat:@"%@?roomId=%@&userId=%@", host, roomNo, userId];
    /// 加载电子画板资源
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    /// 添加电子白板手势
    [self appendRecognizer];
    
    /// 设置视图显示
    FWDispatchAscyncOnMainQueue(^{
        [UIView animateWithDuration:0.25 animations:^{
            self.hidden = NO;
        }];
    });
}

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView {
    
    /// 如果拥有读写权限
    if (self.readwrite) {
        /// 退出电子画板时，需要清空画板
        [self clearDrawing];
    }
    /// 重置读写权限
    self.readwrite = NO;
    /// 加载完成指示器事件
    [self hiddenActivityIndicator];
    
    /// 设置视图隐藏
    FWDispatchAscyncOnMainQueue(^{
        [UIView animateWithDuration:0.25 animations:^{
            self.hidden = YES;
        }];
    });
}

#pragma mark - 清空画板
/// 清空画板
- (void)clearDrawing {
    
    /// 创建JavaScript代码
    NSString *inputJS = @"clearAll();";
    /// 执行JavaScript代码
    [self transferJavaScript:inputJS];
}

#pragma mark - 执行JavaScript代码
/// 执行JavaScript代码
/// - Parameter inputJS: 需要注入的JavaScript代码
- (void)transferJavaScript:(NSString *)inputJS {
    
    /// 执行JavaScript代码
    [self.wkWebView evaluateJavaScript:inputJS completionHandler:nil];
}

#pragma mark - 标记加载状态
/// 标记加载状态
- (void)showActivityIndicator {
    
    /// 回调父组件处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteboardLoadingBegin:)]) {
        [self.delegate whiteboardLoadingBegin:self];
    }
}

#pragma mark - 恢复加载状态
/// 恢复加载状态
- (void)hiddenActivityIndicator {
    
    /// 回调父组件处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteboardLoadingFinish:)]) {
        [self.delegate whiteboardLoadingFinish:self];
    }
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
    [self showActivityIndicator];
}

#pragma mark 网页加载失败
/// 网页加载失败
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
///   - error: 错误信息
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    /// 恢复加载状态
    [self hiddenActivityIndicator];
}

#pragma mark 网页加载完毕
/// 网页加载完毕
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    /// 恢复加载状态
    [self hiddenActivityIndicator];
}

#pragma mark 网页加载失败
/// 网页加载失败
/// - Parameters:
///   - webView: 网页视图对象
///   - navigation: 导航对象
///   - error: 错误信息
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    /// 恢复加载状态
    [self hiddenActivityIndicator];
}

#pragma mark ------- UIGestureRecognizerDelegate代理实现 -------
#pragma mark 保证允许同时识别手势
/// 保证允许同时识别手势
/// - Parameters:
///   - gestureRecognizer: 手势识别器
///   - otherGestureRecognizer: 其它手势识别器
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
