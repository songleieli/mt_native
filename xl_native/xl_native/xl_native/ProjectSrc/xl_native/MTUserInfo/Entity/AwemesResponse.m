//
//  UserResponse.m
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "AwemesResponse.h"


@implementation Cover




@end

@implementation Video

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"cover" : @"cover",@"statistics":@"statistics"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"cover" : @"Cover"};
}

@end

@implementation Statistics




@end

@implementation Aweme

//- (NSDictionary *)propertyMappingObjcJson {
//    return @{@"video" : @"video"};
//}
- (NSDictionary *)classNameForItemInArray {
    return @{@"video" : @"Video",@"statistics":@"Statistics"};
}

@end

@implementation AwemesResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"data" : @"data"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"data" : @"Aweme"};
}

@end
