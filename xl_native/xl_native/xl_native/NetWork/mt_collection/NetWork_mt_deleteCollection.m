//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_deleteCollection.h"


@implementation DeleteCollectionResponse


@end


@implementation NetWork_mt_deleteCollection

-(Class)responseType{
    return [DeleteCollectionResponse class];
}

-(NSString*)responseCategory{
    return @"/miantiao/collection/deleteCollection";
}

@end
