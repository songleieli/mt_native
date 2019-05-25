//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getBoiledStatistics.h"



@implementation GetBoiledStatisticsModel

@end

@implementation GetBoiledStatisticsResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetBoiledStatisticsModel"};
}

@end


@implementation NetWork_mt_getBoiledStatistics

-(Class)responseType{
    return [GetBoiledStatisticsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/boiled/getBoiledStatistics";
}


@end
