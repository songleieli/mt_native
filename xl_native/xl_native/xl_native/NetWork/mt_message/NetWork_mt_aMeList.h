//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface AMeListModel : IObjcJsonBase


/*
 
 "head": "https://p3.pstatp.com/aweme/1080x1080/67220025b90c9351e90d.jpeg",
 "nickname": "Odelia_Wang",
 "noodleId": "136728830",
 "videoCommentId": "14787707834339328",
 "noodleVideoCover": "/miantiao/videocover/20181127/14787707834339328.jpg",
 "type": 1,
 "time": "2018-11-27 12:02:36"

 */

@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *videoCommentId;
@property (copy, nonatomic) NSString *noodleVideoCover;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *time;

@end



@interface AMeListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_aMeList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
