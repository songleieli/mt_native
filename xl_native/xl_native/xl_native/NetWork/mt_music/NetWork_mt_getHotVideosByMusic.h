//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//



#import "NetWork_mt_home_list.h"


@interface GetHotVideosByMusicModel : IObjcJsonBase


/*
 "id": 6606196836371794691,
 "name": "卖了佛轮",
 "coverUrl": "https://p1.pstatp.com/aweme/1080x1080/c16000003f97583dac4.jpeg",
 "playUrl": "http://p1.pstatp.com/obj/d07c000726bdc5e33b12",
 "noodleId": "64126710775",
 "nickname": "已重置",
 "hotCount": null,
 "createTime": "2018-12-26 17:28:47",
 "useCount": 125,
 "isCollect": 0

 */

@property (strong, nonatomic) NSNumber *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *hotCount;
@property (copy, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSNumber *useCount;
@property (strong, nonatomic) NSNumber *isCollect;

@end


@interface GetHotVideosByMusicTempModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *hotType;
@property (strong, nonatomic) GetHotVideosByMusicModel *music;
@property (strong, nonatomic) NSArray *videoList;

@end


@interface GetHotVideosByMusicResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) GetHotVideosByMusicTempModel * obj;

@end

@interface NetWork_mt_getHotVideosByMusic : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * musicId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
