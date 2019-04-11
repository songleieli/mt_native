//
//  LoginService.m
//  CMPLjhMobile
//
//  Created by sl on 16/5/16.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "ZJLoginService.h"
#import "ZJLoginViewController.h"
#import "BaseNavigationController.h"

@implementation ZJLoginService


static ZJLoginService *SharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(SharedInstance == nil)
        {
            SharedInstance = [[ZJLoginService alloc] init];
        }
    });
    return SharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if(SharedInstance == nil)
        {
            SharedInstance = [super allocWithZone:zone];
        }
    }
    return SharedInstance;
}

- (void)authenticateWithCompletion:(void (^)(BOOL))complete cancelBlock:(void (^)())cancelBlock isAnimat:(BOOL)isAnimat{
    
//    //test
//    NSDictionary *dic =  [NSString readJson2DicWithFileName:@"user_sl"];  //作品
//
//    LoginResponse *result = [[LoginResponse alloc] initWithDictionary:dic];
//    [GlobalData sharedInstance].hasLogin = YES;
//    [GlobalData sharedInstance].loginDataModel = result.obj;
//
//    complete(YES);
//
//
//    return;
    
    
    
    
    self.completeBlock = complete;
    self.cancelledBlock = cancelBlock;
    /*
     *先检测token 有没有过期，过期后设置 GlobalData 为未登录，同事清空账号
     */
    if([GlobalData sharedInstance].hasLogin == NO){ //没有登陆
        ZJLoginViewController *tempVC = [[ZJLoginViewController alloc] init];

        BaseNavigationController *tempNav = [[BaseNavigationController alloc]initWithRootViewController:tempVC];
        tempNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;

        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:tempNav
                                                                                           animated:isAnimat
                                                                                         completion:^{
                                                                                             /*
                                                                                              *发送弹出模态窗口通知
                                                                                              */
                                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationPresentViewController
                                                                                                                                                 object:nil];
                                                                                             
                                                                                         }];
    }
    else{
        if(self.completeBlock){
            self.completeBlock(YES);
        }
    }
}


- (void)authenticateWithCompletion:(void(^)(BOOL success))complete cancelBlock:(void(^)())cancelBlock showMsgTarget:(BaseViewController *)showMsgTarget isAnimat:(BOOL)isAnimat{
    self.showMsgTarget = showMsgTarget;
    
    [self authenticateWithCompletion:complete cancelBlock:cancelBlock isAnimat:isAnimat];
}



@end
