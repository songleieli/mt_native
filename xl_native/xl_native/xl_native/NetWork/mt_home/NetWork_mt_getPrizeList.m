//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getPrizeList.h"

@implementation GetPrizeListResponse

@end


@implementation NetWork_mt_getPrizeList

-(Class)responseType{
    return [GetPrizeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/getPrizeList";
}


@end