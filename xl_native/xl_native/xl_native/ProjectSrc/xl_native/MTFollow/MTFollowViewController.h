//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "FollowsVideoListCell.h"
#import "NetWork_mt_getFollowsVideoList.h"

@interface MTFollowViewController : ZJCustomTabBarLjhTableViewController

@property (nonatomic, assign)BOOL isFirstLoad; //判断是否第一加载
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong)FollowsVideoListCell *currentCell;  //当前显示到屏幕的cell

@end
