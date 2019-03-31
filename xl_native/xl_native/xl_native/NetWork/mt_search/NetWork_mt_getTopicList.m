//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getTopicList.h"


//@implementation GetTopicListModel
//
//@end

@implementation GetTopicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFuzzyTopicListModel"};
}

@end


@implementation NetWork_mt_getTopicList

-(Class)responseType{
    return [GetTopicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getTopicList";
}


@end
