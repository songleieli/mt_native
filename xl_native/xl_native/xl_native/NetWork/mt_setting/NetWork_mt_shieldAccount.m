//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_saveReport.h"

@implementation SaveReportContentModel

@end


@implementation SaveReportResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"UserAgreementModel"};
//}

@end


@implementation NetWork_mt_saveReport

-(Class)responseType{
    return [SaveReportResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/setting/saveReport";
}


@end
