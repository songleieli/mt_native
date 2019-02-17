//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface CollectionTopicContentModel : IObjcJsonBase

/*
 "noodleId": "136728830",
 "topicId": "5454324324",
 "topicName": "#万圣节"
 */

@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *topicId;
@property (copy, nonatomic) NSString *topicName;


@end



@interface CollectionTopicResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSString * obj;

@end

@interface NetWork_mt_collectionTopic : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;

@end
