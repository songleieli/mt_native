//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_saveVideo.h"


@implementation SaveVideoAtFriendContentModel

@end


@implementation SaveVideoContentModel

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"aFriends" : @"aFriends"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"aFriends" : @"SaveVideoAtFriendContentModel"};
}

@end


@implementation SaveVideoResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"SaveVideoModel"};
//}

@end


@implementation NetWork_mt_saveVideo

-(Class)responseType{
    return [SaveVideoResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/video/saveVideo";
}


@end
