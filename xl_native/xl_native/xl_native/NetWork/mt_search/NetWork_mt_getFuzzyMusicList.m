//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getFuzzyMusicList.h"


@implementation GetFuzzyMusicListModel

@end

@implementation GetFuzzyMusicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetFuzzyMusicListModel"};
}

@end


@implementation NetWork_mt_getFuzzyMusicList

-(Class)responseType{
    return [GetFuzzyMusicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getFuzzyMusicList";
}


@end
