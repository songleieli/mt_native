//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_delLikeComment.h"


@implementation DeLikeCommentModel

@end

@implementation DeLikeCommentResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"DeLikeCommentModel"};
}

@end


@implementation NetWork_mt_delLikeComment

-(Class)responseType{
    return [DeLikeCommentResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/comment/delLikeComment";
}


@end
