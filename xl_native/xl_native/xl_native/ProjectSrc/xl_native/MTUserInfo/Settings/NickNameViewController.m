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
    
    self.title = @"昵称";
}

- (void)viewDidLoad {
    self.isNavBackGroundHiden = NO;
    [super viewDidLoad];
    [self creatUI];
}


-(void)creatUI{

    self.view.backgroundColor = ColorThemeBackground;
//  test
    UIButton * rightBarButton = [[UIButton alloc]init];
    rightBarButton.size = [UIView getSize_width:50 height:50];
    [rightBarButton setTitleColor:RGBFromColor(0x464952) forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont defaultFontWithSize:17];
    rightBarButton.titleLabel.textColor = [UIColor whiteColor] ;
    rightBarButton.enabled = YES;
    [rightBarButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRight = rightBarButton;
//    [self.view addSubview:rightBarButton];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    
// 昵称的View
    UIView * nickNameView = [[UIView alloc]init];
    nickNameView.size = [UIView getSize_width:ScreenWidth height:63];
    nickNameView.left = 0;
    nickNameView.top = 12+self.navBackGround.bottom;
    nickNameView.backgroundColor = [UIColor whiteColor];
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
    
    [nickNameView addSubview:self.nickNameTextField];
    
    [self.nickNameTextField becomeFirstResponder];
}





//-(void)updateUserNickName{
//    if ([GlobalData sharedInstance].userAccount.nickName == nil) {
//
//    }else{
//        self.nickNameTextField.text =[GlobalData sharedInstance].userAccount.nickName;
// }
//}

-(void)btnClcik:(UIButton *)btn{
    
    NSString *nickName = self.nickNameTextField.text.trim;
    if(nickName.length > 0){
        
        NetWork_mt_updateNoodleAccount *request = [[NetWork_mt_updateNoodleAccount alloc] init];
        
    }
    else{
        [UIWindow showTips:@"昵称不能为空！"];
    }
    
    
    
    
    
//    [GlobalFunc event:@"event_submit_new_nickname"];
    if(![[Reachability reachabilityForInternetConnection] isReachable]){
        [self showFaliureHUD:@"没有网络,请先检查网络设置"];
        return;
    }
    
//    0-8个字符，只能是数字，字母，中文。
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{0,7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([pred evaluateWithObject: self.nickNameTextField.text]){
        btn.enabled = NO;
//        __weak __typeof(self) weakSelf = self;
//        NetWork_updateUser * updateUser = [[NetWork_updateUser alloc]init];
//        updateUser.mobile = [GlobalData sharedInstance].loginDataModel.mobile;
//        updateUser.nickName = self.nickNameTextField.text.trim;
//        updateUser.token = [GlobalData sharedInstance].loginDataModel.token;
//        [updateUser showWaitMsg:@"" handle:self];
//        [updateUser startPostWithBlock:^(updateUserRespone *result, NSString *msg, BOOL finished) {
//            if ([result.status isEqualToString:@"1"]) {
//                
//                NSString *dicStr = [[GlobalData sharedInstance].loginDataModel generateJsonStringForProperties];
//                LoginDataModel *modelTemp = [[LoginDataModel alloc]initWithDictionary:[dicStr objectFromJSONString]];
//                modelTemp.nickName = weakSelf.nickNameTextField.text.trim;
//                [GlobalData sharedInstance].loginDataModel = modelTemp;
//                
////                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserStateChange
////                                                                    object:nil];
//                
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            }else{
//                [self showFaliureHUD:msg];
//            }
//        }];

        
    }
    else{
        [self showFaliureHUD:@"昵称格式不正确"];
    }
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- textFiled的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITextField * nickNameTextField = (UITextField *)[self.view viewWithTag:2222];
    [nickNameTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
