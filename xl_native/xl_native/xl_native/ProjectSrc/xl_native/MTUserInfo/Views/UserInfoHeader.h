//
//  UserInfoHeader.h
//  Douyin
//
//  Created by songleilei on 2018/7/30.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "NetWork_mt_personal_homePage.h"

#import <UIKit/UIKit.h>
#import "SlideTabBar.h"
static const NSInteger UserInfoHeaderAvatarTag = 0x01;
static const NSInteger UserInfoHeaderSendTag = 0x02;
static const NSInteger UserInfoHeaderFocusTag = 0x03;
static const NSInteger UserInfoHeaderFocusCancelTag = 0x04;
static const NSInteger UserInfoHeaderSettingTag = 0x05;
static const NSInteger UserInfoHeaderGithubTag = 0x06;

@protocol UserInfoDelegate<NSObject>

- (void)onUserActionTap:(NSInteger)tag;

- (void)onZanActionTap:(PersonalModel*)user;    //点击赞

- (void)onFollowActionTap:(PersonalModel*)user; //点击关注

- (void)onFlourActionTap:(PersonalModel*)user;  //点击面粉

@end

@class User;

@interface UserInfoHeader : UICollectionReusableView

@property (nonatomic, weak)   id <UserInfoDelegate>        delegate;
@property (nonatomic, assign) BOOL                         isFollowed;

@property (nonatomic, strong) UIImageView                  *avatar;
@property (nonatomic, strong) UIImageView                  *topBackground;
@property (nonatomic, strong) UIImageView                  *bottomBackground;

@property (nonatomic, strong) UILabel                      *sendMessage;
@property (nonatomic, strong) UIImageView                  *focusIcon;
@property (nonatomic, strong) UIImageView                  *settingIcon;
@property (nonatomic, strong) UIButton                     *focusButton;

@property (nonatomic, strong) UILabel                      *nickName;
@property (nonatomic, strong) UILabel                      *douyinNum;
@property (nonatomic, strong) UIButton                     *github;
@property (nonatomic, strong) UILabel                      *brief;
@property (nonatomic, strong) UIImageView                  *genderIcon;
@property (nonatomic, strong) UITextView                   *city;

@property (nonatomic, strong) UIButton                      *likeNum;        //获赞
@property (nonatomic, strong) UIButton                      *followNum;      //关注
@property (nonatomic, strong) UIButton                      *followedNum;    //粉丝

@property (nonatomic, strong) SlideTabBar                  *slideTabBar;
@property (nonatomic, strong) PersonalModel                *user;

- (void)initData:(PersonalModel *)user;
- (void)overScrollAction:(CGFloat) offsetY;
- (void)scrollToTopAction:(CGFloat) offsetY;
- (void)startFocusAnimation;

@end
