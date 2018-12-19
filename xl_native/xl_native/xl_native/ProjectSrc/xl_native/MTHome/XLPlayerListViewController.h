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

#import "NetWork_mt_likeVideo.h"
#import "NetWork_mt_saveflour.h"

#import "UserInfoViewController.h"
#import "TouchTableView.h"


typedef NS_ENUM(NSInteger,DragDirection){
    DragDirection_Down,
    DragDirection_Up,
};

typedef NS_ENUM(NSInteger,StatusOfRefresh) {
    REFRESH_Normal = 0,     //正常状态
    REFRESH_MoveDown ,     //手指下拉
    REFRESH_MoveUp,         //手指上拉
    XDREFRESH_BeginRefresh,    //刷新状态
};

#define MaxDistance 25 //向下拖拽最大点-刷新临界值
#define MaxScroll 200 //向上拖拽最大点-到达最大点就动画让tableview滚动到第二个cell

@interface XLPlayerListViewController : ZJCustomTabBarLjhTableViewController{
    
    BOOL                 _beginDragging;
//    DragDirection        _dragDirection;
    
    HomeVideoCell *_currentCell;  //当前显示到屏幕的cell
}

@property (nonatomic, assign)BOOL isFirstLoad; //判断是否第一加载
@property (nonatomic,strong) MtHomeTopView *topView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL  isCurPlayerPause;

/*仿抖音下拉刷新*/
@property (nonatomic, copy)void(^refreshBlock)(void);
@property (nonatomic, strong)UIView *clearView;
@property (nonatomic, strong)MTHomeRefreshNavigitionView *refreshNavigitionView;
//记录手指滑动状态
@property (nonatomic, assign)StatusOfRefresh refreshStatus;
@property (nonatomic, assign)CGPoint startPoint;

@end
