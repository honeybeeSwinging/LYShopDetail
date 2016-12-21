//
//  ViewController.m
//  LYShopDetail
//
//  Created by lly on 16/12/19.
//  Copyright © 2016年 franklin. All rights reserved.
//

#import "ViewController.h"
#import "LYShopDetailHeaderView.h"
#import "LYShopDetailScrollView.h"

#pragma mark -
#pragma mark ------------------GMPShopDetailBottomView-----------------------------------
@interface LYShopDetailBottomView : UIView

@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation LYShopDetailBottomView
- (instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super init];
    if(self){
        self.backgroundColor =[UIColor whiteColor];
        _buttonArray = [NSMutableArray array];
        for(int i=0;i<titleArray.count;i++){
            UIButton *btn = [[UIButton alloc]init];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.tag = i;
            [self addSubview:btn];
            [_buttonArray addObject:btn];
        }
        
        [_buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [_buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self);
        }];
    }
    
    return self;
}
//- (void)bindData:(GMBShopExt *)shop{
//    GMBXpopSupplier *shopSupplier = shop.shopSupplier;
//    int typeNum = (int)shopSupplier.platformType;
//    if (typeNum >2) {
//        self.contractSellerBtn.enabled = NO;
//    }else{
//        self.contractSellerBtn.enabled = YES;
//    }
//    if (shop.userId == GMSingleUserInstance.userId) {
//        self.contractSellerBtn.enabled = NO;
//    }
//}
#pragma mark -
#pragma mark - action
- (void)addtarget:(id)target sel:(SEL)sel{
    for(UIButton *btn in _buttonArray){
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
}

@end

#pragma mark -
#pragma mark - ViewController
@interface ViewController () <LYSelectTabBarDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *mianScrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) LYShopDetailHeaderView *headerView;
@property (nonatomic,strong) LYSelectTabBar *selectBar;
@property (nonatomic,strong) LYShopDetailScrollView *scrollView;
@property (nonatomic,strong) LYShopDetailBottomView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mianScrollView];
    _contentView = [[UIView alloc]init];
    [self.mianScrollView addSubview:_contentView];
    _headerView = [[LYShopDetailHeaderView alloc]init];
    [_contentView addSubview:_headerView];
    [_contentView addSubview:self.selectBar];
    [self configureScrollView];
    [self configureBottomView];
    
    [self configureContraints];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureScrollView{
    _scrollView = [[LYShopDetailScrollView alloc]init];
    [_contentView addSubview:self.scrollView];
}

- (void)configureBottomView{
    _bottomView = [[LYShopDetailBottomView alloc]initWithTitleArray:@[@"宝贝分类",@"领金币",@"联系卖家"]];
    [self.view addSubview:self.bottomView];
}

- (void)configureContraints{
    [self.mianScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mianScrollView);
        make.width.equalTo(self.mianScrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_contentView);
        make.height.mas_equalTo(120);
    }];
    
    [self.selectBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(80));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_contentView);
        make.top.equalTo(self.selectBar.mas_bottom).offset(10);
        make.height.equalTo(@(kScreenHeight-64 -50 -49));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
}


#pragma mark -
#pragma mark - getter and setter
- (LYSelectTabBar *)selectBar{
    if(!_selectBar){
        _selectBar = [[LYSelectTabBar alloc]initTitles:@[@"店铺首页",@"全部宝贝",@"新品上架",@"微淘动态"] images:@[@"tab1",@"tab2",@"tab3",@"tab4"] selectImages:@[@"tab1-on",@"tab2-on",@"tab3-on",@"tab4-on"] indicatorImage:nil];
        _selectBar.delegate = self;
    }
    
    return _selectBar;
}

- (UIScrollView *)mianScrollView{
    if(!_mianScrollView){
        _mianScrollView = [[UIScrollView alloc]init];
        _mianScrollView.delegate = self;
        _mianScrollView.showsVerticalScrollIndicator = NO;
        _mianScrollView.scrollEnabled = true;
        _mianScrollView.bounces = NO;
//        _mianScrollView.backgroundColor = GM_JS_ORDER_COLOR_BG;
    }
    return _mianScrollView;
}

#pragma mark -
#pragma mark - delegate
- (void)tabBar:(LYSelectTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
    NSLog(@"didSelectButtonFrom %ld to %ld",from,to);
}

- (void)tabBar:(LYSelectTabBar *)tabBar willSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
    NSLog(@"willSelectButtonFrom %ld to %ld",from,to);
}

@end
