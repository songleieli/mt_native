//
//  loginViewController.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/16.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "ZJLoginViewController.h"

#import "IHKeyboardAvoiding.h"
#import "ZJLoginService.h"
//#import "GTMBase64.h"

#import "NetWork_mt_login.h"
#import "NetWork_mt_sendSMS.h"

#import "WXApiManager.h"
#import "WeiboSDK.h"
#import "AFHTTPSessionManager.h"



@interface ZJLoginViewController ()<UITextFieldDelegate,YBAttributeTapActionDelegate,ThirdLoginDelegate>{
    
    BOOL _wasKeyboardManagerEnabled;

}



@property(nonatomic,strong)UIButton * btnCancel;
@property(nonatomic,assign)BOOL startOne;
@property(nonatomic,assign)BOOL startTwo;


@property (nonatomic,strong)UIView* bgView;

@property(nonatomic,strong) UIButton * buttonlogin;
@property(nonatomic,strong) UILabel *lableRegister;

@property (nonatomic,copy) NSString * smsId;



@property(nonatomic,strong)UIButton* weChatLogin;//微信登录
@property (nonatomic,strong)UIButton* weBoLogin;//微博登录
@property (nonatomic,strong)UILabel* thirdLogin;//第三方登录文字
@property (nonatomic,strong)UIView* leftThirdLoginLine;//左边很闲
@property (nonatomic,strong)UIView* rightThirdLoginLine;//右边横线

@end

@implementation ZJLoginViewController

#pragma mark  -------------- 懒加载 ---------

- (UIButton *)btnCancel{
    
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIImageView alloc] init];
        _btnCancel.size = [UIView getSize_width:20 height:20];
        _btnCancel.origin = [UIView getPoint_x:20 y:30];
        [_btnCancel setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        _btnCancel.clipsToBounds  = YES;
        [_btnCancel addTarget:self action:@selector(loginCancle) forControlEvents:UIControlEventTouchUpInside];
        //test
//        _btnCancel.backgroundColor = [UIColor redColor];
    }
    return _btnCancel;
}

- (UILabel *)thirdLogin{
    
    if (!_thirdLogin) {
        _thirdLogin = [[UILabel alloc] init];
        _thirdLogin.font = [UIFont systemFontOfSize:MasScale_1080(48)];
        _thirdLogin.textAlignment = NSTextAlignmentCenter;
        _thirdLogin.textColor = RGBFromColor(0xaaaaaa);
        _thirdLogin.text = @"使用第三方账号登录";
    }
    return _thirdLogin;
}

- (void)thirdLoginF{
    
    [_thirdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(70);
    }];
}

- (UIView *)leftThirdLoginLine{
    
    if (!_leftThirdLoginLine) {
        _leftThirdLoginLine = [[UIView alloc] init];
        _leftThirdLoginLine.backgroundColor = RGBFromColor(0xe2e2e2);
    }
    return _leftThirdLoginLine;
}

- (void)leftThirdLoginLineF{
    
    [_leftThirdLoginLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MasScale_1080(150));
        make.height.mas_equalTo(MasScale_1080(3));
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(80);
        make.leading.mas_equalTo(self.view.mas_leading).mas_equalTo(MasScale_1080(64));
    }];
}

- (UIView *)rightThirdLoginLine{
    
    if (!_rightThirdLoginLine) {
        _rightThirdLoginLine =  [[UIView alloc] init];
        _rightThirdLoginLine.backgroundColor = RGBFromColor(0xe2e2e2);
    }
    return _rightThirdLoginLine;
}


- (void)rightThirdLoginLineF{
    
    [_rightThirdLoginLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(_leftThirdLoginLine);
        make.trailing.mas_equalTo(self.view.mas_trailing).mas_equalTo(MasScale_1080(-64));
    }];
}

