//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//
#import "MessageCell.h" //消息页面的关注列表为，我关注的用户
#import "UserInfoViewController.h"

#import "NetWork_mt_getFollows.h"   //查看粉丝列表



@interface MTMyFollowViewController : ZJBaseViewController

@property (nonatomic, copy) NSString  *userNoodleId;



@end
