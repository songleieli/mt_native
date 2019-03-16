//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


#import "NetWork_mt_getMusicList.h"


//@interface GetMusicCollectionModel : IObjcJsonBase
//
///*
// "id": 7,
// "noodleId": "43252",
// "type": 3,
// "musicId": 6462212202538470157,
// "musicName": "@颖宝儿Sunny创作的原声",
// "coverUrl": "https://p3.pstatp.com/aweme/1080x1080/5525003a756361ca9e87.jpeg",
// "playUrl": "http://p1.pstatp.com/obj/33910002e1c611df0c2f",
// "musicNoodleId": "54579996202",
// "nickname": "颖宝儿Sunny",
// "collectionTime": "2018/12/14 13:28:23"
//
//
//
//
// */
//
//@property (copy, nonatomic) NSString *id;
//@property (copy, nonatomic) NSString *noodleId;
//@property (copy, nonatomic) NSString *type;
//@property (copy, nonatomic) NSString *musicId;
//@property (copy, nonatomic) NSString *musicName;
//@property (copy, nonatomic) NSString *coverUrl;
//@property (copy, nonatomic) NSString *playUrl;
//@property (copy, nonatomic) NSString *musicNoodleId;
//@property (copy, nonatomic) NSString *nickname;
//@property (copy, nonatomic) NSString *collectionTime;
//
//@end



@interface GetMusicCollectionsResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getMusicCollections : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
