//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_addVideoPlay.h"


@implementation AddVideoPlayFlourResponse


//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"DelFlourModel"};
//}

@end


@implementation NetWork_mt_addVideoPlay

-(Class)responseType{
    return [AddVideoPlayFlourResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/addVideoPlay";
}


@end
