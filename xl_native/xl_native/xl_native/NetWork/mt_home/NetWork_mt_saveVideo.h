//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface SaveVideoContentModel : IObjcJsonBase

@property (nonatomic,copy) NSString * noodleId;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * size;
@property (nonatomic,copy) NSString * stealshowNoodleId;
@property (nonatomic,copy) NSString * matchshowNoodleId;
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


@interface SaveVideoModel : IObjcJsonBase

@property (nonatomic,copy) NSString * nickname;


@end



@interface SaveVideoResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_saveVideo : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * videoCoverFile;
@property (nonatomic,copy) NSString * videoFile;
@property (nonatomic,copy) NSString * musicCoverFile;
@property (nonatomic,copy) NSString * musicFile;

@end
