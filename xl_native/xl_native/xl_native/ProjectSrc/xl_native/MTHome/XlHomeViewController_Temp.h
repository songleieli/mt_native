//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "MtHomeTopView.h"
#import "HomeVideoCell.h"
#import "NetWork_mt_likeVideo.h"
#import "NetWork_mt_saveflour.h"


typedef NS_ENUM(NSInteger,DragDirection){
    DragDirection_Down,
    DragDirection_Up,
};


@interface XlHomeViewController_Temp : ZJCustomTabBarLjhTableViewController{
    
//    BOOL                 isFirstLoad;
    
    BOOL                 _beginDragging;
    NSInteger            _liveInfoIndex;
    DragDirection        _dragDirection;
    
    SwitchPlayerView *_playerView;//当前正在播放视频的播放器
    HomeVideoCell *_currentCell;  //当前显示到屏幕的cell
}

@property (nonatomic, assign)BOOL isFirstLoad; //判断是否第一加载
@property (nonatomic,strong) MtHomeTopView *topView;

@end
