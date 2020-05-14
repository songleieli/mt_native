//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_scenic_getScenicByAreaParam.h"

@implementation ScenicListModel

//@dynamic description;
//
////-(void)setDescription:(NSString *)description{
////    _des = description;
////}
//
//
@end

@implementation ScenicGetScenicByAreaParamResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"ScenicListModel"};
}

@end


@implementation NetWork_mt_scenic_getScenicByAreaParam

-(Class)responseType{
    return [ScenicGetScenicByAreaParamResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/scenic/getScenicByAreaParam";
}


@end
