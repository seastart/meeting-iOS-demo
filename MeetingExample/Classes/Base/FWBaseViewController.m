//
//  FWBaseViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWBaseNavigationViewController.h"

@interface FWBaseViewController ()

@property (nonatomic, assign) BOOL isChild;

@end

@implementation FWBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self defaultSet];
}

- (void)viewWillLayoutSubviews {
    
    if (self.isChild) {
        self.view.frame = self.childRect;
    }
}

#pragma mark - 重写状态栏方法(状态栏是否隐藏)
/// 重写状态栏方法(状态栏是否隐藏)
- (BOOL)prefersStatusBarHidden {
    
    return self.statusHiden;
}

#pragma mark - 重写状态栏方法(状态栏样式)
/// 重写状态栏方法(状态栏样式)
- (UIStatusBarStyle)preferredStatusBarStyle {
    
     return self.barStyle;
}

- (void)defaultSet {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /// 设置默认状态栏样式
    self.barStyle = UIStatusBarStyleDefault;
    if (@available(iOS 13.0, *)) {
        /// YES-不允许下拉关闭，NO-可以下拉关闭
        self.modalInPresentation = YES;
    } else {
        /// Fallback on earlier versions
    }
}

#pragma mark - 横竖屏切换
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    UIInterfaceOrientation val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

#pragma mark - 设置顶部状态栏是否隐藏
- (void)statusBarAppearanceUpdateWithHiden:(BOOL)statusHiden barStyle:(UIStatusBarStyle)barStyle {
    
    /// 标记当前顶部状态栏是否隐藏(YES-隐藏 NO-显示)
    self.statusHiden = statusHiden;
    /// 设置状态栏样式
    self.barStyle = barStyle;
    /// 刷新状态栏
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

#pragma mark - jump
- (void)present:(NSString *)vcName isFullScreen:(BOOL)isFullScreen {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present:(NSString *)vcName isFullScreen:(BOOL)isFullScreen block:(nullable void(^)(id info))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.block = block;
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName block:(nullable void (^)(id))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.block = block;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present:(NSString *)vcName info:(nullable id)info isFullScreen:(BOOL)isFullScreen block:(nullable void(^)(id info))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.info = info;
    vc.block = block;
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName info:(nullable id)info block:(nullable void (^)(id))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.info = info;
    vc.block = block;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag isFullScreen:(BOOL)isFullScreen block:(nullable void (^)(id info))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    vc.info = info;
    vc.block = block;
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag block:(nullable void (^)(id))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    vc.info = info;
    vc.block = block;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag title:(NSString *)titleStr isFullScreen:(BOOL)isFullScreen block:(nullable void (^)(id))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    vc.titleStr = titleStr;
    vc.info = info;
    vc.block = block;
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag title:(NSString *)titleStr block:(nullable void (^)(id))block {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    vc.titleStr = titleStr;
    vc.info = info;
    vc.block = block;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present:(NSString *)vcName tag:(NSInteger)tag isFullScreen:(BOOL)isFullScreen {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:vc];
    if (isFullScreen) {
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)push:(NSString *)vcName tag:(NSInteger)tag {
    
    Class classVC = NSClassFromString(vcName);
    FWBaseViewController *vc = [classVC new];
    vc.tag = tag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop:(NSUInteger)num {
    
    NSArray *vcArr = self.navigationController.viewControllers;
    if (vcArr.count >= num + 1) {
        [self.navigationController popToViewController:vcArr[vcArr.count-num-1] animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 模态返回
- (void)dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - child
- (void)setChildRect:(CGRect)childRect {
    
    _childRect = childRect;
    self.isChild = YES;
    [self viewWillLayoutSubviews];
}

- (void)addChildVC:(FWBaseViewController *)vc rect:(CGRect)rect {
    
    [self addChildViewController:vc];
    vc.childRect = rect;
}

#pragma mark - 获取顶层控制器
/// 获取顶层控制器
- (UIViewController *)topViewController {
    
    UIViewController *resultVC;
    resultVC = [self findTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self findTopViewController:resultVC.presentedViewController];
    }
    
    return resultVC;
}

#pragma mark - 查找顶层控制器
/// 查找顶层控制器
/// @param targetVC 跟结构控制器
- (UIViewController *)findTopViewController:(UIViewController *)targetVC {
    
    if ([targetVC isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[(UINavigationController *)targetVC topViewController]];
    } else if ([targetVC isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[(UITabBarController *)targetVC selectedViewController]];
    } else {
        return targetVC;
    }
    return nil;
}

#pragma mark - 退出房间
- (void)dismissRoom {
    
    __block UIViewController *homePageVC = nil;
    Class hpClass = NSClassFromString(@"FWHomeViewController");
    if (hpClass) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:hpClass]) {
                homePageVC = obj;
                *stop = YES;
            }
        }];
    }
    if (homePageVC) {
        /// 返回首页目录
        [self.navigationController popToViewController:homePageVC animated:YES];
    } else {
        /// 回调上层退出
        if (self.block) {
            self.block(self);
        }
    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
