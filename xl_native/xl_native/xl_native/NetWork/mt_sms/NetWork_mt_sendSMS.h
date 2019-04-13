//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


//@interface ContentModel : IObjcJsonBase
//
//@property (nonatomic,copy) NSString * nickname;
//@property (nonatomic,copy) NSString * qq_id;
//@property (nonatomic,copy) NSString * wechat_id;
//
//@end


@interface SendSMSModel : IObjcJsonBase

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *oldNoodleId;

@end



@interface SendSMSResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSString * obj;

@end

@interface NetWork_mt_sendSMS : WCServiceBase

@property (nonatomic,copy) NSString * mobile;


@end
