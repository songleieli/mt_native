//
//  GloalData.h
//  君融贷
//
//  Created by admin on 15/10/15.
//  Copyright (c) 2015年 JRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWork_mt_login.h"

@interface GlobalData : NSObject


/*
 *我爱我乡C端
 */

@property (strong, nonatomic) NSTimer *timerCode;//时间对象
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) BOOL hasClickPublicLocationBtn;
@property (strong, nonatomic,getter=getSearchKeyWord,setter=setSearchKeyWord:) NSString *searchKeyWord; //用户搜多地址关键字


@property(nonatomic,assign)BOOL  isNotFirstUse;

@property (strong, nonatomic,getter=getLatitude,setter=setLatitude:) NSString *latitude;   //当前用户经度
@property (strong, nonatomic,getter=getLongitude,setter=setLongitude:) NSString *longitude; //当前用户纬度
@property (strong, nonatomic,getter=getLoginDataModel,setter=setLoginDataModel:) LoginModel *loginDataModel;//登录信息

+ (instancetype)sharedInstance;

+ (void)cleanAccountInfo;

+ (void)deleteWebCache;//清除缓存

@end
