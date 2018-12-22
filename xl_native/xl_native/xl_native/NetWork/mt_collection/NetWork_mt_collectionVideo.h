//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface CollectionContentModel : IObjcJsonBase

@property (nonatomic,copy) NSString * noodleId;
@property (nonatomic,copy) NSString * noodleVideoId;
@property (nonatomic,copy) NSString * videoNoodleId;
@property (nonatomic,copy) NSString * noodleVideoCover;

@end


@interface CollectionVideoModel : IObjcJsonBase




@property (copy, nonatomic) NSString *id;


@end



@interface CollectionVideoResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_collectionVideo : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * content;

@end
