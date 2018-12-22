//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_delflour.h"

@implementation DelFlourContentModel

@end

@implementation DelFlourModel

@end

@implementation DelFlourResponse


- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"DelFlourModel"};
}

@end


@implementation NetWork_mt_delflour

-(Class)responseType{
    return [DelFlourResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/delflour";
}


@end
