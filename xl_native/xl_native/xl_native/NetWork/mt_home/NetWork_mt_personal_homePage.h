//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface PersonalContentModel : IObjcJsonBase

@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * qq_id;
@property (nonatomic,copy) NSString * wechat_id;

@end


@interface PersonalModel : IObjcJsonBase

/*
"id": 77474337343,
"oldNoodleId": null,
"noodleId": "136728830",
"noodleType": 1,
"noodleLevel": 1,
"accountSource": 2,
"nickname": "Odelia_Wang",
"head": "https://p3.pstatp.com/aweme/1080x1080/67220025b90c9351e90d.jpeg",
"sex": "2",
"birthday": null,
"school": null,
"department": null,
"enrolmentTime": null,
"company": null,
"businessLicense": null,
"certifiedPublicletter": null,
"fullname": null,
"idCardNo": null,
"signature": null,
"city": null,
"addr": null,
"country": null,
"password": null,
"mobile": null,
"wechatId": null,
"wechatInfo1": null,
"wechatInfo2": null,
"wechatInfo3": null,
"qqId": null,
"qqInfo1": null,
"qqInfo2": null,
"qqInfo3": null,
"weiboId": null,
"weiboInfo1": null,
"weiboInfo2": null,
"weiboInfo3": null,
"status": 1,
"registTime": "2017-11-26 07:50:38",
"income": 0,
"drawMoney": 0,
"ifDrawMoney": 0,
"currIntegral": 0,
"shenheIntegral": 0,
"ifDrawIntegral": 0,
"followSum": 1,
"flourSum": 2,
"likeTotal": 3785785,
"videoSum": 11,
"dynamics": 11,
"likeSum": 0
*/



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
@property (assign, nonatomic) BOOL isFlour;

//数量
@property (strong, nonatomic) NSNumber *likeTotal;   //获赞数
@property (strong, nonatomic) NSNumber *likeSum;   //我喜欢的
@property (strong, nonatomic) NSNumber *followSum; //关注数
@property (strong, nonatomic) NSNumber *flourSum;   //粉丝数
@property (strong, nonatomic) NSNumber *videoSum;   //作品数
@property (strong, nonatomic) NSNumber *dynamics;   //动态书

@end



@interface PersonalHomePageResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) PersonalModel * obj;

@end

@interface NetWork_mt_personal_homePage : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * noodleId;

@end
