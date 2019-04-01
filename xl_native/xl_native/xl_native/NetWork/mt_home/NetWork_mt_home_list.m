//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_home_list.h"

@implementation ATFriendsModel

@end

@implementation HomeListModel

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"aFriends" : @"aFriends"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"aFriends" : @"ATFriendsModel"};
}

@end

@implementation HomeListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_home_list

-(Class)responseType{
    return [HomeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/getVideoList";
}


@end
