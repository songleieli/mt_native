//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#define Key_UserInfo_Appid @"Key_UserInfo_Appid"
#define Key_UserInfo_User  @"Key_UserInfo_User"
#define Key_UserInfo_Pwd   @"Key_UserInfo_Pwd"
#define Key_UserInfo_Sig   @"Key_UserInfo_Sig"

//#import <UIKit/UIKit.h>
#import "ZJCustomTabBarLjhTableViewController.h"

#import "MessageCell.h"
#import "UserInfoViewController.h"
#import "MTMyFansViewController.h"
#import "MTAMeListViewController.h"
#import "MTZanListViewController.h"
#import "MTMyCommentViewController.h"

#import "NetWork_mt_getFollows.h"



@interface MTMessageViewController : ZJCustomTabBarLjhTableViewController

@property (nonatomic,strong) UIView * viewHeadBg;

@end
