//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface SaveVideoContentModel : IObjcJsonBase

/*
"noodleId": "136728830",
"nickname":"张三",
"fileId":"",  //腾讯sdk返回的FileId
"noodleVideoCover":"", //腾讯sdk返回的视频封面地址
"storagePath":"",    //腾讯sdk返回的视频地址
"noodleVideoName": null,
"size": "720p",
"stealshowNoodleId": null,
"matchshowNoodleId": null,
"musicId":"",  //如果使用的是别人的音乐获取音乐库的音乐需要传
"musicName": "北极星test",//
"coverUrl": null,
"musicUrl": null,
"title": "#万圣节 #春节 手机倒过来看水中漫步 @赵四 @李六",
"topic": "#万圣节,#春节", //话题用逗号隔开
"aFriends": [{
    "noodle_id": "234324",
    "head":"https://p1.pstatp.com/aweme/1080x1080/75b5000e7686d2722ca7.jpeg",
    "nickname": "赵四"
}, {
    "noodle_id": "23433434",
    "head":"https://p3.pstatp.com/aweme/1080x1080/5535001be3df8ffbe3e8.jpeg",
    "nickname": "李六"
}],
"addr": "北京市东城区体育馆路4号",
"iswholook": 1,
"status": 1
*/



@property (nonatomic,copy) NSString * noodleId;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * fileId;
@property (nonatomic,copy) NSString * noodleVideoCover;
@property (nonatomic,copy) NSString * storagePath;
@property (nonatomic,copy) NSString * noodleVideoName;
@property (nonatomic,copy) NSString * size;
@property (nonatomic,copy) NSString * stealshowNoodleId;
@property (nonatomic,copy) NSString * matchshowNoodleId;
@property (nonatomic,copy) NSString * musicId;
@property (nonatomic,copy) NSString * musicName;
@property (nonatomic,copy) NSString * coverUrl;
@property (nonatomic,copy) NSString * musicUrl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * topic;
@property (nonatomic,copy) NSString * aFriends;
@property (nonatomic,copy) NSString * addr;
@property (nonatomic,copy) NSString * iswholook;
@property (nonatomic,copy) NSString * status;


@end




@interface SaveVideoResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * obj;

@end

@interface NetWork_mt_saveVideo : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * videoCoverFile;
@property (nonatomic,copy) NSString * videoFile;
@property (nonatomic,copy) NSString * musicCoverFile;
@property (nonatomic,copy) NSString * musicFile;

@end
