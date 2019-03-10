//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_forwardVideoCount.h"


@implementation ForwardVideoCountResponse


//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"DelFlourModel"};
//}

@end


@implementation NetWork_mt_forwardVideoCount

-(Class)responseType{
    return [ForwardVideoCountResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/forwardVideoCount";
}


@end
