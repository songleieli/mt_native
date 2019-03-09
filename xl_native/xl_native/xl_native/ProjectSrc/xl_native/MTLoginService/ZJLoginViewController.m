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
#import "GTMBase64.h"

#import "NetWork_mt_login.h"

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
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(MasScale_1080(70));
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
        make.top.mas_equalTo(self.bgView.mas_bottom).mas_equalTo(MasScale_1080(100));
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [CMPZjLifeMobileAppDelegate shareApp].thirddelegate = self;

    [self creatUI];
}

-(void)creatUI{
    
    
    
    //模糊效果
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 1;
    [self.view addSubview:visualEffectView];
    
    [self.view addSubview:self.btnCancel];
    
    
    
    
    
    

    self.view.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5); //[UIColor clearColor];
    self.bgView = [[UIView alloc]init];
    self.bgView.size = [UIView getSize_width:ScreenWidth-2*21 height:350];
    self.bgView.top  = sizeScale(70);
    self.bgView.left = 21;
    [self.view addSubview:self.bgView];
    
    self.bgView.backgroundColor = [UIColor clearColor];
    
//    UIImageView * iocnImageView =[[UIImageView alloc]init];
//    iocnImageView.size = [UIView getSize_width:85 height:85];
//    iocnImageView.left = (self.bgView.width - iocnImageView.width)/2;
//    iocnImageView.top = 0;
//    iocnImageView.image = [BundleUtil getCurrentBundleImageByName:@"login_icon"]; //[UIImage imageNamed:@"login_icon"];
//    iocnImageView.layer.masksToBounds = YES;
//    iocnImageView.layer.cornerRadius = 20.0;
//    [self.bgView addSubview:iocnImageView];
    
    UIView * userViwe = [[UIView alloc]init];
    userViwe.size = [UIView getSize_width:self.bgView.width height:63];
    userViwe.left = 0;
    userViwe.top = 100;
    [self.bgView addSubview:userViwe];
//    [self.bgView addSubView:userViwe frameBottomView:iocnImageView offset:42];
    
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
    self.textFieldUser.placeholder = @"请输入账号";
    
    //test
//    self.textFieldUser.text = @"18210225831";
    
    [self.textFieldPass addTarget:self action:@selector(textFieldEditingDidChange:) forControlEvents:UIControlEventEditingChanged];
    [userViwe addSubview:self.textFieldUser];

    
    
    UILabel *lableUser = [[UILabel alloc]init];
    lableUser.size = [UIView getSize_width:40 height:25];
    lableUser.origin = [UIView getPoint_x:0 y:0];
    lableUser.backgroundColor = [UIColor clearColor];
    lableUser.text = @"账号";
    lableUser.textColor = RGBAlphaColor(167, 167, 167, 1);
    lableUser.font = [UIFont defaultFontWithSize:17];
    
    
    
    
    self.textFieldUser.leftView = lableUser;
    self.textFieldUser.delegate  = self;
    self.textFieldUser.leftViewMode = UITextFieldViewModeAlways;
    
    
    UILabel * colorLable = [[UILabel alloc]init];
    colorLable.frame = [UIView getFrame_x:0 y:userViwe.y-1 width:userViwe.width height:1];
    colorLable.backgroundColor = RGBFromColor(0xecedf1);
    [userViwe addSubview:colorLable];
    

    UIView *  passwordViwe = [[UIView alloc]init];
    passwordViwe.size = [UIView getSize_width:self.bgView.width height:63];
    passwordViwe.left = 0;
    [self.bgView addSubView:passwordViwe frameBottomView:userViwe offset:0];
    
    UILabel * passColorLable = [[UILabel alloc]init];
    passColorLable.frame = [UIView getFrame_x:0 y:passColorLable.y-1 width:userViwe.width height:1];
    passColorLable.backgroundColor = RGBFromColor(0xecedf1);
    [passwordViwe addSubview:passColorLable];
    
    self.textFieldPass = [[UITextField alloc]init];
    self.textFieldPass.size = [UIView getSize_width:userViwe.width height:20];
    self.textFieldPass.top = (userViwe.height - self.textFieldPass.height)/2;
    self.textFieldPass.left = 0;
    self.textFieldPass.tag = 10001;
    self.textFieldPass.delegate = self;
    self.textFieldPass.borderStyle = UITextBorderStyleNone;
    self.textFieldPass.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.textFieldPass.placeholder = @"";
    self.textFieldPass.font = [UIFont defaultFontWithSize:14];
    [passwordViwe addSubview:self.textFieldPass];
    
    //test
