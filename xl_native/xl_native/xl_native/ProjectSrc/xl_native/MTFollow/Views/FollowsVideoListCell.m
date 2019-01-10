//
//  ActiviteyCell.m
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "FollowsVideoListCell.h"

static NSString* const ViewTableViewCellId = @"FollowsVideoListCellId";


@implementation FollowsVideoListCell


#pragma mark - 类方法
+ (NSString*) cellId{
    return ViewTableViewCellId;
}


- (UIButton *)viewBg{
    if (_viewBg == nil){
        _viewBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBg.size = [UIView getSize_width:ScreenWidth height:FollowsVideoListCellHeight];
        _viewBg.origin = [UIView getPoint_x:0 y:0];
        [_viewBg setBackgroundColor:ColorThemeBackground forState:UIControlStateNormal];
        [_viewBg setBackgroundColor:RGBAlphaColor(29, 32, 42, 1) forState:UIControlStateHighlighted];
    }
    return _viewBg;
}

- (UILabel *)labelLine{
    if (_labelLine == nil){
        _labelLine = [[UILabel alloc]init];
        _labelLine.size = [UIView getSize_width:ScreenWidth - 30 height:0.3];
        _labelLine.origin = [UIView getPoint_x:15 y:FollowsVideoListCellHeight - _labelLine.height];
        _labelLine.backgroundColor = [UIColor grayColor]; //RGBAlphaColor(222, 222, 222, 0.8);
    }
    return _labelLine;
}

- (UIImageView *)imageVeiwIcon{
    if (_imageVeiwIcon == nil){
        _imageVeiwIcon = [[UIImageView alloc]init];
        _imageVeiwIcon.size = [UIView getSize_width:30 height:30];
        _imageVeiwIcon.origin = [UIView getPoint_x:10 y:10];
        
        _imageVeiwIcon.layer.cornerRadius = self.imageVeiwIcon.width/2;
        _imageVeiwIcon.layer.borderColor = ColorWhiteAlpha80.CGColor;
        _imageVeiwIcon.layer.borderWidth = 0.0;
        [_imageVeiwIcon.layer setMasksToBounds:YES];
        _imageVeiwIcon.userInteractionEnabled = YES;
    }
    return _imageVeiwIcon;
}

- (UILabel *)labelUserName{
    if (_labelUserName == nil){
        _labelUserName = [[UILabel alloc]init];
        _labelUserName.size = [UIView getSize_width:200 height:20];
        _labelUserName.centerY = self.imageVeiwIcon.centerY;
        _labelUserName.left = self.imageVeiwIcon.right + 10;
        _labelUserName.font = [UIFont defaultBoldFontWithSize:12];
        _labelUserName.textColor = [UIColor whiteColor];
    }
    return _labelUserName;
}

- (UILabel *)labelTitle{
    if (_labelTitle == nil){
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.size = [UIView getSize_width:FollowsVideoListCellTitleWidth height:20]; //宽度为屏幕的 718/1080
        _labelTitle.top = self.imageVeiwIcon.bottom + 10;
        _labelTitle.left = self.imageVeiwIcon.left;
        _labelTitle.font = FollowsVideoListCellTitleFont;
        _labelTitle.textColor = [UIColor whiteColor];
        _labelTitle.numberOfLines = 0;

    }
    return _labelTitle;
}

-(AVPlayerView*)playerView{
    if(!_playerView){
        CGRect frame = CGRectMake(self.imageVeiwIcon.left, self.labelTitle.bottom, FollowsVideoListCellVideoWidth, FollowsVideoListCellVideoHeight);
        _playerView = [[AVPlayerView alloc] initWithFrame:frame];
        _playerView.delegate = self;
        //test
        _playerView.backgroundColor = [UIColor blueColor];
    }
    return _playerView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self.contentView addSubview:self.viewBg];
    
    [self.viewBg addSubview:self.labelLine];
    [self.viewBg addSubview:self.imageVeiwIcon];
    [self.viewBg addSubview:self.labelUserName];
    [self.viewBg addSubview:self.labelTitle];
    [self.viewBg addSubview:self.playerView];
}
- (void)fillDataWithModel:(HomeListModel *)model{
    
    /*cell 的高度组成部分相加*/
//    CGFloat cellHeight = FollowsVideoListCellIconHeight + model.fpllowVideoListTitleHeight + FollowsVideoListCellVideoHeight+FollowsVideoListCellBottomHeight+FollowsVideoListCellSpace*2;
    self.viewBg.height = model.fpllowVideoListCellHeight;
    self.labelLine.top = self.viewBg.height - self.labelLine.height;
    self.labelTitle.height = model.fpllowVideoListTitleHeight;
    self.playerView.top = self.labelTitle.bottom+FollowsVideoListCellSpace;
    self.listModel = model;
    
    
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    self.labelUserName.text = [NSString stringWithFormat:@"@%@",model.nickname];
    self.labelTitle.text = model.title;
    
//    NSString *playUrl = model.storagePath;
//    [self.playerView setPlayerWithUrl:playUrl];
//    [self.playerView play];
}


- (void)play {
    [self.playerView play];
//    [self.maskView hidePlayBtn];
}

- (void)pause {
    [self.playerView pause];
//    [self.maskView showPlayBtn];
}

- (void)replay {
    [self.playerView replay];
//    [self.maskView hidePlayBtn];
}

- (void)startDownloadBackgroundTask {
    
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView setPlayerWithUrl:playUrl];
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = self.listModel.storagePath;
    [self.playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
}

#pragma mark ---------AVPlayerUpdateDelegate-------------

//播放进度更新回调方法
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total{
    
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

- (void)btnDelClick:(id)sender{
    
//    if ([self.getFollowsDelegate respondsToSelector:@selector(btnDeleteClick:)]) {
//        [self.getFollowsDelegate btnDeleteClick:self.listModel];
//    } else {
//        NSLog(@"代理没响应，快开看看吧");
//    }
}

@end
