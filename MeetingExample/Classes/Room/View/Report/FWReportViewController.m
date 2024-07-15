//
//  FWReportViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWReportViewController.h"
#import "FWReportCollectionViewCell.h"
#import "FWReportViewModel.h"

/// 定义CollectionViewCell重用标识
static NSString *FWReportCollectionViewCellName = @"FWReportCollectionViewCell";

@interface FWReportViewController () <UIGestureRecognizerDelegate>

/// 幕布背景
@property (weak, nonatomic) IBOutlet UIView *screenView;
/// 退出按钮
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
/// 标题标签
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/// 列表视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/// 描述输入框
@property (weak, nonatomic) IBOutlet UITextView *textView;
/// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

/// 标题文本
@property (strong, nonatomic) NSString *titleText;
/// ViewModel
@property (strong, nonatomic) FWReportViewModel *viewModel;

@end

@implementation FWReportViewController

#pragma mark - 创建实例
/// 创建实例
/// @param titleText 标题
+ (instancetype)creatReportViewWithTitle:(nullable NSString *)titleText {
    
    /// 初始化举报视图
    FWReportViewController *reportVC = [[FWReportViewController alloc] init];
    /// 记录标题
    reportVC.titleText = titleText;
    /// 返回实例
    return reportVC;
}

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 视图完成显示
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    /// 设置背景样式
    self.view.backgroundColor = RGBAOF(0x000000, 0.5);
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 设置ViewModel
    [self setupViewModel];
    /// 设置列表视图
    [self setupCollectionView];
    /// 添加视图手势
    /// [self appendRecognizer];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
/// 设置默认数据
- (void)setupDefaultData {
    
    /// 设置输入框占位符
    self.textView.placeHolder = @"请您描述举报内容，便于平台判断违规情况";
    /// 设置标题
    [self.titleLable setText:self.titleText];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWReportViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 设置列表视图
/// 设置列表视图
- (void)setupCollectionView {
    
    /// 注册CollectionViewCell
    [self.collectionView registerClass:[FWReportCollectionViewCell class] forCellWithReuseIdentifier:FWReportCollectionViewCellName];
}

#pragma mark - 添加视图手势
/// 添加视图手势
- (void)appendRecognizer {
    
    /// 添加视图手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    [self.screenView addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 视图手势事件处理
/// 视图手势事件处理
- (void)handleGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    /// 返回上一层
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听举报描述内容
    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.describeText = text;
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
    
    /// 提交成功订阅
    [self.viewModel.submitSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 置空描述以及输入框数据
        self.textView.text = nil;
        self.viewModel.describeText = nil;
        [SVProgressHUD showInfoWithStatus:@"提交成功"];
        /// 返回上一层
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    /// 绑定退出按钮事件
    [[self.leaveButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 返回上一层
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    /// 绑定提交按钮事件
    [[self.submitButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 提交举报事件
        [self.viewModel onSubmitEvent];
    }];
}

#pragma mark ------- CollectionView&UICollectionViewDataSource代理实现 -------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

#pragma mark 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.viewModel.itemArray.count;
}

#pragma mark 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.frame.size.width - 28) / 3.f, 36);
}

#pragma mark 设置内容整体边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma mark 初始化Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWReportCollectionViewCell *rCell = [collectionView dequeueReusableCellWithReuseIdentifier:FWReportCollectionViewCellName forIndexPath:indexPath];
    [self configReportCell:rCell atIndexPath:indexPath];
    return rCell;
}

#pragma mark 设置项目内容
- (void)configReportCell:(FWReportCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    /// 获取选中状态
    BOOL selected = [self.viewModel.selectedArray containsObject:@(indexPath.row)];
    /// 获取项目数据
    NSDictionary *itemDic = [self.viewModel.itemArray objectAtIndex:indexPath.row];
    /// 赋值显示
    [cell setupWithSelected:selected titleText:[itemDic objectForKey:@"title"]];
}

#pragma mark Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 获取选中状态
    BOOL selected = [self.viewModel.selectedArray containsObject:@(indexPath.row)];
    if (selected) {
        /// 移除选中项
        [self.viewModel.selectedArray removeObject:@(indexPath.row)];
    } else {
        /// 添加选中项
        [self.viewModel.selectedArray addObject:@(indexPath.row)];
    }
    /// 刷新列表
    [self.collectionView reloadData];
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

@end
