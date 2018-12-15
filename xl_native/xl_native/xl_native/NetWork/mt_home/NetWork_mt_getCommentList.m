//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getCommentList.h"


@implementation CommentListModel

@end

@implementation GetCommentListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"CommentListModel"};
}

@end


@implementation NetWork_mt_getCommentList

-(Class)responseType{
    return [GetCommentListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/comment/getCommentList";
}


@end
