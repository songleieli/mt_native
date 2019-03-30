//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//


@interface GetFuzzyAccountListModel : IObjcJsonBase

/*
 "id": 4540275182,
 "oldNoodleId": null,
 "noodleId": "LY_268",
 "noodleType": 1,
 "noodleLevel": 1,
 "accountSource": 2,
 "nickname": "Ćrÿśtåł 翊 💭",
 "head": "https://p3.pstatp.com/aweme/1080x1080/9bb30006b7e79e5df427.jpeg",
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
 "registTime": "2018-12-27 20:22:39",
 "income": 0,
 "drawMoney": 0,
 "ifDrawMoney": 0,
 "currIntegral": 0,
 "shenheIntegral": 0,
 "ifDrawIntegral": 0,
 "followSum": 0,
 "flourSum": 0,
 "likeTotal": 0,
 "videoSum": 0,
 "dynamics": 0,
 "likeSum": 0,
 "isFlour": 0

 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *signature;
@property (strong, nonatomic) NSNumber *followSum;
@property (strong, nonatomic) NSNumber *likeTotal;
@property (assign, nonatomic) BOOL isFlour;

@end



@interface GetFuzzyAccountListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getFuzzyAccountList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * searchName;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
