//
//  NetWork_topicPraise.m
//  CMPLjhMobile
//
//  Created by songleilei on 16/5/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_collectionMusic.h"


@implementation CollectionMusicContentModel

@end

@implementation CollectionMusicResponse

@end


@implementation NetWork_mt_collectionMusic

-(Class)responseType{
    return [CollectionMusicResponse class];
}

-(NSString*)responseCategory{
    return @"/miantiao/collection/collectionMusic";
}

@end
