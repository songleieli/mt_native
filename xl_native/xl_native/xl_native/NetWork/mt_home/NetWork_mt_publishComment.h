//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

#import "NetWork_mt_getCommentList.h"


@interface PublishContentModel : IObjcJsonBase

@property (nonatomic,assign) NSInteger noodleVideoId;
@property (nonatomic,copy) NSString *commentNoodleId;
@property (nonatomic,copy) NSString * commentNickname;
@property (nonatomic,copy) NSString * commentHead;
@property (nonatomic,copy) NSString * commentContent;
@property (nonatomic,copy) NSString *parentNoodleId;

@end


//@interface  PublishCommentModel: IObjcJsonBase
//
//@property (copy, nonatomic) NSString *id;
//@property (copy, nonatomic) NSString *oldNoodleId;
//
//@end



@interface PublishCommentResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) CommentListModel * obj;

@end

@interface NetWork_mt_publishComment : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * noodleVideoCover;
@property (nonatomic,copy) NSString * noodleId;


@end
