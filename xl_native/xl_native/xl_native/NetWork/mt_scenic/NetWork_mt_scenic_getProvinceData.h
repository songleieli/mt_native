//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

@interface GetProvinceDataModel : IObjcJsonBase


/*
 "code": "120000",
      "name": "天津市"
 */

@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *name;

@end

@interface GetProvinceDataResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_scenic_getProvinceData : WCServiceBase

@property(nonatomic,copy) NSString * code;

@end
