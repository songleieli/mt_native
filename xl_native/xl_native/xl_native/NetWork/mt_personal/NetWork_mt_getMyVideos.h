//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"
#import "NetWork_mt_home_list.h"



@interface GetMyVideosResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getMyVideos : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;

@end
