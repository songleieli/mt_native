//
//  GKDouyinHomeViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "UINavigationController+GKCategory.h"

@interface GKDouyinHomeViewController : ZJCustomTabBarLjhTableViewController


/** push代理 */
@property (nonatomic, weak) id<GKViewControllerPushDelegate> gk_pushDelegate;

/** 是否开启左滑push操作，默认是NO，此时不可禁用控制器的滑动返回手势 */
@property (nonatomic, assign) BOOL gk_openScrollLeftPush;

@end
