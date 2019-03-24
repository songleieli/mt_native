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
 "musicId": 6641792023554689800,
 "musicName": "@猫眼大明星创作的原声",
 "coverUrl": "https://p1-dy.bytecdn.cn/aweme/1080x1080/18b600003ad88db2f54e3.jpeg",
 "playUrl": "http://p3-dy.bytecdn.cn/obj/ies-music/1621531255439367.mp3",
 "noodleId": "59091697912",
 "nickname": "猫眼大明星",
 "hotCount": "1392389",
 "createTime": "2019-03-05 02:06:34"

 */

@property (strong, nonatomic) NSNumber *musicId;
@property (copy, nonatomic) NSString *musicName;
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
