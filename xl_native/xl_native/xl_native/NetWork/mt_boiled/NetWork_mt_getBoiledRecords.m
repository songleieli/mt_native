//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getBoiledRecords.h"


@implementation BoiledRecordModel

@end

@implementation GetBoiledRecordsResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"BoiledRecordModel"};
}

@end


@implementation NetWork_mt_getBoiledRecords

-(Class)responseType{
    return [GetBoiledRecordsResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/boiled/getBoiledRecords";
}


@end
