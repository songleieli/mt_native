//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_likeVideo.h"

//@implementation ContentModel
//
//@end

@implementation LikeVideoModel

@end

@implementation LikeVideoResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"LikeVideoModel"};
}

@end


@implementation NetWork_mt_likeVideo

-(Class)responseType{
    return [LikeVideoResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/likeVideo";
}


@end
