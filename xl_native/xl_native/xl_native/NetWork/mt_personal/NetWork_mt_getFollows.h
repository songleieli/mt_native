//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetFollowsModel : IObjcJsonBase


/*
 "id": 21370034085564416,
 "flourId": "18818714082349056",
 "noodleId": "rxx0208",
 "flourHead": "http://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEKD0SkjdicVd1n08TlXMSy1J1DDhJ4BW22DLUWOZDN0lO3leUiaRGrIH9YghUldrhxyhNYiaUaXAOmpw/132",
 "flourNickname": "宋磊磊",
 "flourSignature": null,
 "noodleHead": "https://p1.pstatp.com/aweme/1080x1080/c8560014229e097304d8.jpeg",
 "noodleNickname": "金希",
 "noodleSignature": null,
 "status": 1,
 "time": "2018-12-15 15:13:53",
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



@interface GetFollowsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getFollows : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
