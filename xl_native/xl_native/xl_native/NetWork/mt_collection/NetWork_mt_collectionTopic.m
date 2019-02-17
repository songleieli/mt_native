//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_collectionTopic.h"


@implementation CollectionTopicContentModel

@end

@implementation CollectionTopicResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}

- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"CollectionVideoModel"};
}

@end


@implementation NetWork_mt_collectionTopic

-(Class)responseType{
    return [CollectionTopicResponse class];
}

-(NSString*)responseCategory{
    return @"/miantiao/collection/collectionTopic";
}

@end
