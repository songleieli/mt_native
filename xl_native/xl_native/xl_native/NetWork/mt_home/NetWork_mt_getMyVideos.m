//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getMyVideos.h"


@implementation GetMyVideosResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_getMyVideos

-(Class)responseType{
    return [GetMyVideosResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/getMyVideos";
}


@end
