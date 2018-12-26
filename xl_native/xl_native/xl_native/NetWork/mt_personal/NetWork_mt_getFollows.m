//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFollows.h"


@implementation GetFollowsModel

@end

@implementation GetFollowsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFollowsModel"};
}

@end


@implementation NetWork_mt_getFollows

-(Class)responseType{
    return [GetFollowsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/getFollows";
}


@end
