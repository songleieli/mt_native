//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"
//
//@interface GetPrizeListModel : IObjcJsonBase
//
//@property (copy, nonatomic) NSString *id;
//@property (copy, nonatomic) NSString *name;
//
//
//@end



@interface GetPrizeListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_getPrizeList : WCServiceBase

@end
