//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_aMeList.h"


@implementation AMeListModel

@end

@implementation AMeListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"AMeListModel"};
}

@end


@implementation NetWork_mt_aMeList

-(Class)responseType{
    return [AMeListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/message/aMeList";
}


@end
