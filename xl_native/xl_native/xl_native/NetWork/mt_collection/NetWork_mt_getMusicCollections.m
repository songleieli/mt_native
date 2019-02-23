//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getMusicCollections.h"


@implementation GetMusicCollectionModel

@end

@implementation GetMusicCollectionsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetMusicCollectionModel"};
}

@end


@implementation NetWork_mt_getMusicCollections

-(Class)responseType{
    return [GetMusicCollectionsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/collection/getMusicCollections";
}


@end
