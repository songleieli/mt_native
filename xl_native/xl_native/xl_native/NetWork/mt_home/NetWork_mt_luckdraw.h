//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

@interface LuckdrawResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * obj;

@end

@interface NetWork_mt_luckdraw : WCServiceBase


@property(nonatomic,copy) NSString * currentNoodleId;

@end
