//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_upgrade.h"

//@implementation ContentModel
//
//@end

@implementation UpgradeModel

@end

@implementation UpgradeResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"UpgradeModel"};
}

@end


@implementation NetWork_mt_upgrade

-(Class)responseType{
    return [UpgradeResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/sms/sendSMS";
}


@end
