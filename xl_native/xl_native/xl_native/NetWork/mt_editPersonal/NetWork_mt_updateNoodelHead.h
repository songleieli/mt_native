//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//


//@interface UpdateNoodelHeadModel : IObjcJsonBase
//
//@property (nonatomic,copy) NSString * noodleId;
//
//
//
//@end

@interface UpdateNoodelHeadResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSString * obj;

@end

@interface NetWork_mt_updateNoodelHead : WCServiceBase

@property (nonatomic,copy) NSString * currentNoodleId;

@end
