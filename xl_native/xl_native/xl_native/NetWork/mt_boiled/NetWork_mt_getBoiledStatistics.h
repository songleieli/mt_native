//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"




@interface GetBoiledStatisticsModel : IObjcJsonBase

@property (copy, nonatomic) NSString *waterDesc;
@property (copy, nonatomic) NSString *currDaysDesc;

@end



@interface GetBoiledStatisticsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) GetBoiledStatisticsModel * obj;

@end

@interface NetWork_mt_getBoiledStatistics : WCServiceBase

@property(nonatomic,copy) NSString * currentNoodleId;

@end
