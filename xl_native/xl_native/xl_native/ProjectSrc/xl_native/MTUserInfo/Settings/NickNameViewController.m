//
//  NickNameViewController.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/24.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NickNameViewController.h"
//#import "NetWork_updateUser.h"
@interface NickNameViewController ()<UITextFieldDelegate>{
    
    BOOL _canedit;
    
}

/** 昵称textField */
@property(nonatomic,strong) UITextField * nickNameTextField;

@end

@implementation NickNameViewController

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    UIButton * rightBarButton = [[UIButton alloc]init];
    rightBarButton.size = [UIView getSize_width:50 height:50];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont defaultFontWithSize:17];
    //    rightBarButton.titleLabel.textColor = [UIColor whiteColor] ;
    rightBarButton.enabled = YES;
    [rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = rightBarButton;
    
    self.title = @"昵称";
}

- (void)viewDidLoad {
    self.isNavBackGroundHiden = NO;
    [super viewDidLoad];
    [self creatUI];
}


-(void)creatUI{

    self.view.backgroundColor = ColorThemeBackground;
    

    
// 昵称的View
    UIView * nickNameView = [[UIView alloc]init];
    nickNameView.size = [UIView getSize_width:ScreenWidth height:63];
    nickNameView.left = 0;
    nickNameView.top = 12+self.navBackGround.bottom;
    nickNameView.backgroundColor = ColorThemeBackground;
    [self.view addSubview:nickNameView];
    
    self.nickNameTextField = [[UITextField alloc]init];
    self.nickNameTextField.size = [UIView getSize_width:ScreenWidth-12*2 height:20];
    self.nickNameTextField.tag = 2222;
    self.nickNameTextField.top = (nickNameView.height - self.nickNameTextField.height)/2;
    self.nickNameTextField.left = 12;
    self.nickNameTextField.font = [UIFont defaultFontWithSize:14];
    self.nickNameTextField.borderStyle = UITextBorderStyleNone;
    self.nickNameTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.nickNameTextField.placeholder = @"填写昵称";
    self.nickNameTextField.text = [GlobalData sharedInstance].loginDataModel.nickname;
    self.nickNameTextField.textColor = [UIColor whiteColor];
    
    [nickNameView addSubview:self.nickNameTextField];
    
    [self.nickNameTextField becomeFirstResponder];
}

-(void)btnClcik:(UIButton *)btn{
    
    NSString *nickName = self.nickNameTextField.text.trim;
    if(nickName.length > 0){
        
        UpdateNoodleAccountContentModel *model = [[UpdateNoodleAccountContentModel alloc] init];
        model.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        model.nickname = nickName;
        model.sex = [GlobalData sharedInstance].loginDataModel.sex;
        model.birthday = [GlobalData sharedInstance].loginDataModel.birthday;
        model.school = [GlobalData sharedInstance].loginDataModel.school;
        model.department = [GlobalData sharedInstance].loginDataModel.department;
        model.enrolmentTime = [GlobalData sharedInstance].loginDataModel.enrolmentTime;
        model.company = [GlobalData sharedInstance].loginDataModel.company;
        model.signature = [GlobalData sharedInstance].loginDataModel.signature;
        model.city = [GlobalData sharedInstance].loginDataModel.city;
        model.addr = [GlobalData sharedInstance].loginDataModel.addr;
        model.country = [GlobalData sharedInstance].loginDataModel.country;
        
        NetWork_mt_updateNoodleAccount *request = [[NetWork_mt_updateNoodleAccount alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.content = [model generateJsonStringForProperties];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            if(finished){
                NSLog(@"-------");
                
                LoginModel *tempModel = [GlobalData sharedInstance].loginDataModel;
                tempModel.nickname = nickName;
                [GlobalData sharedInstance].loginDataModel = tempModel;
                
                //用户信息修改成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserInfoChange
                                                                    object:nil];
                
                [self backBtnClick:nil]; //修改成功后返回
            }
            else{
                [UIWindow showTips:msg];
            }
        }];
    }
    else{
        [UIWindow showTips:@"昵称不能为空！"];
    }
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
