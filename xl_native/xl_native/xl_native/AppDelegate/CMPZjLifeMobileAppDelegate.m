//
//  DemoAppDelegate.m
//
//
//  Created by song leilei on 15/11/13.
//
//

#import "CMPZjLifeMobileAppDelegate.h"
#import "TSStorageManager.h"

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
    //注册微博分享
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:[WCBaseContext sharedInstance].sinaAppKey];
    
    //腾讯短视频
    [TXUGCBase setLicenceURL:[WCBaseContext sharedInstance].txShortVideoLicenceURL
                         key:[WCBaseContext sharedInstance].txShortVideoLicenceKey];
    [TXLiveBase setConsoleEnabled:YES];
    NSLog(@"TXUGCBase SDK Version = %@", [TXLiveBase getSDKVersionStr]);
}

- (void)onBaseContextDidStartupWithOptions:(NSDictionary *)launchOptions{
    /*
     *在此处加载通用功能，比如引导页，广告等。。。
     */
    [super onBaseContextDidStartupWithOptions:launchOptions];
    
    /*
     *版本更新
     */
    //[self updateVrsion];
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
