//
//  FWBaseNavigationViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBaseNavigationViewController.h"
#import "FWMessageViewController.h"
#import "FWRoomViewController.h"

@interface FWBaseNavigationViewController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/// 当前的视图控制器
@property (nonatomic, weak) UIViewController *currentViewController;

@end

@implementation FWBaseNavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 基础配置
    [self config];
}

#pragma mark - 基础配置
/// 基础配置
- (void)config {
    
    if (@available(iOS 13.0, *)) {
        /// 自定义导航栏外观
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        /// 重置背景和阴影属性以显示适合主题的不透明颜色
        [appearance configureWithOpaqueBackground];
        /// 设置标题属性、字体大小和字体颜色等
        [appearance setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSForegroundColorAttributeName : RGBOF(0x333333)}];
        /// 更改背景色为白色
        appearance.backgroundColor = [UIColor whiteColor];
        /// 更改阴影颜色为透明色
        appearance.shadowColor = [UIColor clearColor];
        /// 重置标准外观
        self.navigationBar.standardAppearance = appearance;
        /// 重置滚动边缘外观
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
    } else {
        /// 去除毛玻璃效果
        [self.navigationBar setTranslucent:NO];
        /// 设置标题属性、字体大小和字体颜色等
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSForegroundColorAttributeName : RGBOF(0x333333)}];
        /// 设置背景颜色
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
        /// 去除导航栏背景颜色
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        /// 去除导航栏底部线条颜色
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    /// 设置代理
    self.delegate = self;
    /// 设置手势代理
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark ----- UINavigationControllerDelegate的代理方法 -----
#pragma mark 视图控制器完成push的时候调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController.viewControllers.count == 1) {
        /// 如果堆栈内的视图控制器数量为1，说明只有根控制器，将当前的视图控制器清空，为了下面的方法禁用侧滑手势
        self.currentViewController = nil;
    } else {
        if ([[viewController class] isKindOfClass:[FWRoomViewController class]] || [[viewController class] isKindOfClass:[FWMessageViewController class]]) {
            /// 如果当前push的视图为房间室控制器，置空当前试图控制器用来限制侧滑手势
            self.currentViewController = nil;
        }
        /// 将push进来的视图控制器赋值给当前的视图控制器
        self.currentViewController = viewController;
    }
}

#pragma mark ----- UIGestureRecognizerDelegate的代理方法 -----
#pragma mark 手势将要激活前调用：返回YES允许侧滑手势的激活，返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    /// 首先在这确定是不是我们需要管理的侧滑返回手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if ([self.currentViewController isKindOfClass:[FWRoomViewController class]] || [self.currentViewController isKindOfClass:[FWMessageViewController class]]) {
            /// 如果当前在房间室中，则禁用侧滑手势。
            return NO;
        }
        if (self.currentViewController == self.topViewController) {
            /// 如果当前的视图控制器存在说明堆栈内的控制器数量大于 1，允许激活侧滑手势
            return YES;
        }
        /// 如果当前的视图控制器不存在，则禁用侧滑手势。
        /// 如果在根控制器中不禁用侧滑手势，而且不小心触发了侧滑手势，会导致存放控制器的堆栈混乱(应用假死)
        return NO;
    }
    /// 这里就是非侧滑手势调用的方法啦，统一允许激活
    return YES;
}

#pragma mark - 重载pushViewController方法
/// 重载pushViewController方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        /// 兼容系统版本调整
        if (@available(iOS 13.0, *)) {
            /// 创建返回按钮
            UIButton *buttonItem = [UIButton systemButtonWithImage:[kGetImage(@"icon_common_goback") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:@selector(baseGoBack)];
            /// 设置返回按钮
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem];
        } else {
            /// 创建返回按钮
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[kGetImage(@"icon_common_goback") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(baseGoBack)];
            /// 设置返回按钮
            viewController.navigationItem.leftBarButtonItem = buttonItem;
        }
        /// 设置隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 重载popViewControllerAnimated方法
/// 重载popViewControllerAnimated方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - 重载popToViewController方法
/// 重载popToViewController方法
- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 1) {
        /// 设置显示tabbar
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - 重载popToRootViewControllerAnimated方法
/// 重载popToRootViewControllerAnimated方法
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    if (self.viewControllers.count > 1) {
        /// 设置显示tabbar
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - 返回方法
/// 返回方法
- (void)baseGoBack {
    
    if (self.viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
