//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

//#import "WCServiceBase.h"
#import "NetWork_mt_home_list.h"

//@interface GetWinnerModel : IObjcJsonBase
//
//
///*
// "noodleId": "12345",
// "nickname": "张三",
// "jiangpinName": "苹果笔记本",
// "wTime": "2019-05-13 19:58:11"
//
// */
//
//@property (nonatomic,copy) NSString * noodleId;
//@property (nonatomic,copy) NSString * nickname;
//@property (nonatomic,copy) NSString * jiangpinName;
//@property (nonatomic,copy) NSString * wTime;
//
//@end

@interface ForwardAppCountResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * obj;

@end

@interface NetWork_mt_forwardAppCount : WCServiceBase

@property(nonatomic,copy) NSString * currentNoodleId;
@property(nonatomic,copy) NSString * forwardType;

@end
