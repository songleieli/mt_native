//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_addWater.h"



//@implementation AddWaterModel
//
//@end

@implementation AddWaterResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"AddWaterModel"};
//}

@end


@implementation NetWork_mt_addWater

-(Class)responseType{
    return [AddWaterResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/boiled/addWater";
}


@end
