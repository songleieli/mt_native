//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFuzzyTopicList.h"


@implementation GetFuzzyTopicListModel

@end

@implementation GetFuzzyTopicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFuzzyTopicListModel"};
}

@end


@implementation NetWork_mt_getFuzzyTopicList

-(Class)responseType{
    return [GetFuzzyTopicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getFuzzyTopicList";
}


@end
