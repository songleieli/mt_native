//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"


@interface GetUploadSignatureResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSString * obj;

@end

@interface NetWork_mt_getUploadSignature : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;

@end
