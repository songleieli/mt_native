//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "FollowsVideoListCell.h"
#import "CommentsPopView.h"
#import "SharePopView.h"

#import "NetWork_mt_getFollowsVideoList.h"
#import "NetWork_mt_likeVideo.h"
#import "NetWork_mt_delLikeVideo.h"

@interface MTFollowViewController : ZJCustomTabBarLjhTableViewController<GetFollowsDelegate>

//@property (nonatomic, assign)BOOL isFirstLoad; //判断是否第一加载
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong)FollowsVideoListCell *currentCell;  //当前显示到屏幕的cell

/*
 1.如果页面离开前是播放状态，那么回来后还播放。
 2.如果页面离开前是暂停状态，那么回来后还是暂停状态。
 */
@property (nonatomic, assign) BOOL isDisAppearPlay;

@end
