//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFuzzyAccountList.h"


@implementation GetFuzzyAccountListModel

@end

@implementation GetFuzzyAccountListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFuzzyAccountListModel"};
}

@end


@implementation NetWork_mt_getFuzzyAccountList

-(Class)responseType{
    return [GetFuzzyAccountListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getFuzzyAccountList";
}


@end
