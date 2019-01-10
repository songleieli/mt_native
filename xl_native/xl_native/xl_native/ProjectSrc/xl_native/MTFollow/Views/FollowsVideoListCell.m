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

#pragma ----------mark 懒加载------

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
        _playerView.layer.cornerRadius = 8.0f;
        _playerView.layer.masksToBounds = YES;
        _playerView.delegate = self;
        //test
//        _playerView.backgroundColor = [UIColor blueColor];
    }
    return _playerView;
}

- (UIImageView *) musicIcon{
    if (_musicIcon == nil){
        //init aweme message //音乐icon
        _musicIcon = [[UIImageView alloc]init];
        _musicIcon.size =  [UIView getScaleSize_width:30 height:25];
        _musicIcon.left = 0;
        _musicIcon.bottom = self.playerView.height;
        _musicIcon.contentMode = UIViewContentModeCenter;
        _musicIcon.image = [UIImage imageNamed:@"icon_home_musicnote3"];
        
        //test
//        _musicIcon.backgroundColor = [UIColor redColor];
    }
    return _musicIcon;
}

- (CircleTextView *) musicName{
    if (_musicName == nil){
        //音乐名称
        _musicName = [[CircleTextView alloc]init];
        _musicName.left = self.musicIcon.right;
        _musicName.textColor = ColorWhite;
        _musicName.font = MediumFont;
        _musicName.width = self.width/2;
        _musicName.height = 24;
        _musicName.centerY = self.musicIcon.centerY; //centerY 需要放在宽高设置完成之后，要不然不起作用。
        
        //        _musicName.backgroundColor = [UIColor redColor];
    }
    return _musicName;
}

- (UIView *) bottomView{
    if (_bottomView == nil){
        //音乐名称
        _bottomView = [[CircleTextView alloc]init];
        _bottomView.left = self.imageVeiwIcon.left;
        _bottomView.width = self.viewBg.width - FollowsVideoListCellSpace*2;
        _bottomView.height = FollowsVideoListCellBottomHeight;
        _bottomView.top = self.playerView.bottom;
        
        //test
//        _bottomView.backgroundColor = [UIColor redColor];
    }
    return _bottomView;
}

- (FavoriteView *) favorite{
    if (_favorite == nil){ //
        
        CGRect frame = CGRectMake(0, 0, 30, 28);
        _favorite = [[FavoriteView alloc]initWithFrame:frame];
        _favorite.favoriteAfter.contentMode = UIViewContentModeScaleAspectFit;
        _favorite.favoriteBefore.contentMode = UIViewContentModeScaleAspectFit;
        _favorite.userInteractionEnabled = YES;
        _favorite.top = (self.bottomView.height-_favorite.height)/2;//上下居中
        _favorite.likeClickBlock = ^(FavoriteView *favoriteView) {
            //点赞按钮响应事件
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zanButtonAction:)]) {
//                [weakSelf.delegate zanButtonAction:favoriteView];
//            }else{
//                NSLog(@"没有实现代理或者没有设置代理人");
//            }
        };
        //test
//        _favorite.backgroundColor = [UIColor redColor];
    }
    return _favorite;
}

- (UILabel *) favoriteNum{
    if (_favoriteNum == nil){ //
        _favoriteNum = [[UILabel alloc]init];
        _favoriteNum.text = @"0";
        _favoriteNum.textColor = ColorWhite;
        _favoriteNum.font = SmallFont;
        _favoriteNum.textAlignment = NSTextAlignmentCenter;
        
        //        _favoriteNum.top = self.favorite.bottom;
        _favoriteNum.height = 20;
        _favoriteNum.width = 50;
        _favoriteNum.left = self.favorite.right;
        _favoriteNum.centerY = self.favorite.centerY;
        
        //test
//        _favoriteNum.backgroundColor = [UIColor blueColor];
    }
    return _favoriteNum;
}

