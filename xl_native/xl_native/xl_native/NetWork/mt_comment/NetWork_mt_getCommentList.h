//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface CommentListModel : IObjcJsonBase

/*
 "id": 20300226657128448,
 "noodleVideoId": "13434798009880576",
 "commentNoodleId": "4343523",
 "commentNickname": "火车飞侠",
 "commentHead": "https://p1.pstatp.com/aweme/1080x1080/8378001db3601a2c4b1a.jpeg",
 "commentContent": "这个视频真有意思",
 "likeSum": 0,
 "commentTime": "2018-12-12 16:22:51",
 "parentNoodleId": "136728830",
 "status": 1,
 "isNotice": 1

 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *noodleVideoId;
@property (copy, nonatomic) NSString *commentNoodleId;
@property (copy, nonatomic) NSString *commentNickname;
@property (copy, nonatomic) NSString *commentHead;
@property (copy, nonatomic) NSString *commentContent;
@property (copy, nonatomic) NSString *likeSum;
@property (copy, nonatomic) NSString *commentTime;
@property (copy, nonatomic) NSString *parentNoodleId;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *isNotice;

@property (strong, nonatomic) NSNumber *isLike;   //是否喜欢（赞）过


@end



@interface GetCommentListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getCommentList : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleVideoId;

@end
