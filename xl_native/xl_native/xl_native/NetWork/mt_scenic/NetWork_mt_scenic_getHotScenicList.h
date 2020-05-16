//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"
#import "NetWork_mt_scenic_getScenicById.h"


//@interface ScenicListModel : IObjcJsonBase
//
////@property (copy, nonatomic) NSString *version;
////@property (copy, nonatomic) NSString *versionName;
////@property (copy, nonatomic) NSString *pageUrl;
////@property (copy, nonatomic) NSString *description;
////@property (copy, nonatomic) NSString *des;
////
////@property (assign, nonatomic) BOOL force;
////@property (assign, nonatomic) BOOL isAutomate;    //安卓使用，ios 不管
////@property (assign, nonatomic) BOOL isAuditPeriod;
////@property (assign, nonatomic) BOOL isDrawActive;
//
//@end



@interface ScenicGetHotScenicListResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,strong) NSArray * obj;

@end

@interface NetWork_mt_scenic_getHotScenicList : WCServiceBase

@property(nonatomic,copy) NSString * pageNo;
@property(nonatomic,copy) NSString * pageSize;
@property(nonatomic,copy) NSString * nsukey;

@end
