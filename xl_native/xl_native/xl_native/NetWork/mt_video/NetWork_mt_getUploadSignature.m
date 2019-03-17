//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getUploadSignature.h"


@implementation GetUploadSignatureResponse

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"obj" : @"obj"};
//}
//- (NSDictionary *)classNameForItemInArray {
//    return @{@"obj" : @"SaveVideoModel"};
//}

@end


@implementation NetWork_mt_getUploadSignature

-(Class)responseType{
    return [GetUploadSignatureResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/video/getUploadSignature";
}


@end
