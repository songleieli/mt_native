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
                                          y:self.navBackGround.height - rightButton.height-15];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_m_s_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRight = rightButton;
    
    
    
    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - sizeScale(15)*2
                                               height:self.navBackGround.height-10];
    self.textFieldBgView.origin = [UIView getPoint_x:sizeScale(15) y:0];
    self.textFieldBgView.layer.borderWidth = 0.5;
    self.textFieldBgView.layer.cornerRadius = 5.0;
    self.textFieldBgView.layer.borderColor = defaultLineColor.CGColor;
    self.textFieldBgView.backgroundColor = [UIColor whiteColor];
    [self.navBackGround addSubview:self.textFieldBgView];
    
    
    //取消按钮
    self.cancleButton = [[UIButton alloc]init];
    self.cancleButton.size = [UIView getSize_width:35 height:self.textFieldBgView.height];
    self.cancleButton.origin = [UIView getPoint_x:ScreenWidth y:self.textFieldBgView.top];
    [self.cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:RGBFromColor(0xecedf1) forState:UIControlStateHighlighted];
    self.cancleButton.titleLabel.font = [UIFont defaultFontWithSize:16];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.cancleButton addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackGround addSubview:self.cancleButton];
    
    
    UIView * leftView = [[UIView alloc]init];
    leftView.size = [UIView getSize_width:36 height:36];
    leftView.origin = [UIView getPoint_x:0 y:(self.textFieldBgView.height - leftView.height)/2];
    UIImageView * iamgeViewPassWorld = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 18, 18)];
    iamgeViewPassWorld.image = [UIImage imageNamed:@"main_chaobiao_seach_left"];
    [leftView addSubview:iamgeViewPassWorld];
    [self.textFieldBgView addSubview:leftView];
    
    UIView * rightView = [[UIView alloc]init];
    rightView.tag = 91;
    rightView.size = [UIView getSize_width:36 height:36];
    rightView.origin = [UIView getPoint_x:self.textFieldBgView.width - rightView.width
                                        y:(self.textFieldBgView.height - rightView.height)/2];
    UILabel *lableVertical = [[UILabel alloc] init];
    lableVertical.size = [UIView getSize_width:0.5 height:rightView.height];
    lableVertical.origin = [UIView getPoint_x:0 y:0];
    lableVertical.backgroundColor = defaultZJGrayColor;
    [rightView addSubview:lableVertical];
    
    UIButton * rightButtonPassWorld = [[UIButton alloc]initWithFrame:CGRectMake(9, 9, 18, 18)];
    [rightButtonPassWorld setBackgroundImage:[UIImage imageNamed:@"main_chaobiao_seach_right"] forState:UIControlStateNormal];
    rightButtonPassWorld.tag = 1000;
//    [rightButtonPassWorld addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightButtonPassWorld];
    [self.textFieldBgView addSubview:rightView];
    
    self.textFieldSearchKey = [[UITextField alloc] init];
    //    self.textFieldSearchKey.tag = 93;
    self.textFieldSearchKey.size = [UIView getSize_width:self.textFieldBgView.width - leftView.width - rightView.width
                                                  height:self.textFieldBgView.height];
    self.textFieldSearchKey.origin = [UIView getPoint_x:leftView.right y:0];
    self.textFieldSearchKey.placeholder = @"请输入姓名或手机号";
    self.textFieldSearchKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearchKey.clearsOnBeginEditing = YES;
    self.textFieldSearchKey.delegate = self;
    self.textFieldSearchKey.returnKeyType = UIReturnKeySearch;
    self.textFieldSearchKey.font = [UIFont defaultFontWithSize:16.0];
    self.textFieldSearchKey.backgroundColor = [UIColor whiteColor];
    [self.textFieldBgView addSubview:self.textFieldSearchKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    [self setUpUI];
}

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.size = [UIView getSize_width:15 height:26];
//    rightButton.origin = [UIView getPoint_x:self.view.width - rightButton.width - 25 y:self.navBackGround.height - rightButton.height-15];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_m_s_right"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:rightButton];
}


-(void)backBtnClick:(UIButton*)btn{
//    [self.navigationController popViewControllerAnimated:YES];
    
    if(self.backClickBlock){
        self.backClickBlock();
    }
}

#pragma mark - 键盘 show 与 hide

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    NSLog(@"keyboardWillShow = %d",height);
    
    if(!self.hasKeyBordShow){
        /*
         在调试过过程中发现，keyboardWillShow会多次调用弹起，通过 hasKeyBordShow 判断只有第一次调用才响应以下代码块
         */
//        self.tableView.hidden = NO; //选中关键词的时候需要，弹出TableView
//        self.tableView.height = ScreenHeight-kNavBarHeight_New-self.navBackGround.height-height;
        
        self.textFieldBgView.width = self.textFieldBgView.width - 50;
        self.textFieldSearchKey.width = self.textFieldSearchKey.width - 50;
        self.cancleButton.left = self.cancleButton.left - 50;
        NSArray *subViews = self.textFieldBgView.subviews;
        for(UIView *subView in subViews){
            if(subView.tag > 90){
                subView.left = subView.left - 50;
            }
        }
        
        //test 加载测试数据
//        [self.tableView reloadData];
    }
    self.hasKeyBordShow = YES;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    
    self.hasKeyBordShow = NO;
//    self.tableView.hidden = YES; //键盘小时之后需要隐藏搜索关键字。
    
    
    self.textFieldBgView.width = self.textFieldBgView.width + 50;
    self.textFieldSearchKey.width = self.textFieldSearchKey.width + 50;
    self.cancleButton.left = self.cancleButton.left + 50;
    
    
    NSArray *subViews = self.textFieldBgView.subviews;
    for(UIView *subView in subViews){
        if(subView.tag > 90){
            subView.left = subView.left + 50;
        }
    }
    
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    NSLog(@"keyboardWillHide = %d",height);
    
}


@end
