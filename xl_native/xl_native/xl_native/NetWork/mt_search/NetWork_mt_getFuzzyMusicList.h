//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//


@interface GetFuzzyMusicListModel : IObjcJsonBase


/*
 "id": 6595417569664961293,
 "name": "Candy_Land",
 "coverUrl": "https://p1.pstatp.com/aweme/1080x1080/9bb40001fb78af95b386.jpeg",
 "playUrl": "http://p1.pstatp.com/obj/b61f000571ff56932c40",
 "noodleId": "83540885471",
 "nickname": "Mandaa\uD83C\uDF3F",
 "hotCount": "4004926",
 "createTime": "2018-12-27 20:21:16"
 */


@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *hotCount;
@property (copy, nonatomic) NSString *createTime;

@end



@interface GetFuzzyMusicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getFuzzyMusicList : WCServiceBase

@property (nonatomic,strong) NSString * currentNoodleId;
@property (nonatomic,strong) NSString * searchName;
@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;

@end