- (UIImageView *) comment{
    if (_comment == nil){ //
        //init share、comment、like action view
        _comment = [[UIImageView alloc]init];
        _comment.contentMode = UIViewContentModeScaleAspectFit;
        _comment.image = [UIImage imageNamed:@"icon_home_comment"];
        _comment.userInteractionEnabled = YES;
//        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//        [_comment addGestureRecognizer:_singleTapGesture];
        
        _comment.width = 30;
        _comment.height = 28;
        _comment.left = self.favoriteNum.right;
        _comment.centerY = self.favorite.centerY;
    }
    return _comment;
}

- (UILabel *) commentNum{
    if (_commentNum == nil){ //
        _commentNum = [[UILabel alloc]init];
        _commentNum.text = @"0";
        _commentNum.textColor = ColorWhite;
        _commentNum.font = SmallFont;
        _commentNum.textAlignment = NSTextAlignmentCenter;
        
        
        _commentNum.left = self.comment.right;
        _commentNum.height = 20;
        _commentNum.width = 50;
        _commentNum.centerY = self.favorite.centerY;
    }
    return _commentNum;
}

- (UIImageView *) share{
    if (_share == nil){ //
        //init share、comment、like action view
        _share = [[UIImageView alloc]init];
        _share.contentMode = UIViewContentModeScaleAspectFit;
        _share.image = [UIImage imageNamed:@"icon_home_share"];
        _share.userInteractionEnabled = YES;
//        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//        [_share addGestureRecognizer:_singleTapGesture];
        
        _share.width = 30;
        _share.height = 28;
        _share.left = self.commentNum.right;
        _share.centerY = self.favorite.centerY;
    }
    return _share;
}

- (UILabel *) shareNum{
    if (_shareNum == nil){ //
        _shareNum = [[UILabel alloc]init];
        _shareNum.text = @"0";
        _shareNum.textColor = ColorWhite;
        _shareNum.font = SmallFont;
        _shareNum.textAlignment = NSTextAlignmentCenter;
        
        
        _shareNum.left = self.share.right;
        _shareNum.height = 20;
        _shareNum.width = 50;
        _shareNum.centerY = self.favorite.centerY;
    }
    return _shareNum;
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
    
    [self.playerView addSubview:self.musicIcon];
    [self.playerView addSubview:self.musicName];
    
    [self.viewBg addSubview:self.bottomView];
    [self.bottomView addSubview:self.favorite];
    [self.bottomView addSubview:self.favoriteNum];
    [self.bottomView addSubview:self.comment];
    [self.bottomView addSubview:self.commentNum];
    [self.bottomView addSubview:self.share];
    [self.bottomView addSubview:self.shareNum];
}
- (void)fillDataWithModel:(HomeListModel *)model{
    
    /*cell 的高度组成部分相加*/
//    CGFloat cellHeight = FollowsVideoListCellIconHeight + model.fpllowVideoListTitleHeight + FollowsVideoListCellVideoHeight+FollowsVideoListCellBottomHeight+FollowsVideoListCellSpace*2;
    self.viewBg.height = model.fpllowVideoListCellHeight;
    self.labelLine.top = self.viewBg.height - self.labelLine.height;
    self.labelTitle.height = model.fpllowVideoListTitleHeight;
    self.playerView.top = self.labelTitle.bottom+FollowsVideoListCellSpace;
    self.bottomView.top = self.playerView.bottom+FollowsVideoListCellSpace;
    
    
    self.listModel = model;
    
    
    [self.imageVeiwIcon sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"img_find_default"]];
    self.labelUserName.text = [NSString stringWithFormat:@"@%@",model.nickname];
    self.labelTitle.text = model.title;
    self.musicName.text = model.musicName;
    
    self.shareNum.text = [NSString stringWithFormat:@"%d",[model.saveAlbumSum intValue] ];
    self.commentNum.text = [NSString stringWithFormat:@"%d",[model.commentSum intValue] ];
    self.favoriteNum.text = [NSString stringWithFormat:@"%d",[model.likeSum intValue] ];
    
    
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
