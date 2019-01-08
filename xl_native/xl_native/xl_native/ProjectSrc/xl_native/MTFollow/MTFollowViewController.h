//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ZJCustomTabBarLjhTableViewController.h"
//#import "MyScrollView.h"
//#import "XLGCBodyView.h"
#import "FollowsVideoListCell.h"
#import "UserInfoViewController.h"
#import "MTMyFansViewController.h"
#import "MTAMeListViewController.h"
#import "MTZanListViewController.h"
#import "MTMyCommentViewController.h"

#import "NetWork_mt_getFollows.h"

#import "NetWork_mt_getFollowsVideoList.h"



@interface MTFollowViewController : ZJCustomTabBarLjhTableViewController




@property (nonatomic,strong) UIView * viewHeadBg;
@property (nonatomic,strong) UIView * viewFooterBg;


@end
