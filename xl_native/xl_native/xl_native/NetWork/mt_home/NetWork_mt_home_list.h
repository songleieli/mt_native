//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface ATFriendsModel : IObjcJsonBase

@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *nickname;


//"noodleId": "1963807587",
//"head": "https://p3-dy.bytecdn.cn/aweme/1080x1080/18bcf0002a066274f8e00.jpeg",
//"nickname": "潘长江"

@end


/*
 {
 "noodleVideoId": 987654321087654326,
 "noodleId": "123456789012345673",
 "noodleVideoName": "我会火的5",
 "noodleVideoCover": "http://192.168.180.130/miantiao/cover/20181115/987654321087654326.jpg",
 "videoUrl": "http://192.168.180.130/miantiao/video/20181115/987654321087654326.mp4",
 "size": "100",
 "stealshowNoodleId": null,
 "matchshowNoodleId": null,
 "musicUrl": "http://192.168.180.130/miantiao/music/20181115/987654321087654326.mp3",
 "title": "我会火的5",
 "topic": "#万圣节",
 "addr": "天安门广场",
 "iswholook": 1,
 "likeSum": 3237,
 "dslikeSum": 0,
 "forwardWechatFriendSum": 2,
 "forwardCircleofFriendSum": 25,
 "forwardQQFriendSum": 2,
 "forwardQQzoneSum": 2,
 "generateNvQrcodeSum": 0,
 "saveAlbumSum": 0,
 "copyLinkSum": 0,
 "stealshowSum": 1,
 "matchshowSum": 1,
 "status": 1,
 "head": "http://192.168.180.130/miantiao/head/20181115/123456789012345673.jpg",
 "nickname": "火车飞侠5",
 "forwardSum": 31,
 "commentSum": 0,
 "createTime": "2018-11-15 11:11:46"
 }
 
 {
 "noodleVideoId": 6526434091481435406,
 "noodleId": "136728830",
 "noodleVideoName": null,
 "noodleVideoCover": "http://p3.pstatp.com/large/689a0009b31979e51231.jpeg",
 "storagePath": "https://aweme.snssdk.com/aweme/v1/play/?video_id=436fd6e1056c4e83960d5091fc2505c7&line=1&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0",
 "size": "720p",
 "stealshowNoodleId": null,
 "matchshowNoodleId": null,
 "musicName": "北极星",
 "coverUrl": null,
 "musicUrl": null,
 "title": "手机倒过来看水中漫步",
 "topic": null,
 "addr": "{\"address\":\"体育馆路4号\",\"province\":\"北京市\",\"city\":\"北京市\",\"district\":\"东城区\",\"id\":\"B0FFHEDXCA\",\"place\":\"晰奇水漾花样游泳俱乐部\",\"postal_code\":\"080110\",\"full\":\"北京市东城区体育馆路4号\"}",
 "iswholook": 1,
 "playSum": 0,
 "likeSum": 3785785,
 "dslikeSum": 0,
 "forwardWechatFriendSum": 0,
 "forwardCircleofFriendSum": 0,
 "forwardQQFriendSum": 0,
 "forwardQQzoneSum": 0,
 "generateNvQrcodeSum": 0,
 "saveAlbumSum": 0,
 "copyLinkSum": 0,
 "stealshowSum": 0,
 "matchshowSum": 0,
 "status": 1,
 "head": "https://p3.pstatp.com/aweme/1080x1080/67220025b90c9351e90d.jpeg",
 "nickname": "Odelia_Wang",
 "forwardSum": 0,
 "commentSum": 0,
 "createTime": "2018-02-25 18:17:37",
 "videoSource": 2,
 "ads": false
 },
 
 */

@interface HomeListModel : IObjcJsonBase

@property (strong, nonatomic) NSNumber *noodleVideoId;
@property (copy, nonatomic) NSString *noodleId;
@property (copy, nonatomic) NSString *noodleVideoName;
@property (copy, nonatomic) NSString *noodleVideoCover;
@property (copy, nonatomic) NSString *signature;
@property (copy, nonatomic) NSString *storagePath;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *stealshowNoodleId;
@property (copy, nonatomic) NSString *matchshowNoodleId;
@property (copy, nonatomic) NSString *musicUrl;
@property (strong, nonatomic) NSNumber *musicId;
@property (copy, nonatomic) NSString *coverUrl;
@property (copy, nonatomic) NSString *musicName;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *topic;
@property(nonatomic,strong) NSArray * aFriends;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSString *iswholook;
@property (strong, nonatomic) NSNumber *likeSum;
@property (copy, nonatomic) NSString *dslikeSum;
@property (copy, nonatomic) NSString *forwardWechatFriendSum;
@property (copy, nonatomic) NSString *forwardCircleofFriendSum;
@property (copy, nonatomic) NSString *forwardQQFriendSum;
@property (copy, nonatomic) NSString *forwardQQzoneSum;
@property (copy, nonatomic) NSString *generateNvQrcodeSum;
@property (strong, nonatomic) NSNumber *saveAlbumSum;
@property (copy, nonatomic) NSString *stealshowSum;
@property (copy, nonatomic) NSString *matchshowSum;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *head;
@property (copy, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSNumber *forwardSum;
@property (copy, nonatomic) NSString *commentSum;
@property (copy, nonatomic) NSString *createTime;

@property (strong, nonatomic) NSNumber *isFlour;  //是否关注
@property (strong, nonatomic) NSNumber *isLike;   //是否喜欢（赞）过

//关注视频列表使用，计算Cell的高度
@property (assign, nonatomic) CGFloat fpllowVideoListTitleHeight;
@property (assign, nonatomic) CGFloat fpllowVideoListCellHeight;
@property (assign, nonatomic) CGFloat fpllowVideoHeight;
@property (assign, nonatomic) CGFloat fpllowVideoWidth;

@end



@interface HomeListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_home_list : WCServiceBase

@property (nonatomic,strong) NSString * pageNo;
@property (nonatomic,strong) NSString * pageSize;
@property (nonatomic,strong) NSString * scenicId;
@property (nonatomic,strong) NSString * currentNoodleId;

@end
