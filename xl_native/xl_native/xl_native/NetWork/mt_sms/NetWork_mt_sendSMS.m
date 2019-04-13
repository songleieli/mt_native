//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_sendSMS.h"

//@implementation ContentModel
//
//@end

@implementation SendSMSModel

@end

@implementation SendSMSResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"SendSMSModel"};
//}

@end


@implementation NetWork_mt_sendSMS

-(Class)responseType{
    return [SendSMSResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/sms/sendSMS";
}


@end
