//
//  UserResponse.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "UserResponse.h"


@implementation Avatar



@end

@implementation User

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"avatar_medium" : @"avatar_medium"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"avatar_medium" : @"Avatar"};
}

@end

@implementation UserResponse

- (NSDictionary *)propertyMappingObjcJson {
    return @{@"data" : @"data"};
}
- (NSDictionary *)classNameForItemInArray {
    return @{@"data" : @"User"};
}

@end
