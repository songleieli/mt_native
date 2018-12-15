//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_personal_homePage.h"

@implementation PersonalContentModel

@end

@implementation PersonalModel

@end

@implementation PersonalHomePageResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"PersonalModel"};
}

@end


@implementation NetWork_mt_personal_homePage

-(Class)responseType{
    return [PersonalHomePageResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/personal/homePage";
}


@end
