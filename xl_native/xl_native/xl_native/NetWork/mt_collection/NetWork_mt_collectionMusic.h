//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface CollectionMusicContentModel : IObjcJsonBase

/*
 "noodleId": "136728830",
 "musicId":"343243",
 "musicName":"324232342",
 "coverUrl": "/miantiao/musiccover/20181201/16341217658933248.jpg",
 "playUrl": "/miantiao/music/20181201/16341217658933248.mp3",
 "musicNoodleId":"54353",
 "nickname":"张三"
 */

@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *musicId;
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *playUrl;
@property (copy, nonatomic) NSString *musicNoodleId;
@property (copy, nonatomic) NSString *nickname;


@end



@interface CollectionMusicResponse : IObjcJsonBase

//{"status":"S","obj":45605942833844224,"message":"成功"}


@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSNumber * obj;

@end

@interface NetWork_mt_collectionMusic : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;

@end
