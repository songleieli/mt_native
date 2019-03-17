//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

/*
 "musicId": 6584922963072518919,
 "musicName": "@KillerD创作的原声",
 "coverUrl": "https://p22-dy.bytecdn.cn/aweme/1080x1080/1c9af00026150f891676d.jpeg",
 "playUrl": "http://p3-dy.bytecdn.cn/obj/a10b0002a3b2c4ea81f8",
 "noodleId": "73461915545",
 "nickname": "KillerD",
 "hotCount": "6365224",
 "createTime": "2019-03-03 11:23:58"

 */

@interface MusicSearchModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *musicId;
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *hotCount;
@property (copy, nonatomic) NSString *createTime;

//接口没有，扩展用于下载
@property (copy, nonatomic) NSString *localUrl;//下载音乐时使用

@end



@interface GetSearchMusicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_search_getMusicList : WCServiceBase

//@property (nonatomic,strong) NSString * pageNo;
//@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
