//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetVideoCollectionModel : IObjcJsonBase

/*
 "id": 2,
 "noodleId": "3234",
 "type": 1,
 "noodleVideoId": 6443570752422677773,
 "videoNoodleId": "5405288",
 "noodleVideoCover": "http://p3.pstatp.com/large/2d88000eb2d094facfb7.jpeg",
 "likeSum": 1339348,
 "collectionTime": "2018/12/14 13:20:12"


 */

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *noodleVideoId;
@property (copy, nonatomic) NSString *videoNoodleId;
@property (copy, nonatomic) NSString *noodleVideoCover;
@property (copy, nonatomic) NSString *likeSum;
@property (copy, nonatomic) NSString *collectionTime;


@end



@interface GetVideoCollectionsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getVideoCollections : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;

@end
