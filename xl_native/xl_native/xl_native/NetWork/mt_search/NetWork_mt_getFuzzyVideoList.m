//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFuzzyVideoList.h"


@implementation GetFuzzyVideoListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"HomeListModel"};
}

@end


@implementation NetWork_mt_getFuzzyVideoList

-(Class)responseType{
    return [GetFuzzyVideoListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getFuzzyVideoList";
}


@end
