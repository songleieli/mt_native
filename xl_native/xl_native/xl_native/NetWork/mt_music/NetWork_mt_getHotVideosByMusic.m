//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getHotVideosByMusic.h"

//@implementation GetHotVideosByTopicVideoModel
//
//@end

@implementation GetHotVideosByMusicModel

@end

@implementation GetHotVideosByMusicTempModel

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"videoList" : @"videoList"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"videoList" : @"HomeListModel",@"topic":@"GetHotVideosByMusicModel"};
}

@end



@implementation GetHotVideosByMusicResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"obj" : @"obj"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"obj" : @"GetHotVideosByMusicTempModel"};
}

@end


@implementation NetWork_mt_getHotVideosByMusic

-(Class)responseType{
    return [GetHotVideosByMusicResponse class];
}
-(NSString*)responseCategory{
    return @"/miantiao/music/getHotVideosByMusic";
}


@end
