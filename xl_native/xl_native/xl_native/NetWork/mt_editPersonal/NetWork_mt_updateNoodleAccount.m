//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_updateNoodleAccount.h"

@implementation UpdateNoodleAccountContentModel

@end


@implementation UpdateNoodleAccountResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"SaveVideoModel"};
//}

@end


@implementation NetWork_mt_updateNoodleAccount

-(Class)responseType{
    return [UpdateNoodleAccountResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/editPersonal/updateNoodleAccount";
}


@end
