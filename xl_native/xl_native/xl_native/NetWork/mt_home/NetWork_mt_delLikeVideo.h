//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

//#import "WCServiceBase.h"


@interface DeLikeVideoModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface DeLikeVideoResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_delLikeVideo : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * noodleVideoId;
@property (nonatomic,copy) NSString * noodleVideoCover;
@property (nonatomic,copy) NSString * noodleId;


@end
