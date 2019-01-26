//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//


@interface GetFuzzyTopicListModel : IObjcJsonBase


/*
 "id": 25796214314373120,
 "topic": "#wey爱玩出色",
 "hotCount": "30954"

 */


@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *topic;
@property (copy, nonatomic) NSString *hotCount;

@end



@interface GetFuzzyTopicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getFuzzyTopicList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * searchName;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
