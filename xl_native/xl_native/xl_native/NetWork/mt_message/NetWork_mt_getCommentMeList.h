//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetCommentMeListModel : IObjcJsonBase


/*
 
 "id": 20673496887726080,
 "noodleVideoId": 13434798009880576,
 "noodleVideoCover": "/miantiao/videocover/20181123/13434798009880576.jpg",
 "commentNoodleId": "4343523",
 "commentNickname": "火车飞侠",
 "commentHead": "https://p1.pstatp.com/aweme/1080x1080/8378001db3601a2c4b1a.jpeg",
 "commentContent": "这个视频真有意思",
 "likeSum": 0,
 "commentTime": "2018-12-13 17:06:05",
 "parentNoodleId": "136728830",
 "status": 1,
 "isNotice": 1


 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *noodleVideoId;
@property (copy, nonatomic) NSString *noodleVideoCover;
@property (copy, nonatomic) NSString *commentNoodleId;
@property (copy, nonatomic) NSString *commentNickname;
@property (copy, nonatomic) NSString *commentHead;
@property (copy, nonatomic) NSString *commentContent;

@property (strong, nonatomic) NSNumber *likeSum;
@property (copy, nonatomic) NSString *commentTime;
@property (copy, nonatomic) NSString *parentNoodleId;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *isNotice;

@end



@interface GetCommentMeListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getCommentMeList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
