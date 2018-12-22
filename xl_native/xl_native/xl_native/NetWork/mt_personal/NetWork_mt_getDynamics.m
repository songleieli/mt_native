//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getDynamics.h"


@implementation GetDynamicsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_getDynamics

-(Class)responseType{
    return [GetDynamicsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/getDynamics";
}


@end
