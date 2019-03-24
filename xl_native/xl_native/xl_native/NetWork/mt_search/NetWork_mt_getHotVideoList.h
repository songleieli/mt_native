//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_home_list.h"


@interface TopicModel : IObjcJsonBase

//"id": 25795855185481728,
//"topic": "#面条万物节生活美学专区",
//"personSum": 0,
//"hotCount": "9653851",
//"playSum": 19307702,
//"isCollect": 0


@property (copy, nonatomic) NSString *topic;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *personSum;
@property (strong, nonatomic) NSNumber *hotCount;
@property (strong, nonatomic) NSNumber *playSum;
@property (strong, nonatomic) NSNumber *isCollect;

@end

@interface MusicHotModel : IObjcJsonBase

//"musicId": 6584922963072518919,
//"musicName": "@KillerD创作的原声",
//"musicType": null,
//"coverUrl": "https://p22-dy.bytecdn.cn/aweme/1080x1080/1c9af00026150f891676d.jpeg",
//"playUrl": "http://p3-dy.bytecdn.cn/obj/a10b0002a3b2c4ea81f8",
//"noodleId": "73461915545",
//"nickname": "KillerD",
//"hotCount": "6366806",
//"createTime": "2019-03-03 11:23:58",
//"useCount": 20,
//"isCollect": 0

@property (copy, nonatomic) NSString *musicName;
@property (strong, nonatomic) NSNumber *musicId;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *hotCount;
@property (copy, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSNumber *useCount;
@property (strong, nonatomic) NSNumber *isCollect;


@end



@interface GetHotVideoListModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *hotType;
@property (strong, nonatomic) TopicModel *topic;
@property (strong, nonatomic) MusicHotModel *music;
@property(nonatomic,strong) NSArray * videoList;


@end



@interface GetHotVideoListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getHotVideoList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * noodleId;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
