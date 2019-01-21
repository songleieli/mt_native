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
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    
    self.textFieldBgView = [[UIView alloc] init];
    self.textFieldBgView.size = [UIView getSize_width:self.navBackGround.width - 10*2 - leftButton.right
                                               height:self.navBackGround.height];
    self.textFieldBgView.origin = [UIView getPoint_x:10+leftButton.right y:0];
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
    
    
    NSInteger bodyViewHeight = ScreenHeight - kNavBarHeight_New;
    
    
    /*
     *多个参数写法，ZJMyRepairSubViewController 要声明对应的参数名称
     */
    NSDictionary *dicOne = @{@"parameter":@"0",@"delegate":self};
    NSDictionary *dicTwo = @{@"parameter":@"1",@"delegate":self};
    NSDictionary *dicThree = @{@"parameter":@"2",@"delegate":self};
     NSDictionary *dicFour = @{@"parameter":@"3",@"delegate":self};
     NSDictionary *dicFive = @{@"parameter":@"4",@"delegate":self};
    NSArray *arrayParameters = @[dicOne,dicTwo,dicThree,dicFour,dicFive];
    
    self.pageView = [[HYPageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight_New, ScreenWidth, bodyViewHeight)
                                           withTitles:@[@"综合",@"视频",@"用户",@"音乐",@"话题",]
                                  withViewControllers:@[@"HomeSearchResultSubViewController",@"HomeSearchResultSubViewController",@"HomeSearchResultSubViewController",@"HomeSearchResultSubViewController",@"HomeSearchResultSubViewController"]
                                    withParametersDic:arrayParameters];
    
    self.pageView.isTranslucent = NO;
    self.pageView.selectedColor = [UIColor whiteColor];
    self.pageView.unselectedColor = RGBA(120, 122, 132, 1);
    self.pageView.topTabScrollViewBgColor = ColorThemeBackground;
    self.pageView.topTabBottomLineColor = [UIColor grayColor];
    self.pageView.delegate = self;
    
    [self.view addSubview:self.pageView];
}





-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 取消按钮点击事件

-(void)btnCancelClick{
    
    [self.textFieldSearchKey resignFirstResponder];
    
}

#pragma -mark SubCellDelegate

-(void)subCkeckClick:(NSMutableArray *)selectModelList{
    NSLog(@"-------------");
    
//    self.chenkBoxArray = selectModelList;
}

//-(void)subCellClick:(ZjPmsPatrolRecordsModel *)model subType:(NSString*)subType{
//    NSLog(@"-------------");
//
//}

#pragma mark - 键盘 show 与 hide

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{

    if(!self.hasKeyBordShow){
        /*
         在调试过过程中发现，keyboardWillShow会多次调用弹起，通过 hasKeyBordShow 判断只有第一次调用才响应以下代码块
         */
        self.textFieldBgView.width = self.textFieldBgView.width - 50;
        self.textFieldSearchKey.width = self.textFieldSearchKey.width - 50;
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
    
    self.textFieldBgView.width = self.textFieldBgView.width + 50;
    self.textFieldSearchKey.width = self.textFieldSearchKey.width + 50;
    self.cancleButton.left = self.cancleButton.left + 50;
    
    [UIView animateWithDuration:1.0f animations:^{
        self.btnRight.hidden = NO;
    }];
}


@end