- (UIButton *)weChatLogin{
    
    if (!_weChatLogin) {
        _weChatLogin = [[UIButton alloc] init];
        [_weChatLogin setImage:[UIImage imageNamed:@"WechatLogin"] forState:UIControlStateNormal];
        [_weChatLogin addTarget:self action:@selector(sendWeChatAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weChatLogin;
}

- (void)weChatLoginF{
    
    [_weChatLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(MasScale_1080(157));
        make.leading.mas_equalTo(self.view.mas_leading).mas_equalTo(MasScale_1080(267));
        make.top.mas_equalTo(self.thirdLogin.mas_bottom).mas_equalTo(MasScale_1080(65));
    }];
}

- (UIButton *)weBoLogin{
    
    if (!_weBoLogin) {
        _weBoLogin = [[UIButton alloc] init];
        [_weBoLogin setImage:[UIImage imageNamed:@"WeboLogin"] forState:UIControlStateNormal];
        [_weBoLogin addTarget:self action:@selector(sendWeiboAuth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weBoLogin;
}


- (void)weBoLoginF{
    
    [_weBoLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(self.weChatLogin);
        make.trailing.mas_equalTo(self.view.mas_trailing).mas_equalTo(MasScale_1080(-267));
    }];
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)initNavTitle{
    //[super initNavTitle]; //不响应BaseView中的方法
}

- (void)dealloc{
    NSLog(@"dealloc");
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotificationUserQQLoginSuccess
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotificationUserQQLoginFail
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CMPZjLifeMobileAppDelegate shareApp].thirddelegate = self;

    [self registerForRemoteNotification];
    [self creatUI];
}


-(void)registerForRemoteNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tencentDidLogin:)
                                                 name:NSNotificationUserQQLoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tencentLoginFail:)
                                                 name:NSNotificationUserQQLoginFail
                                               object:nil];
}



