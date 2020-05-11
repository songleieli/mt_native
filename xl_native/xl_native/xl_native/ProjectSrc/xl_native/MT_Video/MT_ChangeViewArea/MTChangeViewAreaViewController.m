//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTChangeViewAreaViewController.h"

@interface MTChangeViewAreaViewController ()


@end

@implementation MTChangeViewAreaViewController

#pragma mark =========== 懒加载 ===========

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.navBackGround.height = kNavBarHeight_New; //状态栏的高度
    
    self.navBackGround.backgroundColor = [UIColor whiteColor];
    
    self.title = @"切换景区";
    
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:20];
    self.lableNavTitle.textColor = [UIColor blackColor];
    
    [self.btnLeft setBackgroundImage:[UIImage imageNamed:@"gray_back"] forState:UIControlStateNormal];

    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftButton.size = [UIView getSize_width:100 height:30];
//    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
//    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [leftButton setTitle:@"切换景区" forState:UIControlStateNormal];
//    leftButton.backgroundColor = [UIColor blueColor];
////    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
//
//    self.btnLeft = leftButton;
}

-(void)dealloc{
    /*
     *移除页面中的观察者
     */
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
//    self.view.backgroundColor = ColorThemeBackground;
//    [self.view addSubview:self.collectionView];
//
//    self.collectionView.top = kNavBarHeight_New;
//    self.collectionView.height = ScreenHeight - kTabBarHeight_New - kNavBarHeight_New;
//    self.collectionView.mj_footer = nil;
//    self.collectionView.mj_header = nil;
}

-(void)changeViewAreaClick{
    
}


@end
