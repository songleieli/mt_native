//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"




@interface GetRuleModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface GetRuleResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) GetRuleModel * obj;

@end

@interface NetWork_mt_getRule : WCServiceBase


@end
