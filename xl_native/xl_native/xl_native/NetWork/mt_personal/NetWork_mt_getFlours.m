//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFlours.h"


@implementation GetFloursModel

@end

@implementation GetFloursResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFloursModel"};
}

@end


@implementation NetWork_mt_getFlours

-(Class)responseType{
    return [GetFloursResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/getFlours";
}


@end
