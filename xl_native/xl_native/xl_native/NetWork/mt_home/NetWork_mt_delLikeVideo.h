//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


//@interface ContentModel : IObjcJsonBase
//
//@property (nonatomic,copy) NSString * nickname;
//@property (nonatomic,copy) NSString * qq_id;
//@property (nonatomic,copy) NSString * wechat_id;
//
//@end


@interface DeLikeVideoModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface DelLikeVideoResponse : IObjcJsonBase

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