//    self.textFieldPass.text = @"zhangtao";
    
    [self.textFieldPass addTarget:self action:@selector(textFieldEditingDidChange:) forControlEvents:UIControlEventEditingChanged];

/* 由于不能发送手机短信，暂时先屏蔽忘记密码功能。
    UIButton * forgetButtun = [[UIButton alloc]init];
    forgetButtun.tag = 94;
    forgetButtun.size = [UIView getSize_width:100 height:30];
    forgetButtun.right = passwordViwe.right - 14;
    forgetButtun.titleLabel.font = [UIFont defaultFontWithSize:14];
    forgetButtun.titleLabel.textColor = RGBAlphaColor(70, 73, 82, 1);
    [forgetButtun setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -45)];
    [forgetButtun setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButtun addTarget:self action:@selector(btnClck:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButtun setTitleColor:RGBFromColor(0x464952) forState:UIControlStateNormal];
    [forgetButtun setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [bgView addSubView:forgetButtun frameBottomView:passwordViwe offset:16];
*/
    
//    //test
//    passwordViwe.backgroundColor = [UIColor redColor];
    
    
    
    UILabel *lablePwd = [[UILabel alloc]init];
    lablePwd.size = [UIView getSize_width:40 height:25];
    lablePwd.origin = [UIView getPoint_x:0 y:0];
    lablePwd.backgroundColor = [UIColor clearColor];
    lablePwd.textColor = RGBAlphaColor(167, 167, 167, 1);
    lablePwd.text = @"密码";
    lablePwd.font = [UIFont defaultFontWithSize:17];
    
    self.textFieldPass.leftView = lablePwd;
    self.textFieldPass.placeholder = @"请输入密码";
    self.textFieldPass.leftViewMode = UITextFieldViewModeAlways;
    UIButton * rightButtonPassWorld = [[UIButton alloc]initWithFrame:CGRectMake(0, 5.5, 17, 17)];
    [rightButtonPassWorld setBackgroundImage:[UIImage imageNamed:@"loginview_hidePassworld"] forState:UIControlStateNormal];
    rightButtonPassWorld.tag = 1000;
    [rightButtonPassWorld addTarget:self action:@selector(rightButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    self.textFieldPass.delegate = self;
    self.textFieldPass.rightView = rightButtonPassWorld;
    self.textFieldPass.secureTextEntry = YES;
    self.textFieldPass.rightViewMode = UITextFieldViewModeAlways;
    self.textFieldPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    
    
    
    self.buttonlogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonlogin.enabled = NO;
    self.buttonlogin.tag = 92;
    self.buttonlogin.size = [UIView getSize_width:passwordViwe.width height:sizeScale(40)];
    self.buttonlogin.left = 0;
    self.buttonlogin.layer.cornerRadius = 20;
    self.buttonlogin.layer.masksToBounds = YES;
    [self.buttonlogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.buttonlogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonlogin.backgroundColor = RGBFromColor(0xaaaaaa);
    self.buttonlogin.titleLabel.font = [UIFont defaultFontWithSize:16];
    [self.buttonlogin addTarget:self action:@selector(btnClck:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubView:self.buttonlogin frameBottomView:passwordViwe offset:66];
    
    [IHKeyboardAvoiding setAvoidingView:self.view withTarget:self.bgView];
    
    
    
    
    self.lableRegister = [[UILabel alloc]init];
    self.lableRegister.size = [UIView getSize_width:180 height:25];
    self.lableRegister.origin = [UIView getPoint_x:(self.bgView.width-self.lableRegister.width)/2 y:0];
    self.lableRegister.backgroundColor = [UIColor clearColor];
//    lableRegister.text = @"还没有账号？我要注册";
    self.lableRegister.textColor = RGBAlphaColor(167, 167, 167, 1);
    self.lableRegister.font = [UIFont defaultFontWithSize:16];
    
    NSString *registerStr = @"还没有账号？我要注册";
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:registerStr];
    [attributed addAttribute:NSFontAttributeName
                       value:self.lableRegister.font
                       range:NSMakeRange(0,registerStr.length)]; //设置字体大小
    [attributed addAttribute:NSForegroundColorAttributeName
                       value:XLColorMainPart
                       range:NSMakeRange(6,4)];//设置颜色标签颜色
    
    self.lableRegister.attributedText = attributed;
    [self.lableRegister yb_addAttributeTapActionWithStrings:@[@"我要注册"] delegate:self];
    
    
    [self.bgView addSubView:self.lableRegister frameBottomView:self.buttonlogin offset:10];

    
    self.bgView.height = self.lableRegister.bottom;
    
    //bgView居中
    self.bgView.top = (self.view.height - self.bgView.height)/2-50;
    
    //test
//    self.bgView.backgroundColor = [UIColor redColor];
    
    [self addThirdLogin];
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

- (void)textFieldEditingDidChange:(UITextField *)textField
{
    if (textField == self.textFieldUser) {
        if (textField.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.textFieldPass) {
        if (textField.text.length>=20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }}
-(void)btnClck:(UIButton *)btn{
    
    if(btn.tag == 90){
        [self.view endEditing:YES];
    }
    else if(btn.tag == 91){
        [self.view endEditing:YES];
    }
    else if(btn.tag == 92){
        // 释放键盘
        [self.textFieldPass resignFirstResponder];
        [self.textFieldUser resignFirstResponder];
        
        [self doLoginAction];
    }
    else if(btn.tag == 93){
        [self.view endEditing:YES];
        [self loginCancle];
    }
    else if(btn.tag == 94){ // 忘记密码
        
        [self.view endEditing:YES];
        
//        ZJRetrieveViewController *retrieveViewController = [[ZJRetrieveViewController alloc] init];
//        [self.navigationController pushViewController:retrieveViewController animated:YES];
        
//        ZJForgetPassworldViewController * forgetViewController = [[ZJForgetPassworldViewController alloc]init];
//        [self.navigationController pushViewController:forgetViewController animated:YES];

    }
}

-(void)rightButtonClcik:(UIButton *)btn{
//    [GlobalFunc event:@"event_click_"];
    UITextField * passworldTextFiled = (UITextField *)[self.view viewWithTag:10001];
    
    if (!passworldTextFiled.secureTextEntry) {
        UIButton * rightButtonPassWorld = (UIButton *)[self.view viewWithTag:1000];
        [rightButtonPassWorld setBackgroundImage:[UIImage imageNamed:@"loginview_hidePassworld"] forState:UIControlStateNormal];
        passworldTextFiled.secureTextEntry = YES;
        
    }else{
        UIButton * rightButtonPassWorld = (UIButton *)[self.view viewWithTag:1000];
        [rightButtonPassWorld setBackgroundImage:[UIImage imageNamed:@"loginpPassworldShow"] forState:UIControlStateNormal];
        passworldTextFiled.secureTextEntry = NO;
    }
}

#pragma -mark Custom Method

-(void)gotoRegisterViewController{
    
}

-(void)gotoForgetPasswordViewController{
    
}

-(void)doLoginAction{
    NSString *userName = self.textFieldUser.text.trim;
    NSString *userPassword = self.textFieldPass.text.trim;
    
    
    bool mobileResult = IsValidPhoneNum(userName);
    bool pwdResult = IsValidUserPwd(userPassword);
    
    if(!mobileResult){
        [self showFaliureHUD:@"手机号格式有误"];
        return;
    }
    
    if(!pwdResult){ /*暂时先不验证*/
//        [self showFaliureHUD:@"密码格式有误"];
//        return;
    }
    
//    __weak __typeof (self) weakSelf = self;
//    NetWork_login *request = [[NetWork_login alloc]init];
//    request.mobile = userName;
//    request.password = [userPassword RSA];
//    [request showWaitMsg:@"加载中......" handle:self];
//    [request startPostWithBlock:^(ZjLoginRespone *result, NSString *msg, BOOL finished) {
//        if(finished){
//            weakSelf.buttonlogin.enabled = NO;
//            [weakSelf deal_loginRespones:result userPwd:userPassword];
//            [weakSelf loginSuccessful:userName];
//        }
//        else{
//            [weakSelf showFaliureHUD:msg];
//            weakSelf.buttonlogin.enabled = YES;
//        }
//    }];
}


/*处理-登录*/
- (void)deal_loginRespones:(LoginModel *)loginModel{
    [GlobalData sharedInstance].hasLogin = YES;
    [GlobalData sharedInstance].loginDataModel = loginModel;
    [self loginSuccessful];
}
//登录成功
- (void)loginSuccessful{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUserLoginSuccess
                                                            object:nil];
    });
    
    if ([ZJLoginService sharedInstance].completeBlock) {
        [ZJLoginService sharedInstance].completeBlock(YES);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消成功
- (void)loginCancle{
    if ([ZJLoginService sharedInstance].cancelledBlock) {
        [ZJLoginService sharedInstance].cancelledBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mtLogin:(NSString*)nickname head:(NSString*)head openid:(NSString*)openid {
    
    ContentModel *model = [[ContentModel alloc] init];
    model.nickname = nickname;
    model.wechat_id = @"sdsfd";
    
    
    
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc]init];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:head]];
    //sizeImage = UIImageJPEGRepresentation([GlobalFunc scaleToSizeAlpha:image alpha:alpha], 0.7); //压缩图片质量，保留。
    NSString *key = @"head";
    [fileDic setObject:imageData forKey:key];
    
    
    
//    NetWork_mt_login *request = [[NetWork_mt_login alloc] init];
////    request.head = head;
//    request.content = [model generateJsonStringForProperties];
//    request.uploadFilesDic = fileDic;
//    [request showWaitMsg:@"正在登陆，请稍后......" handle:self];
//    [request startPostWithBlock:^(LoginResponse *result, NSString *msg, BOOL finished) {
//        
//        
//        if(finished){
//            [self deal_loginRespones:result.obj];
//        }
//        NSLog(@"----");
//    }];
    
}

//注册JPush推送标签
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
        NSString *message = [NSString stringWithFormat:@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias];
    
    
//        UIAlertView *alertOne = [[UIAlertView alloc]initWithTitle:@"alias设置成功。" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//        [alertOne show];
    
}




#pragma mark- YBAttributeTapActionDelegate

- (void)yb_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index{
    NSLog(@"%@",string);
    
    
//    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:registerViewController animated:YES];
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

#pragma mark --CMPLjhMobileAppDelegateDelegate
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
        NSLog(@"----");
    }];
    
    
    return;
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",[WCBaseContext sharedInstance].wxAppId,@"cda2546b3248d1986e1a516f14c4d605",code];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        
        NSString *token = [dic objectForKey:@"access_token"];
        NSString *openid = [dic objectForKey:@"openid"];
        
        [self requestUserInfoByToken:token andOpenid:openid];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error.localizedFailureReason);
        
        [self showFaliureHUD:[NSString stringWithFormat:@"登录失败，%@",error.localizedFailureReason]];
    }];
    
    
    
    
    
