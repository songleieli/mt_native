//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFuzzyTopicList.h"


//@interface GetTopicListModel : IObjcJsonBase
//
//@property (strong, nonatomic) NSNumber *id;
//@property (copy, nonatomic) NSString *topic;
//@property (strong, nonatomic) NSNumber *hotCount;
//
////"id": 25795855185481728,
////"topic": "#面条万物节生活美学专区",
////"hotCount": "9653851"
//
//
//@end



@interface GetTopicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getTopicList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;

@end
