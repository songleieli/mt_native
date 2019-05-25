//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"




//@interface AddWaterModel : IObjcJsonBase
//
//@property (copy, nonatomic) NSString *id;
//@property (copy, nonatomic) NSString *oldNoodleId;
//
//@end



@interface AddWaterResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * obj;

@end

@interface NetWork_mt_addWater : WCServiceBase

@property(nonatomic,copy) NSString * currentNoodleId;

@end
