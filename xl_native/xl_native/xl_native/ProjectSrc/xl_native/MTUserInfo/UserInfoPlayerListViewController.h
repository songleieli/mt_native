//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import "UserInfoPlayerCell.h"
#import "CommentsPopView.h"
#import "LoadMoreControl.h"

#import "NetWork_mt_likeVideo.h"
#import "NetWork_mt_delLikeVideo.h"
#import "NetWork_mt_saveflour.h"

typedef enum{
    VideoTypeWorks,
    VideoTypeDynamics,
    VideoTypeFavourites
}VideoType;


@interface UserInfoPlayerListViewController : ZJBaseViewController

@property (nonatomic, assign)BOOL isFirstLoad; //判断是否第一加载
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong)UserInfoPlayerCell *currentCell;  //当前显示到屏幕的cell

@property (nonatomic, assign) VideoType    videoType;
@property (nonatomic, strong) LoadMoreControl  *loadMore;

-(instancetype)initWithVideoData:(NSMutableArray<HomeListModel *> *)data
                    currentIndex:(NSInteger)currentIndex
                       pageIndex:(NSInteger)pageIndex
                        pageSize:(NSInteger)pageSize
                       videoType:(VideoType)videoType;


@end
