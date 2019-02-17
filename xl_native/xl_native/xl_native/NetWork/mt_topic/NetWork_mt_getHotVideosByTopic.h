//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//



#import "NetWork_mt_home_list.h"

@interface GetHotVideosByTopicModel : IObjcJsonBase


/*
 "id": 0,
 "topic": "#手工diy",
 "personSum": 0,
 "hotCount": null,
 "playSum": 0,
 "isCollect": 0
 */

@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *topic;
@property (strong, nonatomic) NSNumber *personSum;
@property (strong, nonatomic) NSNumber *hotCount;
@property (strong, nonatomic) NSNumber *playSum;
@property (strong, nonatomic) NSNumber *isCollect;

@end


@interface GetHotVideosByTopicTempModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *hotType;
@property (strong, nonatomic) GetHotVideosByTopicModel *topic;
@property (strong, nonatomic) NSArray *videoList;

@end


@interface GetHotVideosByTopicResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) GetHotVideosByTopicTempModel * obj;

@end

@interface NetWork_mt_getHotVideosByTopic : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * topicName;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
