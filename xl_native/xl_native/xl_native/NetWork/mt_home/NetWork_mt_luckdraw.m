//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_luckdraw.h"


@implementation LuckdrawResponse


@end


@implementation NetWork_mt_luckdraw

-(Class)responseType{
    return [LuckdrawResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/luckdraw";
}


@end
