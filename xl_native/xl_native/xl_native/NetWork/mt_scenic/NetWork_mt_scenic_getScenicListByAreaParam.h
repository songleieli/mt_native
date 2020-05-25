//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"
#import "NetWork_mt_scenic_getScenicById.h"

@interface GetScenicListByAreaParamResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_scenic_getScenicListByAreaParam : WCServiceBase

/*
parentType有三个值   0  1   2
0代表  查询到省份   1代表查询到城市   2代表查询到区县
参数有  province  city  county  传code
*/


@property(nonatomic,copy) NSString * pageNo;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * parentType;

@property(nonatomic,copy) NSString * city;
@property(nonatomic,copy) NSString * province;

@end
