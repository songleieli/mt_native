//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getLikeVideoList.h"


@implementation GetLikeVideoListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_getLikeVideoList

-(Class)responseType{
    return [GetLikeVideoListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/getLikeVideoList";
}


@end
