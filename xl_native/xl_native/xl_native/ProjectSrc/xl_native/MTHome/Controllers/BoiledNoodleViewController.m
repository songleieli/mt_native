//
//  SettingAboutViewController.m
//  CMPLjhMobile
//
//  Created by Liyanjun on 2017/5/25.
//  Copyright © 2017年 CMP_Ljh. All rights reserved.
//

#import "BoiledNoodleViewController.h"
#import "SharePopView.h"

@interface BoiledNoodleViewController ()<WKNavigationDelegate>

@end

@implementation BoiledNoodleViewController


#pragma mark - 懒加载


- (UIImageView *)viewBoiledNoodles{
    if (!_viewBoiledNoodles){
        _viewBoiledNoodles= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _viewBoiledNoodles.image = [UIImage imageNamed:@"main_zm_bg"];
        _viewBoiledNoodles.userInteractionEnabled = YES;
        
        
        self.lableBoiledTitle = [[UILabel alloc] init];
        self.lableBoiledTitle.width = _viewBoiledNoodles.width*0.64;
        self.lableBoiledTitle.height = 30;
        self.lableBoiledTitle.centerX = _viewBoiledNoodles.width/2; //title水平居中
        self.lableBoiledTitle.top = kNavBarHeight_New + sizeScale(20);
        self.lableBoiledTitle.font = [UIFont defaultBoldFontWithSize:20];
        self.lableBoiledTitle.textAlignment = NSTextAlignmentCenter;
        self.lableBoiledTitle.textColor = [UIColor blackColor];
        
        [_viewBoiledNoodles addSubview:self.lableBoiledTitle];
        //test
//        self.lableBoiledTitle.backgroundColor = [UIColor redColor];
        
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIImageView alloc] init];
        btnClose.size = [UIView getSize_width:20 height:20];
        btnClose.origin = [UIView getPoint_x:20 y:30];
        [btnClose setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        btnClose.clipsToBounds  = YES;
        [btnClose addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBoiledNoodles addSubview:btnClose];
        
        UIButton *btBoiledNoodleRule = [UIButton buttonWithType:UIButtonTypeCustom];
        btBoiledNoodleRule.tag = 90;
        btBoiledNoodleRule.size = [UIView getSize_width:100 height:35];
        btBoiledNoodleRule.top = self.lableBoiledTitle.bottom + sizeScale(50);
        btBoiledNoodleRule.left = 20;
        //        [btBoiledNoodleRule setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        btBoiledNoodleRule.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [btBoiledNoodleRule setTitle:@"煮面规则" forState:UIControlStateNormal];
        [btBoiledNoodleRule setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btBoiledNoodleRule setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btBoiledNoodleRule.clipsToBounds  = YES;
        [btBoiledNoodleRule addTarget:self action:@selector(boiledNoodleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBoiledNoodles addSubview:btBoiledNoodleRule];
        
        UIButton *btBoiledNoodleRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        btBoiledNoodleRecord.tag = 91;
        btBoiledNoodleRecord.size = [UIView getSize_width:100 height:35];
        btBoiledNoodleRecord.top = btBoiledNoodleRule.top;
        btBoiledNoodleRecord.right =  _viewBoiledNoodles.width - 20;
        //        [btBoiledNoodleRule setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        btBoiledNoodleRecord.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [btBoiledNoodleRecord setTitle:@"煮面记录" forState:UIControlStateNormal];
        [btBoiledNoodleRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btBoiledNoodleRecord setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btBoiledNoodleRecord.clipsToBounds  = YES;
        [btBoiledNoodleRecord addTarget:self action:@selector(boiledNoodleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewBoiledNoodles addSubview:btBoiledNoodleRecord];
        
        
        UIImageView *imageViewNoolde = [[UIImageView alloc] init];
        imageViewNoolde.size = [UIView getScaleSize_width:150 height:150];
        imageViewNoolde.centerX = _viewBoiledNoodles.width/2;
        imageViewNoolde.top = btBoiledNoodleRule.bottom + 50;
        [imageViewNoolde setImage:[UIImage imageNamed:@"boiled_noodle"]];
        [_viewBoiledNoodles addSubview:imageViewNoolde];
        
        
        UIButton *btnGetwater = [UIButton buttonWithType:UIButtonTypeCustom];
        btnGetwater.tag = 92;
        btnGetwater.size = [UIView getSize_width:100 height:35];
        btnGetwater.top = imageViewNoolde.bottom + sizeScale(20);
        btnGetwater.left = 20;
        //        [btBoiledNoodleRule setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        btnGetwater.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [btnGetwater setTitle:@"领水" forState:UIControlStateNormal];
        [btnGetwater setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnGetwater setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnGetwater.clipsToBounds  = YES;
        [btnGetwater addTarget:self action:@selector(boiledNoodleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewBoiledNoodles addSubview:btnGetwater];
        
        //test
//        btnGetwater.backgroundColor = [UIColor redColor];
        
        UIButton *btnAddwater = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAddwater.tag = 93;
        btnAddwater.size = [UIView getSize_width:100 height:35];
        btnAddwater.top = imageViewNoolde.bottom + sizeScale(20);
        btnAddwater.right =  _viewBoiledNoodles.width - 20;
        //        [btBoiledNoodleRule setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        btnAddwater.titleLabel.font = [UIFont defaultBoldFontWithSize:18];
        [btnAddwater setTitle:@"加水" forState:UIControlStateNormal];
        [btnAddwater setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAddwater setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnAddwater.clipsToBounds  = YES;
        [btnAddwater addTarget:self action:@selector(boiledNoodleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBoiledNoodles addSubview:btnAddwater];
    }
    return _viewBoiledNoodles;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
        [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)initNavTitle{
    
    [super initNavTitle];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    self.isNavBackGroundHiden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
    [self loadData];
}

#pragma mark ----------- 设置UI -------

- (void)setupUi{
    
    [self.view addSubview:self.viewBoiledNoodles];
    
}

- (void)loadData{
    
    NetWork_mt_getBoiledStatistics *request = [[NetWork_mt_getBoiledStatistics alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(GetBoiledStatisticsResponse *result, NSString *msg, BOOL finished) {
        if(finished){
            self.lableBoiledTitle.text = result.obj.currDaysDesc;
        }
    }];
}


#pragma mark ----------- 点击事件 -------


-(void)boiledNoodleClick:(UIButton*)btn{
    
    if(btn.tag == 90){
        NSLog(@"-------煮面规则-----------");
        
        BoiledNoodleRuleViewController *tempVC = [[BoiledNoodleRuleViewController alloc] init];
        [self pushNewVC:tempVC animated:YES];
    }
    else if (btn.tag == 91){
        NSLog(@"-------煮面记录-----------");
        
        BoiledRecordViewController *tempVC = [[BoiledRecordViewController alloc] init];
        [self pushNewVC:tempVC animated:YES];
    }
    else if (btn.tag == 92){
        NSLog(@"-------领水-----------");
        
        SharePopView *popView = [[SharePopView alloc] init];
        popView.delegate = self;
        [popView show];
        
    }
    else if (btn.tag == 93){
        NSLog(@"-------加水-----------");
        
        NetWork_mt_addWater *request = [[NetWork_mt_addWater alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        [request startPostWithBlock:^(AddWaterResponse *result, NSString *msg, BOOL finished) {
            if(finished){
                [UIWindow showTips:result.obj];
            }
        }];
    }
}


-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
