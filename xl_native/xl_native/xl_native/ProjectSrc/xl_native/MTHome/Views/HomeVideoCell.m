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

-(AVPlayerView*)playerView{
    if(!_playerView){
        CGRect frame = CGRectMake(0, 0, ScreenWidth, HomeVideoCellHeight);
        _playerView = [[AVPlayerView alloc] initWithFrame:frame];
        _playerView.delegate = self;
        //test
//        _playerView.backgroundColor = [UIColor blueColor];
    }
    return _playerView;
}


-(UIView*)playerStatusBar{
    if(!_playerStatusBar){
        _playerStatusBar = [[UIView alloc]init];
        _playerStatusBar.size = [UIView getSize_width:1.0f height:0.5];
        _playerStatusBar.centerX = ScreenWidth/2;
        _playerStatusBar.bottom = HomeVideoCellHeight - kTabBarHeight_New;
        _playerStatusBar.backgroundColor = [UIColor yellowColor];
        [_playerStatusBar setHidden:YES];
    }
    return _playerStatusBar;
}


//遮罩
- (SwitchPlayerMaskView *) maskView{
    if (_maskView == nil){
        _maskView  = [[SwitchPlayerMaskView alloc] initWithFrame:self.playerView.bounds];
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
    [self setBackgroundImage:@"default_bg_cover"]; //cell 设置背景图
    [self bringSubviewToFront:self.contentView];

//    self.contentView.backgroundColor = [GlobalFunc randomColor];
    [self.contentView addSubview:self.playerView];
    [self.contentView addSubview:self.playerStatusBar];
    
    [self.contentView addSubview:self.maskView];
}

#pragma mark --------- CustomMethod -------------


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
    

}


- (void)play {
    [self.playerView play];
    [self.maskView hidePlayBtn];
}

- (void)pause {
    [self.playerView pause];
    [self.maskView showPlayBtn];
}

- (void)replay {
    [self.playerView replay];
    [self.maskView hidePlayBtn];
}

- (void)startDownloadBackgroundTask {
    
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
}


//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = [UIColor yellowColor];
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
    
}



#pragma mark --------- prepareForReuse j-------------

/*
 cell被重用如何提前知道? 重写cell的prepareForReuse官方头文件中有说明.当前已经被分配的cell如果被重用了(通常是滚动出屏幕外了),会调用cell的prepareForReuse通知cell.注意这里重写方法的时候,注意一定要调用父类方法[super prepareForReuse] .这个在使用cell作为网络访问的代理容器时尤其要注意,需要在这里通知取消掉前一次网络请求.不要再给这个cell发数据了.
 */

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
    [self.playerView cancelLoading];
    [self.maskView hidePlayBtn];
}

#pragma mark ---------AVPlayerUpdateDelegate-------------

-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
    
//    NSLog(@"------------current = %f-----total = %f------------",current,total);
    
    if ([self.homeDelegate respondsToSelector:@selector(followClicked:)]) {
        [self.homeDelegate currVideoProgressUpdate:self.listModel current:current total:total];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
    
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status { //播放状态更新
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
        {
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
//            [_musicAlum startAnimation:_aweme.rate];
            
            
            //根据视频的宽高比例，显示视频的填充方式
            NSArray *array = self.playerView.urlAsset.tracks;
            CGSize videoSize = CGSizeZero;
            for (AVAssetTrack *track in array) {
                if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                    videoSize = track.naturalSize;
                }
            }
            
            //视频宽高比
            CGFloat whScale = videoSize.width/videoSize.height;
            if(whScale > 0.6){
                self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            }
            else{
                self.playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            }
            
//            NSLog(@"-------------videoSize = %@",NSStringFromCGSize(videoSize));
//            NSLog(@"-------------whScale = %f",whScale);

            if(_onPlayerReady) {
                _onPlayerReady();
            }
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
    
    //响应代理
    if ([self.homeDelegate respondsToSelector:@selector(playButtonAction:)]) {
        [self.homeDelegate playButtonAction:isPlay];
    } else {
        NSLog(@"代理没响应，快开看看吧");
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
