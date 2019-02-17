//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getTopicCollections.h"


@implementation GetTopicCollectionModel

@end

@implementation GetTopicCollectionsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetTopicCollectionModel"};
}

@end


@implementation NetWork_mt_getTopicCollections

-(Class)responseType{
    return [GetTopicCollectionsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/collection/getTopicCollections";
}


@end
