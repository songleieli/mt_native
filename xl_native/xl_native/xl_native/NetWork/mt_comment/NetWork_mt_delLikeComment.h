//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface DeLikeCommentModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface DeLikeCommentResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) LoginModel * obj;

@end

@interface NetWork_mt_delLikeComment : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;
@property (nonatomic,copy) NSString * id;


@end