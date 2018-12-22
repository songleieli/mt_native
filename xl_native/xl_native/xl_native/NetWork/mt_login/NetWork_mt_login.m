//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_login.h"

@implementation ContentModel

@end

@implementation LoginModel

@end

@implementation LoginResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"LoginModel"};
}

@end


@implementation NetWork_mt_login

-(Class)responseType{
    return [LoginResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/login/loginNoodel";
}


@end
