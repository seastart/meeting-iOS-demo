//
//  FWBaseTabBarViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseNavigationViewController.h"
#import "FWBaseTabBarViewController.h"
#import "FWBaseViewController.h"

@interface FWBaseTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation FWBaseTabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化属性
    [self buildView];
}

#pragma mark - 初始化属性
- (void)buildView {
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        /// 重置背景和阴影属性以显示适合主题的不透明颜色
        [appearance configureWithOpaqueBackground];
        /// 更改背景色为白色
        appearance.backgroundColor = [UIColor whiteColor];
        /// 更改阴影颜色为透明色
        appearance.shadowColor = [UIColor clearColor];
        /// 更改常规模式标题样式
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:RGBOF(0x0039B3)};
        /// 更改选中模式标题样式
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:RGBOF(0x999999)};
        /// 重置标准外观
        self.tabBar.standardAppearance = appearance;
        /// 重置滚动边缘外观
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
        }
    } else {
        /// 去掉UITabBar上面的黑色线条
        self.tabBar.barStyle = UIBarStyleBlack;
        /// 设置UITabBar的颜色
        self.tabBar.translucent = NO;
        self.tabBar.barTintColor = [UIColor whiteColor];
    }
    /// 设置代理
    self.delegate = self;
}

#pragma mark - 初始化首页根控制器
/// 初始化首页根控制器
- (instancetype)initTabBarViewController {
    
    self = [self initWithTitles:@[NSLocalizedString(@"企业服务", nil), NSLocalizedString(@"我的", nil)] vcNames:@[@"FWHomeViewController", @"FWAccountViewController"] images:@[@"icon_tabbar_home_normal", @"icon_tabbar_account_normal"] selectedImages:@[@"icon_tabbar_home_selected", @"icon_tabbar_account_selected"]];
    if (self) {
        /// To Do......
    }
    return self;
}

#pragma mark - 初始化首页根控制器
/// 初始化首页根控制器
/// @param titles 标题列表
/// @param vcNames 控制器名称列表
/// @param images 常规模式icon列表
/// @param selectedImages 选中模式icon列表
- (instancetype)initWithTitles:(NSArray *)titles vcNames:(NSArray *)vcNames images:(NSArray *)images selectedImages:(NSArray *)selectedImages {
    
    self = [super init];
    if (self) {
        /// 创建首页根控制器
        [self createTabBarWithTitles:titles vcNames:vcNames images:images selectedImages:selectedImages];
    }
    return self;
}

#pragma mark - 创建首页根控制器
/// 创建首页根控制器
/// @param titles 标题列表
/// @param classes 控制器名称列表
/// @param images 常规模式icon列表
/// @param selectedImages 选中模式icon列表
- (void)createTabBarWithTitles:(NSArray *)titles vcNames:(NSArray *)classes images:(NSArray *)images selectedImages:(NSArray *)selectedImages {
    
    /// 常规模式标题样式
    NSDictionary *nomalTextDic = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:RGBOF(0x999999)};
    /// 选中模式标题样式
    NSDictionary *selectedTextDic = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:RGBOF(0x0039B3)};
    /// 控制器列表
    NSMutableArray *controlArray = [NSMutableArray array];
    
    /// 构建每一个UITabBarItem
    for (int index = 0;index < titles.count; index++) {
        /// 初始化tabBarItem
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[index] image:kGetImage(images[index]) selectedImage:[kGetImage(selectedImages[index]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [tabBarItem setTitleTextAttributes:nomalTextDic forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:selectedTextDic forState:UIControlStateSelected];
        
        /// 获取控制器
        Class classVC = NSClassFromString(classes[index]);
        /// 初始化控制器
        FWBaseViewController *viewController = [classVC new];
        viewController.titleStr = titles[index];
        viewController.tag = index;
        
        /// 采用 tab-nav 结构
        FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:viewController];
        navigation.tabBarItem = tabBarItem;
        
        /// 添加到控制器列表
        [controlArray addObject:navigation];
    }
    
    /// 将控制器列表添加到TabBar中
    self.viewControllers = controlArray;
}

#pragma mark ----- UITabBarControllerDelegate的代理方法 -----
#pragma mark 确定所点击的按钮(并跳到相应页面)，点击中间tabbarItem，不切换，让当前页面跳转
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

@end
