//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultViewController.h"

@interface HomeSearchResultViewController ()

@end

@implementation HomeSearchResultViewController

-(void)dealloc{
    
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)registerForRemoteNotification{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.btnLeft.hidden = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.size = [UIView getSize_width:15 height:26];
    rightButton.origin = [UIView getPoint_x:self.navBackGround.width - rightButton.width-20
                                          y:self.navBackGround.height - rightButton.height-9];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_m_s_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRight = rightButton;
    
    
    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - sizeScale(15)*2 - rightButton.width - 25
                                               height:self.navBackGround.height];
    self.textFieldBgView.origin = [UIView getPoint_x:sizeScale(15) y:0];
    self.textFieldBgView.layer.borderWidth = 0.0;
    self.textFieldBgView.layer.cornerRadius = 5.0;
    self.textFieldBgView.layer.borderColor = defaultLineColor.CGColor;
//    self.textFieldBgView.backgroundColor = [UIColor whiteColor];
    [self.navBackGround addSubview:self.textFieldBgView];
    
    
    //取消按钮
    self.cancleButton = [[UIButton alloc]init];
    self.cancleButton.size = [UIView getSize_width:35 height:36];
    self.cancleButton.origin = [UIView getPoint_x:ScreenWidth y:self.textFieldBgView.height - self.cancleButton.height - 5];
    [self.cancleButton setTitleColor:RGBA(252, 48, 88, 1) forState:UIControlStateNormal];
//    [self.cancleButton setTitleColor:RGBFromColor(0xecedf1) forState:UIControlStateHighlighted];
    self.cancleButton.titleLabel.font = [UIFont defaultFontWithSize:16];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:self.cancleButton];
    
    
    UIView * leftView = [[UIView alloc]init];
    leftView.size = [UIView getSize_width:36 height:36];
    leftView.origin = [UIView getPoint_x:0 y:self.textFieldBgView.height - leftView.height-5];
    leftView.backgroundColor = RGBA(58, 58, 67, 1);
    
    UIImageView * iamgeViewPassWorld = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 18, 18)];
    iamgeViewPassWorld.image = [UIImage imageNamed:@"main_chaobiao_seach_left"];
    [leftView addSubview:iamgeViewPassWorld];
    [self.textFieldBgView addSubview:leftView];
    
    self.textFieldSearchKey = [[UITextField alloc] init];
    self.textFieldSearchKey.size = [UIView getSize_width:self.textFieldBgView.width - leftView.width height:leftView.height];
    self.textFieldSearchKey.origin = [UIView getPoint_x:leftView.right y:self.textFieldBgView.height - self.textFieldSearchKey.height-5];
    self.textFieldSearchKey.placeholder = @"娱乐圈";
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeySearch;
    self.textFieldSearchKey.font = [UIFont defaultFontWithSize:16.0];
    self.textFieldSearchKey.backgroundColor = [UIColor whiteColor];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];
    self.textFieldSearchKey.backgroundColor = RGBA(58, 58, 67, 1);
    [self.textFieldSearchKey setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    [self setUpUI];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    [self.view addSubview:self.mainTableView];
    
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New;
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    self.mainTableView.tableHeaderView = [self getHeadView];
    [self.mainTableView.mj_header beginRefreshing];
//    [self.mainTableView registerClass:MessageCell.class forCellReuseIdentifier:[MessageCell cellId]];
    
//    [self setBackgroundImage:@"img_video_loading"]; //cell 设置背景图

}

-(UIView*)getHeadView{
    
    self.viewHeadBg = [[UIView alloc] init];
    self.viewHeadBg.size = [UIView getSize_width:ScreenWidth height:sizeScale(80)];
    self.viewHeadBg.origin = [UIView getPoint_x:0 y:0];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.size = [UIView getSize_width:ScreenWidth height:0.3];
    lineLabel.top = self.viewHeadBg.height - lineLabel.height;
    lineLabel.left = 0;
    lineLabel.backgroundColor = [UIColor grayColor]; //RGBAlphaColor(222, 222, 222, 0.8);
    [self.viewHeadBg addSubview:lineLabel];
    
    
    NSArray *titleArray = @[@"面粉",@"赞",@"@我的",@"评论"];
    
    //    NSInteger count = titleArray;
    CGFloat width = (CGFloat)self.viewHeadBg.width/titleArray.count;
    CGFloat offX = 0;
    
    
    for (int i = 0; i < titleArray.count; i++){
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(offX, 0, width, self.viewHeadBg.height);
        [self.viewHeadBg addSubview:bgView];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.tag = i;
        imgBtn.size = [UIView getSize_width:bgView.height/2 height:bgView.height/2];
        imgBtn.top = bgView.height/9;
        imgBtn.left = (bgView.width - imgBtn.width)/2;
        [imgBtn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_m_%d",i]];
        [imgBtn setImage:img forState:UIControlStateNormal];
        [bgView addSubview:imgBtn];
        
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = i;
        titleBtn.size = [UIView getSize_width:bgView.width height:25];
        titleBtn.origin = [UIView getPoint_x:0 y:imgBtn.bottom];
        titleBtn.titleLabel.font = [UIFont defaultBoldFontWithSize: 13.0];
        [titleBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [bgView addSubview:titleBtn];
        
        offX += width;
    }
    return self.viewHeadBg;
}


- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    //[self.view addSubview:background];
    [self.view insertSubview:background atIndex:0];
    
    
}


-(void)backBtnClick:(UIButton*)btn{
//    [self.navigationController popViewControllerAnimated:YES];
    
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

#pragma mark - 加载更过

-(void)loadNewData{
    
    NetWork_mt_getHotSearchSix *request = [[NetWork_mt_getHotSearchSix alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetHotSearchSixResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"-------");
    }];
    
    
}

#pragma mark - 取消按钮点击事件

-(void)btnCancelClick{
    
    [self.textFieldSearchKey resignFirstResponder];
    
}

-(void)titleButtonClicked:(UIButton*)btn{
    
}

#pragma mark - 键盘 show 与 hide

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{

    if(!self.hasKeyBordShow){
        /*
         在调试过过程中发现，keyboardWillShow会多次调用弹起，通过 hasKeyBordShow 判断只有第一次调用才响应以下代码块
         */
        self.cancleButton.left = self.cancleButton.left - 50;
        
        [UIView animateWithDuration:1.0f animations:^{
            self.btnRight.hidden = YES;
        }];
    }
    self.hasKeyBordShow = YES;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    
    self.hasKeyBordShow = NO;
    self.cancleButton.left = self.cancleButton.left + 50;
    [UIView animateWithDuration:1.0f animations:^{
        self.btnRight.hidden = NO;
    }];
}


@end