-(void)creatUI{
    
    //模糊效果
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 0.5;
//    [self.view addSubview:visualEffectView];
    [self.view addSubview:self.btnCancel];
//    self.view.backgroundColor = [UIColor clearColor];
    
    
//    self.view.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5); //[UIColor clearColor];
    self.bgView = [[UIView alloc]init];
    self.bgView.size = [UIView getSize_width:ScreenWidth-2*21 height:350];
    self.bgView.top  = sizeScale(70);
    self.bgView.left = 21;
    [self.view addSubview:self.bgView];
    

    //test
//    self.bgView.backgroundColor = [UIColor redColor];
    
    UIImageView * iocnImageView =[[UIImageView alloc]init];
    iocnImageView.size = [UIView getSize_width:85 height:85];
    iocnImageView.left = (self.bgView.width - iocnImageView.width)/2;
    iocnImageView.top = 0;
    iocnImageView.image = [BundleUtil getCurrentBundleImageByName:@"login_icon"]; //[UIImage imageNamed:@"login_icon"];
    iocnImageView.layer.masksToBounds = YES;
    iocnImageView.layer.cornerRadius = 20.0;
    [self.bgView addSubview:iocnImageView];
    
    UIView * userViwe = [[UIView alloc]init];
    userViwe.size = [UIView getSize_width:self.bgView.width height:63];
    userViwe.left = 0;
    userViwe.top = 100;
    [self.bgView addSubview:userViwe];
    
    //test
//    userViwe.backgroundColor = [UIColor blueColor];
    
    self.textFieldUser = [[UITextField alloc]init];
    self.textFieldUser.size = [UIView getSize_width:userViwe.width height:20];
    self.textFieldUser.top = (userViwe.height - self.textFieldUser.height)/2;
    self.textFieldUser.left = 0;
    self.textFieldUser.tag = 10000;
    self.textFieldUser.delegate =self;
    self.textFieldUser.font = [UIFont defaultFontWithSize:14];
    self.textFieldUser.borderStyle = UITextBorderStyleNone;
    self.textFieldUser.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldUser.placeholder = @"请输入手机号";
    [self.textFieldUser addTarget:self action:@selector(textFieldEditingDidChange:) forControlEvents:UIControlEventEditingChanged];
    [userViwe addSubview:self.textFieldUser];

    
    UILabel *lableUser = [[UILabel alloc]init];
    lableUser.size = [UIView getSize_width:60 height:25];
    lableUser.origin = [UIView getPoint_x:0 y:0];
    lableUser.backgroundColor = [UIColor clearColor];
    lableUser.text = @"手机号";
    lableUser.textColor = RGBAlphaColor(167, 167, 167, 1);
    lableUser.font = [UIFont defaultFontWithSize:17];

    self.textFieldUser.leftView = lableUser;
    self.textFieldUser.delegate  = self;
    self.textFieldUser.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel * colorLable = [[UILabel alloc]init];
    colorLable.frame = [UIView getFrame_x:0 y:userViwe.height - 1 width:userViwe.width height:1];
    colorLable.backgroundColor = RGBFromColor(0xecedf1);
    [userViwe addSubview:colorLable];

    //  输入手机短信中的验证码
    UIView * inviteDataView = [[UIView alloc]init];
    inviteDataView.size = [UIView getSize_width:self.bgView.width height:63];
    inviteDataView.left = 0;
    [self.bgView addSubView:inviteDataView frameBottomView:userViwe];
    
    UILabel * labeleinviteDataViewLine = [[UILabel alloc]init];
    labeleinviteDataViewLine.size = [UIView getSize_width:self.bgView.width height:1];
    labeleinviteDataViewLine.left = 0;
    labeleinviteDataViewLine.top = inviteDataView.height -1 ;
    labeleinviteDataViewLine.backgroundColor =RGBFromColor(0xecedf1);
    [inviteDataView addSubview:labeleinviteDataViewLine];
    
    self.textFiledSmsVerify = [[UITextField alloc]init];
    self.textFiledSmsVerify.tag = 10001;
    self.textFiledSmsVerify.size = [UIView getSize_width:inviteDataView.width-80 height:20];
    self.textFiledSmsVerify.top = (inviteDataView.height - self.textFiledSmsVerify.height)/2;
    self.textFiledSmsVerify.left = 0;
    self.textFiledSmsVerify.delegate = self;
    self.textFiledSmsVerify.font = [UIFont defaultFontWithSize:14];
    self.textFiledSmsVerify.borderStyle = UITextBorderStyleNone;
    self.textFiledSmsVerify.keyboardType = UIKeyboardTypeNumberPad;
    self.textFiledSmsVerify.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.textFiledSmsVerify.placeholder = @"请输入手机短信中的验证码";
    [inviteDataView addSubview:self.textFiledSmsVerify];
    
    self.buttonText = [[UIButton alloc]init];
    self.buttonText.size = [UIView getSize_width:80 height:20];
    self.buttonText.left = inviteDataView.width - self.buttonText.width;
    self.buttonText.top = self.textFiledSmsVerify.top;
    [self.buttonText setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.buttonText.tag = 342433;
    
    UILabel * labelButtonText = [[UILabel alloc]init];
    labelButtonText.backgroundColor = RGBFromColor(0xecedf1);
    labelButtonText.left = 0;
    labelButtonText.top = 0;
    labelButtonText.width =1;
    labelButtonText.height = self.buttonText.height;
    [self.buttonText addSubview:labelButtonText];
    
    self.buttonText.titleLabel.font = [UIFont defaultFontWithSize:14];
    [self.buttonText setTitleColor:defaultMainColor forState:UIControlStateNormal];
    [self.buttonText addTarget:self action:@selector(btnClck:) forControlEvents:UIControlEventTouchUpInside];
    [inviteDataView addSubview:self.buttonText];

    self.buttonlogin = [[UIButton alloc]init];
    self.buttonlogin.enabled = NO;
    self.buttonlogin.tag = 92;
    self.buttonlogin.backgroundColor = defaultMainColor;
    [self.buttonlogin setTitleColor:RGBFromColor(0x464952) forState:UIControlStateNormal];
    self.buttonlogin.size = [UIView getSize_width:inviteDataView.width height:sizeScale(40)];
    self.buttonlogin.origin = [UIView getPoint_x:0 y:inviteDataView.bottom + 10];
    [self.buttonlogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.buttonlogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonlogin.backgroundColor = RGBFromColor(0xaaaaaa);
    self.buttonlogin.titleLabel.font = [UIFont defaultFontWithSize:22];
    [self.buttonlogin addTarget:self action:@selector(btnClck:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonlogin.layer.cornerRadius = sizeScale(6);
    
    [IHKeyboardAvoiding setAvoidingView:self.view withTarget:self.bgView];
    
    [self.bgView addSubView:self.buttonlogin frameBottomView:inviteDataView offset:50];
    self.bgView.height = self.buttonlogin.bottom;
    self.bgView.top = (self.view.height - self.bgView.height)/2 - 50;
    
    [self addThirdLogin];
}

#pragma -mark 发送短信验证码请求

- (void)request_mobileCodeWithMsg:(NSString *)msg{
    
//    __weak __typeof(self) weakSelf = self;
    NetWork_mt_sendSMS *sendSms =  [[NetWork_mt_sendSMS alloc] init];
    sendSms.mobile = self.textFieldUser.text.trim;
    [sendSms showWaitMsg:msg handle:self];
    [sendSms startPostWithBlock:^(SendSMSResponse *result, NSString *msg, BOOL finished) {
        
        if (finished) {
            self.smsId = result.obj;
            [self codeReduce];
        }else{
            if(msg != nil && msg.trim.length > 0){
                [self showFaliureHUD:msg];
            }
        }
    }];
}

//倒计时
- (void)codeReduce{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);     dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.buttonText setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.buttonText.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.buttonText setTitle:[NSString stringWithFormat:@"%@ S",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.buttonText.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    /*
     if (self.count == 0) {
     [self.buttonText setEnabled:YES];
     //关闭定时器
     [GlobalData invalidateTimer];
     
     NSString *buttonTitle = @"重获验证码";
     [self.buttonText setTitle:buttonTitle forState:UIControlStateNormal];
     [self.buttonText setTitle:buttonTitle forState:UIControlStateHighlighted];
     return ;
     }
     if (self.buttonText.enabled) {
     [self.buttonText setEnabled:NO];
     }
     NSString *buttonTitle = [NSString stringWithFormat:@"%ld S",(long)--self.count];
     [self.buttonText setTitle:buttonTitle forState:UIControlStateDisabled];
     */
}


#pragma mark 添加第三方登录

- (void)addThirdLogin{
    
    [self.view addSubview:self.thirdLogin];
    [self.view addSubview:self.leftThirdLoginLine];
    [self.view addSubview:self.rightThirdLoginLine];
    [self.view addSubview:self.weChatLogin];
    [self.view addSubview:self.weBoLogin];
    
    [self thirdLoginF];
    [self leftThirdLoginLineF];
    [self rightThirdLoginLineF];
    [self weChatLoginF];
    [self weBoLoginF];
}

- (void)textFieldEditingDidChange:(UITextField *)textField{
    
    if (textField == self.textFieldUser) {
        if (textField.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.textFiledSmsVerify) {
        if (textField.text.length>=20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

-(void)btnClck:(UIButton *)btn{
    
    if(btn.tag == 90){
        [self.view endEditing:YES];
    }
    else if(btn.tag == 91){
        [self.view endEditing:YES];
    }
    else if(btn.tag == 92){
        // 释放键盘
        [self.textFiledSmsVerify resignFirstResponder];
        [self.textFieldUser resignFirstResponder];
        
        [self doLoginAction];
    }
    else if(btn.tag == 93){
        [self.view endEditing:YES];
        [self loginCancle];
    }
    else if(btn.tag == 342433){
        if (self.textFieldUser) {
            if(IsValidPhoneNum(self.textFieldUser.text.trim)&&self.textFieldUser.text.length ==11){
                
                [self request_mobileCodeWithMsg:@"验证码发送中....."];
                
            }else{
                [self showFaliureHUD:@"您输入的手机号格式不正确!"];
            }
        }
        
    }
}

-(void)doLoginAction{
    NSString *userName = self.textFieldUser.text.trim;
    bool mobileResult = IsValidPhoneNum(userName);
    if(!mobileResult){
        [self showFaliureHUD:@"手机号格式有误"];
        return;
    }
    NetWork_mt_login *request = [[NetWork_mt_login alloc] init];
    request.accoutType = @"3";//手机号登录
    request.identifyingCode = self.textFiledSmsVerify.text.trim;
    request.mobile = self.textFieldUser.text.trim;
    request.msgId = self.smsId;
    [request showWaitMsg:@"正在登陆，请稍后......" handle:self];
    [request startPostWithBlock:^(LoginResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            [self deal_loginRespones:result.obj];
        }
        else{
            [UIWindow showTips:@"登录失败，请检查网络！"];
        }
    }];
}


/*处理-登录*/
- (void)deal_loginRespones:(LoginModel *)loginModel{
    
    [GlobalData sharedInstance].hasLogin = YES;
    [GlobalData sharedInstance].loginDataModel = loginModel;
    [self loginSuccessful];
}
//登录成功
- (void)loginSuccessful{
    
    if ([ZJLoginService sharedInstance].completeBlock) {
        [ZJLoginService sharedInstance].completeBlock(YES);
    }
    /*
     *发送登录成功通知
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserLoginSuccess
                                                        object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"发送模态窗口消失通知");
        
        /*
         *发送弹出模态窗口通知
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationDismissViewViewController
                                                            object:nil];
        
    }];
}
//取消成功
- (void)loginCancle{
    if ([ZJLoginService sharedInstance].cancelledBlock) {
        [ZJLoginService sharedInstance].cancelledBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"发送模态窗口消失通知");
        
        /*
         *发送弹出模态窗口通知
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationDismissViewViewController
                                                            object:nil];
        
    }];
}

#pragma mark 微信登录
-(void)sendWeChatAuthRequest{
    
    //第三方向微信终端发送一个SendAuthReq消息结构
        if ([WXApi isWXAppInstalled]) {
        
        SendAuthReq* req =  [[SendAuthReq alloc] init];
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact" ;
        req.state = @"miantiao" ;
        [WXApi sendReq:req];
    }
    else {
        [self showFaliureHUD:@"请先安装微信客户端"];
    }
}

#pragma mark 微信授权成功
- (void)loginSuccessByWechat:(NSString *)code{
    
    NSLog(@"code %@",code);
    
    NetWork_mt_login *request = [[NetWork_mt_login alloc] init];
    request.accoutType = @"1";//微信登录
    request.code = code;
    
    [request showWaitMsg:@"正在登陆，请稍后......" handle:self];
    [request startPostWithBlock:^(LoginResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            [self deal_loginRespones:result.obj];
        }
    }];
    
    return;
}

#pragma mark ------------- 腾讯登录Delegete ------------\

-(void)tencentDidLogin:(NSNotification *)notification{
    
    NSDictionary *resultDic = notification.userInfo;
    NSString  *accessToken = [resultDic objectForKey:@"accessToken"];
    NetWork_mt_login *request = [[NetWork_mt_login alloc] init];
    request.accoutType = @"2";//qq登录
    request.accessToken = accessToken;
    [request showWaitMsg:@"正在登陆，请稍后......" handle:self];
    [request startPostWithBlock:^(LoginResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            [self deal_loginRespones:result.obj];
        }
        else{
            [UIWindow showTips:@"登录失败，请检查网络！"];
        }
    }];
}

-(void)tencentLoginFail:(NSNotification *)notification{
    NSDictionary *resultDic = notification.userInfo;
    NSString  *reson = [resultDic objectForKey:@"reson"];
    [UIWindow showTips:reson];
}


#pragma mark ------------ qq登录 ------------

- (void)sendWeiboAuth{

    //调用qq进行登录
    NSMutableArray * permissions = [[NSMutableArray alloc] initWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    [CMPZjLifeMobileAppDelegate shareApp].oauth.authMode = kAuthModeClientSideToken;
    [[CMPZjLifeMobileAppDelegate shareApp].oauth authorize:permissions inSafari:NO];
}

#pragma mark- textFiled的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - textField代理方法

////限制输入框长度不能超过11位
//-(void)textFieldDidChange:(UITextField *)textField{
//    if (textField == self.textFieldUser) {
//        if (textField.text.length>=11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
//    }
//}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    UIButton * btn = (UIButton *)[self.view viewWithTag:92];
    [self enableOrNotEnable:NO btn:btn];

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"----------");
    
    if (range.location > 0 && range.length == 1 && string.length == 0){
        /*
         *禁用退格清空
         */
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        return NO;
    }
    
    
    
    UIButton * btn = (UIButton *)[self.view viewWithTag:92];
    UITextField * textFeildUesr = [self.view viewWithTag:10000];
    UITextField * textFeildPass = [self.view viewWithTag:10001];
    
    if(range.location == 0 && [string isEqualToString:@""] && textFeildUesr.text.length <=1){
        /*
         * textFeildUesr 退格为空
         */
        NSLog(@"关闭");
        [self enableOrNotEnable:NO btn:btn];
        return YES;
    }
    
    if(range.location == 0 && [string isEqualToString:@""] && textFeildPass.text.length <=1){
        /*
         * textFeildPass 退格为空
         */
        
        NSLog(@"关闭");
        [self enableOrNotEnable:NO btn:btn];
        return YES;
    }
    
    if(textFeildUesr == textField){
        if(textFeildPass.text.trim.length == 0){
            NSLog(@"关闭");
            [self enableOrNotEnable:NO btn:btn];
            return YES;
        }
        
        NSString *passStr = textFeildPass.text.trim;
        if((passStr > 0 && string.length > 0) || (passStr > 0 && textFeildUesr.text.length > 0)){
            NSLog(@"--------启用1-----------");
            self.startOne = YES;
        }
        else{
            self.startOne = NO;
        }
    }
    
    if(textFeildPass == textField){
        if(textFeildUesr.text.trim.length == 0){
            NSLog(@"关闭");
            [self enableOrNotEnable:NO btn:btn];
            return YES;
        }
        
        NSString *userStr = textFeildUesr.text.trim;
        if((userStr > 0 && string.length > 0) || (userStr > 0 && textFeildPass.text.length > 0)){
            NSLog(@"--------启用2-----------");
            self.startTwo = YES;
        }
        else{
            self.startTwo = NO;
        }
    }
    
    if(self.startOne == YES && textFeildPass.text.length > 0){
        NSLog(@"--------启用-------------");
        [self enableOrNotEnable:YES btn:btn];
    }
    
    if(self.startTwo == YES && textFeildUesr.text.length > 0){
        NSLog(@"--------启用-------------");
        [self enableOrNotEnable:YES btn:btn];
    }
    return YES;
}

-(void)enableOrNotEnable:(BOOL)enable btn:(UIButton*)btn{
    if(enable == YES){
        btn.enabled = YES;
        //btn.backgroundColor = RGBFromColor(0xfa555c);
        btn.backgroundColor = MTColorBtnRedNormal;
    }
    else{
        btn.enabled = NO;
        btn.backgroundColor = RGBFromColor(0xaaaaaa);
    }
}


@end
