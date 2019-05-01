//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_shieldAccount.h"

@implementation ShieldAccountResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"UserAgreementModel"};
//}

@end


@implementation NetWork_mt_shieldAccount

-(Class)responseType{
    return [ShieldAccountResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/setting/shieldAccount";
}


@end
