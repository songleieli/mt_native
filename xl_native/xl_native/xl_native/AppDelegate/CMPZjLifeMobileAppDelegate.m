//
//  DemoAppDelegate.m
//
//
//  Created by song leilei on 15/11/13.
//
//

#import "CMPZjLifeMobileAppDelegate.h"
#import "TSStorageManager.h"
#import "WebCacheHelpler.h"
#import "NetWork_mt_upgrade.h"
#import "TUIKit.h"
#import <Bugly/Bugly.h>
#import "GenerateTestUserSig.h"


@interface CMPZjLifeMobileAppDelegate ()<WXApiDelegate>

@end

@implementation CMPZjLifeMobileAppDelegate


#pragma mark ------------------静态方法------------------------
+(CMPZjLifeMobileAppDelegate *)shareApp{
    return (CMPZjLifeMobileAppDelegate *)[UIApplication sharedApplication].delegate;
}


#pragma mark  ------------- 重载基类的方法-------------------

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)onBaseContextWillStartupWithOptions:(NSDictionary *)launchOptions{
    [super onBaseContextWillStartupWithOptions:launchOptions];
    
    /*
     *在此处加载一些配置文件
     */
    [super onBaseContextWillStartupWithOptions:launchOptions];
    
    //打开数据库连接
    [[TSStorageManager sharedStorageManager] open];
    [[WCBaseContext sharedInstance] startupWithConfiguration:[GlobalFunc sharedInstance].gWCOnbConfiguration];
    
    // 李振华添加键盘自动弹起事件
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    //微信注册
    [WXApi registerApp:[WCBaseContext sharedInstance].wxAppId];
    //注册腾讯qq
    NSString *appid = [WCBaseContext sharedInstance].txAppId;
    _oauth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
    
    //友盟
    [UMConfigure initWithAppkey:@"5cea099f3fc1957d2b00004a" channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    
    //腾讯短视频
    [TXUGCBase setLicenceURL:[WCBaseContext sharedInstance].txShortVideoLicenceURL
                         key:[WCBaseContext sharedInstance].txShortVideoLicenceKey];
    [TXLiveBase setConsoleEnabled:YES];
    NSLog(@"TXUGCBase SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    
    [[TUIKit sharedInstance] setupWithAppId:1400354764]; // SDKAppID 可以在 即时通信 IM 控制台中获取
    
    [AMapServices sharedServices].apiKey = @"953f115f5a2e0c843ce82a9ddab30af9";
    
    [self setupBugly];
    
    //_SDKAppID 填写自己控制台申请的sdkAppid
    if (SDKAPPID == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo 尚未配置 SDKAPPID，请前往 GenerateTestUserSig.h 配置" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];
    }
}

- (void)onBaseContextDidStartupWithOptions:(NSDictionary *)launchOptions{
    /*
     *在此处加载通用功能，比如引导页，广告等。。。
     */
    [super onBaseContextDidStartupWithOptions:launchOptions];
    
    /*
     *清理缓存
     */
    
    [[WebCacheHelpler sharedWebCache] clearCache:^(NSString *cacheSize) {
        NSLog(@"-------清理缓存----cacheSize = %@ M----",cacheSize);
    } isClearAllVideoCacle:NO];

    /*
     *检查版本更新
     */
    [MTControlCenter checkVersion];
}

-(UIViewController*)getProjRootViewController{

    NSLog(@"--------- 程序启动预设加载完成 do nothing------");

    NSString *rootViewController = [GlobalFunc sharedInstance].gWCOnbConfiguration.rootViewController;
    CMPZjLifeMobileRootViewController *vc = [[NSClassFromString(rootViewController) alloc] init];
    self.rootViewController = vc;
    return vc;
}

/*
 1.OpenURL是你通过打开一个url的方式打开其它的应用或链接，
 2.handleOpenURL是其它应用通过调用你的app中设置的URL scheme打开你的应用。
 */

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   
    NSString* urlstr = [url absoluteString];
    if ([urlstr hasPrefix:@"wx"]) {//从微信返回面条
        return [WXApi handleOpenURL:url delegate:self];
    }
    if([urlstr hasPrefix:@"tencent"]){//从qq返回面条
        if (YES == [TencentOAuth CanHandleOpenURL:url]){
            return [TencentOAuth HandleOpenURL:url];
        }
    }
    return NO;
}

#pragma mark ------------- Im方法 ------------

- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    //config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    //config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    config.version = [[TIMManager sharedInstance] GetVersion];
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

#pragma mark ------------- 腾讯登录Delegete ------------
//登录成功回调
- (void)tencentDidLogin {
    
    if (_oauth.accessToken && 0 != [_oauth.accessToken length]){
        
        NSDictionary *resultDic = @{@"accessToken":_oauth.accessToken};
        NSNotification *notification =[NSNotification notificationWithName:NSNotificationUserQQLoginSuccess object:nil userInfo:resultDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else{
        //登录不不成功 没有获取到accesstoken }
        NSDictionary *resultDic = @{@"reson":@"没有获得accesstoken"};
        NSNotification *notification =[NSNotification notificationWithName:NSNotificationUserQQLoginFail object:nil userInfo:resultDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
//⾮非⽹网络错误导致登录失败:
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled){ //用户取消登录
        NSDictionary *resultDic = @{@"reson":@"用户取消登录"};
        NSNotification *notification =[NSNotification notificationWithName:NSNotificationUserQQLoginFail object:nil userInfo:resultDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else{
        //登录失败
        NSDictionary *resultDic = @{@"reson":@"用户登录失败"};
        NSNotification *notification =[NSNotification notificationWithName:NSNotificationUserQQLoginFail object:nil userInfo:resultDic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    //检查⽹网络设置
    NSDictionary *resultDic = @{@"reson":@"登录时网络有问题"};
    NSNotification *notification =[NSNotification notificationWithName:NSNotificationUserQQLoginFail object:nil userInfo:resultDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - 子类重载方法
- (void)appRegisterForRemoteNotification :(NSDictionary *)launchOptions{
    /*
     用于重载 注册推送通知。
     */
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_thirddelegate respondsToSelector:@selector(loginSuccessByWechat:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_thirddelegate loginSuccessByWechat:resp2.code];
            }
        }else{ //失败
            //[self.rootViewController showFaliureHUD:[NSString stringWithFormat: @"登录失败，原因%@",resp.errStr]];
        }
    }
}




@end
