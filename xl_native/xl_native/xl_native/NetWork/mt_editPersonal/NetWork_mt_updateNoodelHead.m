//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_updateNoodelHead.h"

//@implementation UpdateNoodelHeadModel
//
//
//@end


@implementation UpdateNoodelHeadResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"UpdateNoodelHeadModel"};
//}

@end


@implementation NetWork_mt_updateNoodelHead

-(Class)responseType{
    return [UpdateNoodelHeadResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/editPersonal/updateNoodelHead";
}


@end
