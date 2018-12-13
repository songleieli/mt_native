//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_saveflour.h"

@implementation SaveflourContentModel

@end

@implementation SaveflourModel

@end

@implementation SaveflourResponse


- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"SaveflourModel"};
}

@end


@implementation NetWork_mt_saveflour

-(Class)responseType{
    return [SaveflourResponse class];
}
-(NSString*)responseCategory{
    return @"/personal/saveflour";
}


@end
