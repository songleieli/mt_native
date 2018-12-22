//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getVideoCollections.h"


@implementation GetVideoCollectionModel

@end

@implementation GetVideoCollectionsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetVideoCollectionModel"};
}

@end


@implementation NetWork_mt_getVideoCollections

-(Class)responseType{
    return [GetVideoCollectionsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/collection/getVideoCollections";
}


@end
