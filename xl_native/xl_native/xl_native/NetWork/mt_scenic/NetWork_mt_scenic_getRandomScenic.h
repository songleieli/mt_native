//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"
#import "NetWork_mt_scenic_getScenicById.h"

@interface ScenicGetRandomScenicResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) ScenicModel * obj;

@end

@interface NetWork_mt_scenic_getRandomScenic : WCServiceBase

@property(nonatomic,copy) NSString * pageNo;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * nsukey;

@end
