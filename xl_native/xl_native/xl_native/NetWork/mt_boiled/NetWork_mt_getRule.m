//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getRule.h"



@implementation GetRuleModel

@end

@implementation GetRuleResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetRuleModel"};
}

@end


@implementation NetWork_mt_getRule

-(Class)responseType{
    return [GetRuleResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/boiled/getRule";
}


@end
