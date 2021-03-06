//
//  GKDouyinHomeViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"
#import "UINavigationController+GKCategory.h"

#import "GKDouyinHomeSearchViewController.h"
#import "XLPlayerListViewController.h"

@interface GKDouyinHomeViewController : ZJCustomTabBarLjhTableViewController

@property (atomic, assign) CGFloat  offset; //判断是否向右滑动的变量

@property (nonatomic, strong) GKDouyinHomeSearchViewController  *searchVC; //左侧Controller
@property (nonatomic, strong) XLPlayerListViewController  *playerVC; //右侧Controller

@end
