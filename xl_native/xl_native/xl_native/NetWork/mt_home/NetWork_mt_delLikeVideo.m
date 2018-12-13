//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_delLikeVideo.h"

//@implementation ContentModel
//
//@end

@implementation DeLikeVideoModel

@end

@implementation DelLikeVideoResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"DeLikeVideoModel"};
}

@end


@implementation NetWork_mt_delLikeVideo

-(Class)responseType{
    return [DelLikeVideoResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/delLikeVideo";
}


@end