//    __weak __typeof(self) weakSelf = self;
    
//    NetWork_third_login *request = [[NetWork_third_login alloc] init];
//    request.thirdChannelCode = @"wx";
//    request.appId = [WCBaseContext sharedInstance].wxAppKey;
//    request.code = code;
//    [request showWaitMsg:@"正在处理请稍后..." handle:self];
//    [request startPostWithBlock:^(ThirdLoignRespone *result, NSString *msg, BOOL finished) {
//
//        if(finished){
//            NSLog(@"登录成功");
//            [weakSelf thirdLoginSuccess:result];
//        }
//        else if([result.status isEqualToString:@"10010"]){  //"status":"10010","message":"登录失败，该UUID未绑定帐号",
//            ValidatePhoneViewController* ctl = [[ValidatePhoneViewController alloc] init];
//            ctl.thirdChannelCode = request.thirdChannelCode;
//            ctl.appId = request.appId;
//            ctl.code = request.code;
//            ctl.delegate = self;
//            [weakSelf pushNewVC:ctl animated:YES];
//        }
//        else{
//            [weakSelf showFaliureHUD:msg];
//        }
//    }];
    
}

//第二步：通过code获取access_token





// 第三部 获取用户信息
-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        
        NSString *headimgurl = [dic objectForKey:@"headimgurl"];
        NSString *openid = [dic objectForKey:@"openid"];
        NSString *nickname = [dic objectForKey:@"nickname"];
        
        [self mtLogin:nickname head:headimgurl openid:openid];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error.localizedFailureReason);
        
        [self showFaliureHUD:[NSString stringWithFormat:@"登录失败，%@",error.localizedFailureReason]];
    }];
    
    
}

