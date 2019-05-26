//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_forwardAppCount.h"

//@implementation GetWinnerModel
//
//
//@end


@implementation ForwardAppCountResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"GetWinnerModel"};
//}

@end


@implementation NetWork_mt_forwardAppCount

-(Class)responseType{
    return [ForwardAppCountResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/forwardAppCount";
}


@end
