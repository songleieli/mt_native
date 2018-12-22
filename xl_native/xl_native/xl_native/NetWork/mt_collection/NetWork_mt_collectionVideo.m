//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_collectionVideo.h"

@implementation CollectionContentModel

@end

@implementation CollectionVideoModel

@end

@implementation CollectionVideoResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"CollectionVideoModel"};
}

@end


@implementation NetWork_mt_collectionVideo

-(Class)responseType{
    return [CollectionVideoResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/collection/collectionVideo";
}


@end
