//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getHotVideosByTopic.h"


@implementation GetHotVideosByTopicResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_getHotVideosByTopic

-(Class)responseType{
    return [GetHotVideosByTopicResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/topic/getHotVideosByTopic";
}


@end
