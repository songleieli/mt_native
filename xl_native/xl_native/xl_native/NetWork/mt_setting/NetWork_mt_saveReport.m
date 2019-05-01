//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_userAgreement.h"



@implementation UserAgreementModel

@end

@implementation UserAgreementResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"UserAgreementModel"};
}

@end


@implementation NetWork_mt_userAgreement

-(Class)responseType{
    return [UserAgreementResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/setting/userAgreement";
}


@end
