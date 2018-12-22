//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_publishComment.h"

@implementation PublishContentModel

@end

//@implementation PublishCommentModel
//
//@end

@implementation PublishCommentResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"CommentListModel"};
}

@end


@implementation NetWork_mt_publishComment

-(Class)responseType{
    return [PublishCommentResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/comment/publishComment";
}


@end
