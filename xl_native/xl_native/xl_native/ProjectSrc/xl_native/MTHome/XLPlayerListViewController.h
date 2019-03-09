//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "MtHomeTopView.h"
#import "MTHomeRefreshNavigitionView.h"
#import "HomeVideoCell.h"
#import "CommentsPopView.h"
#import "SharePopView.h"

#import "NetWork_mt_likeVideo.h"
#import "NetWork_mt_delLikeVideo.h"
#import "NetWork_mt_saveflour.h"
#import "NetWork_mt_addVideoPlay.h"
#import "NetWork_mt_getVideoCollections.h"
#import "NetWork_mt_collectionVideo.h"

#import "UserInfoViewController.h"
#import "MusicInfoController.h"


typedef NS_ENUM(NSInteger,StatusOfRefresh) {
    REFRESH_Normal = 0,     //正常状态
    REFRESH_MoveDown ,     //手指下拉
    REFRESH_MoveUp,         //手指上拉
    XDREFRESH_BeginRefresh,    //刷新状态
};

#define MaxDistance 25 //向下拖拽最大点-刷新临界值
#define MaxScroll 300 //向上拖拽最大点-到达最大点就动画让tableview滚动到第二个cell

@interface XLPlayerListViewController : ZJBaseViewController

@property (nonatomic,strong) MtHomeTopView *topView;
@property (nonatomic, assign) NSInteger currentPlayVideoIndex; //当前播放视频的Index
@property (nonatomic, strong)HomeVideoCell *currentCell;  //当前显示到屏幕的cell
@property (nonatomic, assign) BOOL  isCurPlayerPause;

/*仿抖音下拉刷新*/
@property (nonatomic, copy)void(^refreshBlock)(void);
//记录手指滑动状态
@property (nonatomic, assign)StatusOfRefresh refreshStatus;
@property (nonatomic, assign)CGPoint startPoint;

/*block*/
@property (nonatomic, copy) void(^scrollBlock)(BOOL isScroll);
@property (nonatomic, copy) void(^seachClickBlock)();

/*
 1.如果页面离开前是播放状态，那么回来后还播放。
 2.如果页面离开前是暂停状态，那么回来后还是暂停状态。
 */
@property (nonatomic, assign)BOOL isDisAppearPlay;

/*
 页面显示或从其他页面返回来已经显示调用方法
 */
- (void)playListCurrPlayDidAppear;
/*
 页面消失调用方法
 */
- (void)playListCurrPlayDisAppear;


@end
