//
//  NetWork_topicPraise.h
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "WCServiceBase.h"

@interface SaveReportContentModel : IObjcJsonBase

@property (copy, nonatomic) NSString *noodleId;//当前登录面条号
@property (copy, nonatomic) NSString *reportType;//举报类型:1.举报用户，2举报视频
@property (copy, nonatomic) NSString *reportNoodleId;//reportType为 1.举报用户时填
@property (copy, nonatomic) NSString *reportVideoId;//reportType为2举报视频时填  
@property (copy, nonatomic) NSString *reportCategory;//具体见抖音
@property (copy, nonatomic) NSString *reportContent;//具体见抖音

@end

@interface SaveReportResponse : IObjcJsonBase

@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic,copy) NSString * obj;

@end

@interface NetWork_mt_saveReport : WCServiceBase

@property(nonatomic,copy) NSString * currentNoodleId;
@property(nonatomic,copy) NSString * content;


@end
