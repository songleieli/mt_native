//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface ContentModel : IObjcJsonBase

@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * qq_id;
@property (nonatomic,copy) NSString * wechat_id;

@end


@interface LoginModel : IObjcJsonBase




@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *noodleType;
@property (copy, nonatomic) NSString *noodleLevel;
@property (copy, nonatomic) NSString *accountSource;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *noodleVideoId;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *department;
@property (copy, nonatomic) NSString *enrolmentTime;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *businessLicense;
@property (copy, nonatomic) NSString *certifiedPublicletter;
@property (copy, nonatomic) NSString *fullname;
@property (copy, nonatomic) NSString *idCardNo  ;
@property (copy, nonatomic) NSString *signature;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *wechatId;
@property (copy, nonatomic) NSString *wechatInfo1;
@property (copy, nonatomic) NSString *wechatInfo2;
@property (copy, nonatomic) NSString *wechatInfo3;
@property (copy, nonatomic) NSString *qqId;
@property (copy, nonatomic) NSString *qqInfo1;
@property (copy, nonatomic) NSString *qqInfo2;
@property (copy, nonatomic) NSString *qqInfo3;
@property (copy, nonatomic) NSString *weiboId;
@property (copy, nonatomic) NSString *weiboInfo1    ;
@property (copy, nonatomic) NSString *weiboInfo2;
@property (copy, nonatomic) NSString *weiboInfo3;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *registTime;
@property (copy, nonatomic) NSString *income;
@property (copy, nonatomic) NSString *drawMoney ;
@property (copy, nonatomic) NSString *ifDrawMoney;
@property (copy, nonatomic) NSString *currIntegral;
@property (copy, nonatomic) NSString *shenheIntegral;
@property (copy, nonatomic) NSString *ifDrawIntegral;

@end



@interface LoginResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_setting_userAgreement : WCServiceBase

@property (nonatomic,copy) NSString * accoutType;
@property (nonatomic,copy) NSString * code;
@property (nonatomic,copy) NSString * accessToken;

@property (nonatomic,copy) NSString * identifyingCode;
@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * msgId;

@end
