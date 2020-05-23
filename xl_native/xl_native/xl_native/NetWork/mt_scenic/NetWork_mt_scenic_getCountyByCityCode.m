//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_scenic_getCountyByCityCode.h"




@implementation GetCountyByCityCodeResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetProvinceDataModel"};
}

@end


@implementation NetWork_mt_scenic_getCountyByCityCode

-(Class)responseType{
    return [GetCountyByCityCodeResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/scenic/getCountyByCityCode";
}


@end