#pragma mark ------------- 腾讯登录Delegete ------------
//登录成功回调
- (void)tencentDidLogin {
    
    if (_oauth.accessToken && 0 != [_oauth.accessToken length]){
        //记录登录⽤用户的OpenID、Token以及过期时间
        
        NetWork_mt_login *request = [[NetWork_mt_login alloc] init];
        request.accoutType = @"2";//qq登录
        request.accessToken = _oauth.accessToken;
        
        [request showWaitMsg:@"正在登陆，请稍后......" handle:self];
        [request startPostWithBlock:^(LoginResponse *result, NSString *msg, BOOL finished) {
            
            
            if(finished){
                [self deal_loginRespones:result.obj];
            }
            NSLog(@"----");
        }];
    }
    else
    {
        //登录不不成功 没有获取到accesstoken }
    }
}

//⾮非⽹网络错误导致登录失败:
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled){ //⽤用户取消登录
    }
    else{
            //登录失败
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
     //检查⽹网络设置
}

- (void)getUserInfoResponse:(APIResponse*) response{
    
    NSLog(@"--------");
    
}




#pragma mark 微博登录

- (void)sendWeiboAuth{
    
    

    
        //注册腾讯SDK
        NSMutableArray * permissions = [[NSMutableArray alloc] initWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
//        NSString *appid = [WCBaseContext sharedInstance].txAppId;
//        _oauth = [[TencentOAuth alloc] initWithAppId:appid
//                                         andDelegate:self];
    
    [CMPZjLifeMobileAppDelegate shareApp].oauth.authMode = kAuthModeClientSideToken;
    [[CMPZjLifeMobileAppDelegate shareApp].oauth authorize:permissions inSafari:NO];

        //登录授权
//        _oauth.authMode = kAuthModeClientSideToken;
//        [_oauth authorize:permissions inSafari:NO];
    
    
    
//    if ([WeiboSDK isWeiboAppInstalled]) {
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
//        request.redirectURI = [WCBaseContext sharedInstance].sinaCallBackURl;
//        //SCOPE 授权说明参考  http://open.weibo.com/wiki/
//        request.scope = @"all";
//        request.userInfo = nil;
//        [WeiboSDK sendRequest:request];
//    }else{
//        [self showFaliureHUD:@"请先安装微博客户端"];
//    }
    
    
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
        btn.backgroundColor = XLColorMainPart;
    }
    else{
        btn.enabled = NO;
        btn.backgroundColor = RGBFromColor(0xaaaaaa);
    }
}


@end
