//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "GKDouyinHomeSearchViewController.h"

@interface GKDouyinHomeSearchViewController ()

@end

@implementation GKDouyinHomeSearchViewController

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.size = [UIView getSize_width:15 height:26];
    rightButton.origin = [UIView getPoint_x:self.view.width - rightButton.width - 25 y:self.navBackGround.height - rightButton.height];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_m_s_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rightButton];
}


-(void)backBtnClick:(UIButton*)btn{
//    [self.navigationController popViewControllerAnimated:YES];
    
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

@end
