//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getCommentMeList.h"


@implementation GetCommentMeListModel

@end

@implementation GetCommentMeListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetCommentMeListModel"};
}

@end


@implementation NetWork_mt_getCommentMeList

-(Class)responseType{
    return [GetCommentMeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/message/getCommentMeList";
}


@end
