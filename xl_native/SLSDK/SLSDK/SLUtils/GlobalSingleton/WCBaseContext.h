//
// Created by fengshuai on 13-12-3.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>

@class WCPlistHelper;

#define JR_APP_DEVICETOKEN                       @"JR_APP_DEVICETOKEN"
#define JR_ACCOUNT_DEVICEID                      @"JR_ACCOUNT_DEVICEID"
#define JR_ACCOUNT_AUTHORIZATION                 @"JR_ACCOUNT_AUTHORIZATION"
#define JR_ACCOUNT_USERID                        @"JR_ACCOUNT_USERID"

#define JR_ACCOUNT_SIGN                          @"JR_ACCOUNT_SIGN"

@protocol WCNetworkOperationProvider;

@class WCBaseConfiguration;

typedef enum
{
    EASINetworkProvider,
    EMKNetworkProvider,
    EAFNetworkProvider
}ENetworkProviderType;


@interface WCBaseContext : NSObject

+ (WCBaseContext *)sharedInstance;

@property (nonatomic, strong) WCBaseConfiguration *configuration;
@property (nonatomic, strong) WCPlistHelper *plistHelper;
@property (nonatomic, strong, getter=getAppInterfaceServer) NSString *appInterfaceServer;

////面条短视频 微信微博，AppKey 和回调地址
@property (nonatomic, strong, getter=getSinaAppKey) NSString *sinaAppKey;               //sinaAppKey
@property (nonatomic, strong, getter=getSinaCallBackURl) NSString *sinaCallBackURl;      //sina回调地址
@property (nonatomic, strong, getter=getWxAppId) NSString *wxAppId;                      //微信AppKey
@property (nonatomic, strong, getter=getTxAppId) NSString *txAppId;                      //微信AppKey

@property (nonatomic, strong, getter=getShortVideoLicenceURL) NSString *txShortVideoLicenceURL;        //腾讯短视频LicenceURL
@property (nonatomic, strong, getter=getShortVideoLicenceKey) NSString *txShortVideoLicenceKey;        //腾讯短视频LicenceKey

@property (strong, nonatomic,getter=getLatitude,setter=setLatitude:) NSString *latitude;   //当前用户经度
@property (strong, nonatomic,getter=getLongitude,setter=setLongitude:) NSString *longitude; //当前用户纬度

@property(nonatomic, strong, readonly) id <WCNetworkOperationProvider> connectionProvider;


-(NSString *) cacheRootFolder;
-(NSString *) resourceFolder;
-(NSString *) multimediaFolder;
-(NSString *) webPageFolder;
-(NSString *) downloadFolder;

- (NSString *)databasePath;

#pragma mark Startup
-(void)startupWithConfiguration:(WCBaseConfiguration *)configuration;

-(void)saveConfiguration;

@end
