//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_scenic_getScenicById.h"

@implementation ScenicTicketInfoModel


@end


@implementation ScenicSpotModel


@end


@implementation ScenicDynamicAttributesModel


@end

@implementation ScenicModel

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"dynamicAttributes" : @"dynamicAttributes",@"spots":@"spots",@"ticketInfos":@"ticketInfos"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"dynamicAttributes" : @"ScenicDynamicAttributesModel",@"spots":@"ScenicSpotModel",@"ticketInfos":@"ScenicTicketInfoModel"};
}


@end

@implementation ScenicGetScenicByIdResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"ScenicModel"};
}

@end


@implementation NetWork_mt_scenic_getScenicById

-(Class)responseType{
    return [ScenicGetScenicByIdResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/scenic/getScenicById";
}


@end
