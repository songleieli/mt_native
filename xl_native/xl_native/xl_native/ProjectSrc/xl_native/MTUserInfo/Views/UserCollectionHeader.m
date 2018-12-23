//
//  UserInfoHeader.m
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "UserCollectionHeader.h"
//#import "User.h"
#import "UserResponse.h"
#import "UIImage+Extension.h"

static const NSTimeInterval kAnimationDefaultDuration = 0.25;

@interface UserCollectionHeader ()

@property (nonatomic, strong) UIView                  *containerView;
@property (nonatomic, copy) NSArray<NSString *>       *constellations;

@end

@implementation UserCollectionHeader




- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _isFollowed = NO;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    //添加header的r容器，和 header的frame大小保持一致
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_containerView];
    
    [self initInfoView];    //初始化，用户信息，签名，d抖音号，获赞，关注，粉丝等
}


- (void)initInfoView {
    _slideTabBar = [SlideTabBar new];
    [self addSubview:_slideTabBar];
    [_slideTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.bottom.equalTo(self);
    }];
    [_slideTabBar setLabels:@[@"作品0",@"消息0",@"喜欢0"] tabIndex:0];
}

- (void)initData:(PersonalModel *)user {
    
    [_slideTabBar setLabels:@[[@"作品" stringByAppendingString:[NSString stringWithFormat:@"%@", user.videoSum]],
                              [@"动态" stringByAppendingString:[NSString stringWithFormat:@"%@", user.dynamics]],
                              [@"喜欢" stringByAppendingString:[NSString stringWithFormat:@"%@", user.likeSum]]]
                   tabIndex:0];
}

- (void)onTapAction:(UITapGestureRecognizer *)sender {
    if(self.delegate) {
        [self.delegate onUserActionTap:sender.view.tag];
    }
}



@end
