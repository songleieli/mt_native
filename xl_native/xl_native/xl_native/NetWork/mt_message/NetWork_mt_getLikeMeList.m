//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getLikeMeList.h"


@implementation GetLikeMeListModel

@end

@implementation GetLikeMeListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetLikeMeListModel"};
}

@end


@implementation NetWork_mt_getLikeMeList

-(Class)responseType{
    return [GetLikeMeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/message/getLikeMeList";
}


@end
