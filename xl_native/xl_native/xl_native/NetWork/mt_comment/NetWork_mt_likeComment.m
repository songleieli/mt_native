//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_likeComment.h"


@implementation LikeCommentModel

@end

@implementation LikeCommentResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"LikeCommentModel"};
}

@end


@implementation NetWork_mt_likeComment

-(Class)responseType{
    return [LikeCommentResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/comment/likeComment";
}


@end
