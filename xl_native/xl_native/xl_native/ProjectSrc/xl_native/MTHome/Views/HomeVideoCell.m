//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "HomeVideoCell.h"

static NSString* const ViewTableViewCellId = @"HomeVideoCellId";

@implementation HomeVideoCell


+ (NSString*) cellId{
    return ViewTableViewCellId;
}

#pragma mark --------- 懒加载 --------

- (SwitchPlayerView *)playerView{
    
    if (!_playerView) {
        __weak __typeof(self) weakSelf = self;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, HomeVideoCellHeight);
        _playerView = [[SwitchPlayerView alloc] initWithFrame:frame];
        _playerView.pushUserInfo = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(userInfoClicked:)]) {
                [weakSelf.homeDelegate userInfoClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        _playerView.followClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(followClicked:)]) {
                [weakSelf.homeDelegate followClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
        };
        _playerView.zanClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(zanClicked:)]) {
                [weakSelf.homeDelegate zanClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        
        _playerView.commentClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(commentClicked:)]) {
                [weakSelf.homeDelegate commentClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };


        _playerView.shareClick = ^{
            
            if ([weakSelf.homeDelegate respondsToSelector:@selector(shareClicked:)]) {
                [weakSelf.homeDelegate shareClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
            
        };
        
        _playerView.musicCDClick = ^{
            if ([weakSelf.homeDelegate respondsToSelector:@selector(musicCDClicked:)]) {
                [weakSelf.homeDelegate musicCDClicked:weakSelf.listModel];
            } else {
                NSLog(@"代理没响应，快开看看吧");
            }
        };


    }
    return _playerView;
}

-(AVPlayerView*)playerView_temp{
    if(!_playerView_temp){
        CGRect frame = CGRectMake(0, 0, ScreenWidth, HomeVideoCellHeight);
        _playerView_temp = [[AVPlayerView alloc] initWithFrame:frame];
        _playerView_temp.delegate = self;
        //test
//        _playerView_temp.backgroundColor = [UIColor blueColor];
    }
    return _playerView_temp;
}


//遮罩
- (SwitchPlayerMaskView_temp *) maskView{
    if (_maskView == nil){
        _maskView  = [[SwitchPlayerMaskView_temp alloc] initWithFrame:self.playerView_temp.bounds];
        _maskView.delegate = self;
    }
    return _maskView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //contentView 的默认高度是 44 ，需要先设置一下宽和高
    self.contentView.height = HomeVideoCellHeight;
    self.contentView.width = ScreenWidth;
    [self setBackgroundImage:@"img_video_loading"]; //cell 设置背景图
    [self bringSubviewToFront:self.contentView];

//    self.contentView.backgroundColor = [GlobalFunc randomColor];
    [self.contentView addSubview:self.playerView_temp];
    [self.contentView addSubview:self.maskView];
    
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    //[self.contentView addSubview:self.playerView];
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self addSubview:background];
}



- (void)fillDataWithModel:(HomeListModel *)model{
    
    self.listModel = model;
    self.maskView.listLoginModel = model;
//    self.playerView.listLoginModel = model;
//    self.playerView.url = [NSURL URLWithString:model.storagePath];//视频地址
//    [self.playerView playVideo];
}


- (void)play {
    [self.playerView_temp play];
    [self.maskView hidePlayBtn];

//    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [self.playerView_temp pause];
    [self.maskView showPlayBtn];

//    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [self.playerView_temp replay];
//    [_pauseIcon setHidden:YES];
    [self.maskView hidePlayBtn];
}

- (void)startDownloadBackgroundTask {
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView_temp setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView_temp startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
}

#pragma mark ---------AVPlayerUpdateDelegate-------------

-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status { //播放状态更新
    switch (status) {
        case AVPlayerItemStatusUnknown:
//            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
//            [_musicAlum startAnimation:_aweme.rate];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnim:NO];
            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

#pragma mark ---------SwitchPlayerMaskViewDelegate-------------


/*关注*/
- (void)followButtonAction:(UIButton *)button{
    
    if ([self.homeDelegate respondsToSelector:@selector(followClicked:)]) {
        [self.homeDelegate followClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)playButtonAction:(BOOL)isPlay{
    
    if(isPlay){
        [self play];
    }
    else{
        [self pause];
    }
}

/*点赞*/
- (void)zanButtonAction:(FavoriteView *)favoriteView{
    
    if ([self.homeDelegate respondsToSelector:@selector(zanClicked:)]) {
        [self.homeDelegate zanClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}


// 查看用户信息
- (void)userInfoAction{
    
    if ([self.homeDelegate respondsToSelector:@selector(userInfoClicked:)]) {
        [self.homeDelegate userInfoClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)commentAction { //查看评论
    
    if ([self.homeDelegate respondsToSelector:@selector(commentClicked:)]) {
        [self.homeDelegate commentClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)shareAction { //查看评论
    
    if ([self.homeDelegate respondsToSelector:@selector(shareClicked:)]) {
        [self.homeDelegate shareClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

- (void)musicCdAction { //查看评论
    
    if ([self.homeDelegate respondsToSelector:@selector(musicCDClicked:)]) {
        [self.homeDelegate musicCDClicked:self.listModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}


@end
