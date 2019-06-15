//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

//"version": "1.0.0",
//"force": "false",
//"versionName": "1.0.0",
//"pageUrl": "http://www.baidu.com",
//"description": "常规更新",
//"isAutomate": "false",
//"isAuditPeriod": "false",
//"isDrawActive": "true"


@interface UpgradeModel : IObjcJsonBase

@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *versionName;
@property (copy, nonatomic) NSString *pageUrl;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *des;

@property (assign, nonatomic) BOOL force;
@property (assign, nonatomic) BOOL isAutomate;    //安卓使用，ios 不管
@property (assign, nonatomic) BOOL isAuditPeriod;
@property (assign, nonatomic) BOOL isDrawActive;

@end



@interface UpgradeResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) UpgradeModel * obj;

@end

@interface NetWork_mt_upgrade : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;


@end
