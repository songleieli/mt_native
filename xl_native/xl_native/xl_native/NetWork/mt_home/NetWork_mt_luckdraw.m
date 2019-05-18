//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getPrizeList.h"


//@implementation GetPrizeListModel
//
//@end

@implementation GetPrizeListResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"GetPrizeListModel"};
//}

@end


@implementation NetWork_mt_getPrizeList

-(Class)responseType{
    return [GetPrizeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/home/getPrizeList";
}


@end
