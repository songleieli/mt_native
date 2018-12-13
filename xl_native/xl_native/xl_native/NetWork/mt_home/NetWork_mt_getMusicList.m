//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by 刘欣 on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getMusicList.h"


@implementation MusicModel

@end

@implementation GetMusicListResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"MusicModel"};
}

@end


@implementation NetWork_mt_getMusicList

-(Class)responseType{
    return [GetMusicListResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/music/getMusicList";
}


@end
