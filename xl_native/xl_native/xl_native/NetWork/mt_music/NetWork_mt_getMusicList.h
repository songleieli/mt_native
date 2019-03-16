//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

/*
 "id": 16341217818316800,
 "name": null,
 "coverUrl": "/miantiao/musiccover/20181201/16341217658933248.jpg",
 "playUrl": "/miantiao/music/20181201/16341217658933248.mp3",
 "noodleId": "16330762903228416",
 "nickname": "宋磊磊",
 "hotCount": null

 */

@interface MusicModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *hotCount;

//下载本地音乐到本地的路径
@property (copy, nonatomic) NSString* localUrl;
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSString *musicId;


@end



@interface GetMusicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getMusicList : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
