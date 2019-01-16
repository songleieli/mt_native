//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getHotVideoList.h"

@implementation TopicModel

@end


@implementation GetHotVideoListModel


- (NSDictionary *)propertyMappingObjcJson {
    return @{@"videoList" : @"videoList"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"videoList" : @"HomeListModel",@"topic":@"TopicModel"};
}


@end

@implementation GetHotVideoListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetHotVideoListModel"};
}

@end


@implementation NetWork_mt_getHotVideoList

-(Class)responseType{
    return [GetHotVideoListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getHotVideoList";
}


@end
