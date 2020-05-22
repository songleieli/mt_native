//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_scenic_getHotScenicList.h"

@implementation ScenicGetHotScenicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"ScenicModel"};
}

@end


@implementation NetWork_mt_scenic_getHotScenicList

-(Class)responseType{
    return [ScenicGetHotScenicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/scenic/getHotScenicList";
}


@end
