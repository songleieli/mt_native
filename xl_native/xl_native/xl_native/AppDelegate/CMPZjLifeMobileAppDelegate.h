//
//  DemoAppDelegate.h
//  
//
//  Created by song leilei on 15/11/13.
//
//

#import "AppDelegateBase.h"
#import "CMPZjLifeMobileRootViewController.h"

#import "AlerViewJoinCostom.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import "WXApiManager.h"

@class ZJHomeViewController;

@import TXLiteAVSDK_UGC_IJK;


@protocol ThirdLoginDelegate <NSObject>

@optional

- (void)loginSuccessByWechat:(NSString *)code;

- (void)loginSuccessByweibo:(NSDictionary*)userInfo;

@end

@interface CMPZjLifeMobileAppDelegate : AppDelegateBase<UIAlertViewDelegate>

@property (nonatomic, assign) id<ThirdLoginDelegate> thirddelegate;


@property (nonatomic, strong) CMPZjLifeMobileRootViewController *rootViewController;
@property (nonatomic, strong) NSDictionary *dicPushUserInfo;
@property (nonatomic, copy) NSString *pushSourceSystemCommunityId;

+(CMPZjLifeMobileAppDelegate *)shareApp;

@end
