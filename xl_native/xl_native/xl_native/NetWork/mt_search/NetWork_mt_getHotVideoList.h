//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_home_list.h"


@interface TopicModel : IObjcJsonBase

//"id": 25795855185481728,
//"topic": "#面条万物节生活美学专区",
//"personSum": 0,
//"hotCount": "9653851",
//"playSum": 19307702,
//"isCollect": 0


@property (copy, nonatomic) NSString *topic;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *personSum;
@property (strong, nonatomic) NSNumber *hotCount;
@property (strong, nonatomic) NSNumber *playSum;
@property (strong, nonatomic) NSNumber *isCollect;

@end



@interface GetHotVideoListModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *hotType;
@property (strong, nonatomic) TopicModel *topic;
@property(nonatomic,strong) NSArray * videoList;


@end



@interface GetHotVideoListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getHotVideoList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
