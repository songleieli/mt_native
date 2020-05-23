//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_scenic_getCityByProvinceCode.h"




@implementation GetCityByProvinceCodeResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetProvinceDataModel"};
}

@end


@implementation NetWork_mt_scenic_getCityByProvinceCode

-(Class)responseType{
    return [GetCityByProvinceCodeResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/scenic/getCityByProvinceCode";
}


@end
