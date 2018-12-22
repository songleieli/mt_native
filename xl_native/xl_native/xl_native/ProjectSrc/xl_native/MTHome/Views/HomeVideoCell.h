//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NetWork_mt_home_list.h"
#import "AVPlayerView.h"
#import "SwitchPlayerMaskView.h"

#define HomeVideoCellHeight ScreenHeight

typedef void (^OnPlayerReady)(void);


@protocol HomeDelegate <NSObject>

- (void)userInfoClicked:(HomeListModel *)listModel;

- (void)followClicked:(HomeListModel *)listModel;

- (void)zanClicked:(HomeListModel *)listModel;

- (void)commentClicked:(HomeListModel *)listModel;

- (void)shareClicked:(HomeListModel *)listModel;

- (void)musicCDClicked:(HomeListModel *)listModel;

-(void)currVideoProgressUpdate:(HomeListModel *)listModel current:(CGFloat)current total:(CGFloat)total;

@end

@interface HomeVideoCell : BaseTableViewCell<AVPlayerUpdateDelegate,SwitchPlayerMaskViewDelegate>

+ (NSString*) cellId;

@property(nonatomic, weak)id <HomeDelegate> homeDelegate;

@property(nonatomic,strong) HomeListModel * listModel;

/*
 新版播放器View，带有缓存功能。
 */
@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

/**遮罩*/
@property (nonatomic, strong) SwitchPlayerMaskView *maskView;


- (void)fillDataWithModel:(HomeListModel *)listModel;
- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;

@end
