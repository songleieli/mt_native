//
//  loginViewController.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/16.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

//#import "JPUSHService.h"

//#import "RegisterViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ZJLoginViewController : ZJBaseViewController<TencentSessionDelegate>

/*注册成功后，需要带上手机号 RegisterViewController 中调用*/
@property(nonatomic,strong)UITextField * textFieldUser;//userTextField;
@property(nonatomic,strong)UITextField * textFiledSmsVerify;
/** 获取验证码按钮 */
@property(nonatomic,strong) UIButton * buttonText;

@property (nonatomic, strong)TencentOAuth *oauth;


@end
