//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_search_getMusicList.h"


@implementation MusicSearchModel

@end

@implementation GetSearchMusicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"MusicSearchModel"};
}

@end


@implementation NetWork_mt_search_getMusicList

-(Class)responseType{
    return [GetSearchMusicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/search/getMusicList";
}


@end
