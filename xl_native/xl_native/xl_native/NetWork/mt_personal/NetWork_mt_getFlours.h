//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetFloursModel : IObjcJsonBase


/*
 "id": 19847786472280064,
 "flourId": "136728830",
 "noodleId": "343243",
 "flourHead": " http://p3.pstatp.com/large/689a0009b31979e51231.jpeg ",
 "flourNickname": "火车飞侠1",
 "flourSignature": "天道酬勤1",
 "noodleHead": " http://p3.pstatp.com/large/583e0012c648d3bb41c2.jpeg ",
 "noodleNickname": "大明",
 "noodleSignature": "快乐的一天",
 "status": 1,
 "time": "2018-12-11 10:25:01",
 "isNotice": 0

 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *flourId;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *flourHead;
@property (copy, nonatomic) NSString *flourNickname;
@property (copy, nonatomic) NSString *flourSignature;
@property (copy, nonatomic) NSString *noodleHead;
@property (copy, nonatomic) NSString *noodleNickname;
@property (copy, nonatomic) NSString *noodleSignature;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *isNotice;

@end



@interface GetFloursResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getFlours : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;

@end
