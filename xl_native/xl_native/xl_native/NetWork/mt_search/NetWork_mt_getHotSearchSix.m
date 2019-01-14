//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getHotSearchSix.h"


@implementation GetHotSearchSixModel

@end

@implementation GetHotSearchSixResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetHotSearchSixModel"};
}

@end


@implementation NetWork_mt_getHotSearchSix

-(Class)responseType{
    return [GetHotSearchSixResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getHotSearchSix";
}


@end
