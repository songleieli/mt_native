//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetTopicCollectionModel : IObjcJsonBase

/*
 "id": 6,
 "noodleId": "2356",
 "type": 2,
 "topicId": 45325325,
 "topicName": "#测试",
 "playSum": 17,
 "collectionTime": "2018/12/14 15:30:31"



 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *topicId;
@property (copy, nonatomic) NSString *topicName;
@property (strong, nonatomic) NSNumber *playSum;
@property (copy, nonatomic) NSString *collectionTime;

@end



@interface GetTopicCollectionsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getTopicCollections : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
