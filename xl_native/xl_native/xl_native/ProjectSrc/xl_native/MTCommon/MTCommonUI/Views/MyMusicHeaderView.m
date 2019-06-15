//
//  MYHeaderView.m
//  CMPLjhMobile
//
//  Created by lei song on 16/7/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MyMusicHeaderView.h"

@implementation MyMusicHeaderView





- (UIImageView*)imageViewCover{
    
    if (!_imageViewCover) {
        _imageViewCover = [[UIImageView alloc] init];
        _imageViewCover.size = [UIView getSize_width:120 height:120];
        _imageViewCover.backgroundColor = RGBA(54, 58, 67, 1);
        _imageViewCover.origin = [UIView getPoint_x:15 y:15];
        _imageViewCover.userInteractionEnabled  =   YES;
    }
    return _imageViewCover;
}

/*
 暂停按钮
 */
- (UIButton *) btnPauseIcon{
    if (_btnPauseIcon == nil){
        _btnPauseIcon = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UIImageView alloc] init];
        //_btnPauseIcon.image = [UIImage imageNamed:@"ugc_play_music"];
        [_btnPauseIcon setBackgroundImage:[UIImage imageNamed:@"ugc_play_music"] forState:UIControlStateNormal];
        _btnPauseIcon.contentMode = UIViewContentModeCenter;
        //众所周知CALayer的zPosition等效于在Z轴上做了个偏移Transform。所以我们可以通过3D Transform来视觉化各个CALayer的zPosition。
        _btnPauseIcon.layer.zPosition = 3; //去掉和没去掉，没有多大差别
        _btnPauseIcon.width = _btnPauseIcon.height = 40;
        [_btnPauseIcon addTarget:self action:@selector(btnPlayMusicClick:) forControlEvents:UIControlEventTouchUpInside];
        //居中
        _btnPauseIcon.top = (self.imageViewCover.height - _btnPauseIcon.height)/2;
        _btnPauseIcon.left = (self.imageViewCover.width - _btnPauseIcon.width)/2;
    }
    return _btnPauseIcon;
}



- (UILabel*)lableTopicName{
    
    if (!_lableTopicName) {
        _lableTopicName = [[UILabel alloc] init];
        _lableTopicName.font = [UIFont defaultBoldFontWithSize:20];
        _lableTopicName.textColor = [UIColor whiteColor];
        _lableTopicName.size = [UIView getSize_width:self.width - self.imageViewCover.width - 15*3 height:30];
        _lableTopicName.textAlignment = NSTextAlignmentLeft;
        _lableTopicName.origin = [UIView getPoint_x:self.imageViewCover.right + 15 y:15];
    }
    return _lableTopicName;
}

- (UIButton*)btnAuthor{

    if (!_btnAuthor) {
        _btnAuthor = [UIButton buttonWithType:UIButtonTypeCustom]; //[[UILabel alloc]init];
        _btnAuthor.size = [UIView getSize_width:220 height:30];
        _btnAuthor.origin = [UIView getPoint_x:self.lableTopicName.left y:self.lableTopicName.bottom];
        _btnAuthor.titleLabel.font = [UIFont defaultFontWithSize:14];
        [_btnAuthor setTitleColor:ColorWhiteAlpha80 forState:UIControlStateNormal];
        [_btnAuthor setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _btnAuthor.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnAuthor addTarget:self action:@selector(btnAuthorClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnAuthor;
}

- (UILabel*)lablePlayCount{
    
    if (!_lablePlayCount) {
        _lablePlayCount = [[UILabel alloc]init];
        _lablePlayCount.size = [UIView getSize_width:220 height:30];
        _lablePlayCount.origin = [UIView getPoint_x:self.lableTopicName.left y:self.btnAuthor.bottom];
        _lablePlayCount.font = [UIFont defaultFontWithSize:14];
        _lablePlayCount.textColor = ColorWhiteAlpha80;
    }
    return _lablePlayCount;
}

- (UIButton*)btnCollectionBg{
    
    if (!_btnCollectionBg) {
        _btnCollectionBg = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCollectionBg.size = [UIView getSize_width:85 height:25];
        _btnCollectionBg.origin = [UIView getPoint_x:self.lableTopicName.left y:self.lablePlayCount.bottom];
        [_btnCollectionBg setBackgroundColor:MTColorBtnNormal forState:UIControlStateNormal];
        [_btnCollectionBg setBackgroundColor:MTColorBtnHighlighted forState:UIControlStateHighlighted];
        _btnCollectionBg.layer.cornerRadius = 2.0f;
        _btnCollectionBg.layer.masksToBounds = true;//给按钮添加边框效果
        [_btnCollectionBg addSubview:self.imageViewCollectionIcon];
        [_btnCollectionBg addSubview:self.lableCollectionTitle];
        [_btnCollectionBg addTarget:self action:@selector(btnCollectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCollectionBg;
}

- (UIImageView*)imageViewCollectionIcon{
    
    if (!_imageViewCollectionIcon) {
        _imageViewCollectionIcon = [[UIImageView alloc] init];
        _imageViewCollectionIcon.size = [UIView getSize_width:12.5 height:12.5];
        _imageViewCollectionIcon.origin = [UIView getPoint_x:(_btnCollectionBg.width - _imageViewCollectionIcon.width)/2 - _imageViewCollectionIcon.width-2
                                                           y:(_btnCollectionBg.height - _imageViewCollectionIcon.height)/2];
        _imageViewCollectionIcon.image = [UIImage imageNamed:@"icon_home_all_share_collention"];
    }
    return _imageViewCollectionIcon;
}

- (UILabel*)lableCollectionTitle{
    
    if (!_lableCollectionTitle) {
        _lableCollectionTitle = [[UILabel alloc] init];
        _lableCollectionTitle.size = [UIView getSize_width:_btnCollectionBg.width/2 height:_btnCollectionBg.height];
        _lableCollectionTitle.origin = [UIView getPoint_x:self.imageViewCollectionIcon.right+5 y:0];
        _lableCollectionTitle.textColor = [UIColor whiteColor];
        _lableCollectionTitle.textAlignment = NSTextAlignmentLeft;
        _lableCollectionTitle.text = @"收藏";
        _lableCollectionTitle.font = [UIFont defaultFontWithSize:12];
        
        //test
//        _lableCollectionTitle.backgroundColor = [UIColor redColor];
    }
    return _lableCollectionTitle;
}



- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.isPlayMusic = NO;
        [self setUI];
    }
    return self;
}

#pragma -mark --------- 自定义方法 ------------


- (void)destroyPlayer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player pause];
    //移除
    self.player      = nil;
}

- (void)pauseMusic{
    
    if(self.player){
        [self.player pause];
        self.isPlayMusic = NO;
        [self.btnPauseIcon setBackgroundImage:[UIImage imageNamed:@"ugc_play_music"] forState:UIControlStateNormal];
    }
}


-(void)setUI{
    [self addSubview:self.imageViewCover]; //音乐封面
    [self.imageViewCover addSubview:self.btnPauseIcon]; //播放暂停按钮
    
    [self addSubview:self.lableTopicName];
    [self addSubview:self.btnAuthor];
    [self addSubview:self.lablePlayCount];
    [self addSubview:self.btnCollectionBg];
}


- (void)initData:(GetHotVideosByMusicModel *)musicModel {
    
    
    if (!_player) {
        //获取音频文件
        NSURL *musicUrl = [NSURL URLWithString:musicModel.playUrl];
        AVPlayerItem * musicItem = [[AVPlayerItem alloc]initWithURL:musicUrl];
        _player = [[AVPlayer alloc]initWithPlayerItem:musicItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:musicItem];
    }
    
    self.topicModel = musicModel;
    
    [self.imageViewCover sd_setImageWithURL:[NSURL URLWithString:musicModel.coverUrl] placeholderImage:[UIImage imageNamed:@"default_music_cover"]];
    self.lableTopicName.text = musicModel.musicName;
//    self.lableAuthor.text = [NSString stringWithFormat:@"%@ >",musicModel.nickname];
    [self.btnAuthor setTitle:[NSString stringWithFormat:@"%@ >",musicModel.nickname] forState:UIControlStateNormal];
    self.lablePlayCount.text = [NSString stringWithFormat:@"%@人参与",[NSString formatCount:[musicModel.useCount integerValue]]];
    if([musicModel.isCollect integerValue] == 0){
        self.lableCollectionTitle.text = @"收藏";
    }
    else{
        self.lableCollectionTitle.text = @"已收藏";
    }
}

#pragma -mark --------- 点击事件 ------------

-(void)btnAuthorClick:(UIButton*)btn{
    
    /*
     音乐的作者信息没有爬下来，所以暂时先屏蔽这个功能。
     */
//    if ([self.delegate respondsToSelector:@selector(btnAuthorClick:)]) {
//        [self.delegate btnAuthorClick:self.topicModel];
//    } else {
//        NSLog(@"代理没响应，快开看看吧");
//    }
}

-(void)btnCollectionClick:(UIButton*)btn{
    
    if ([self.delegate respondsToSelector:@selector(btnCollectionClick:)]) {
        [self.delegate btnCollectionClick:self.topicModel];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}


/*
 <AVAudioPlayerDelegate>
 当播放结束后调用：
 */
- (void)playbackFinished:(NSNotification *)notice {
    
    NSLog(@"----playbackFinished--");
}

-(void)btnPlayMusicClick:(UIButton*)btn{
    
    self.isPlayMusic = !self.isPlayMusic;
    if(self.isPlayMusic){ //如果播放，显示暂停按钮，如果暂停显示播放按钮
        [btn setBackgroundImage:[UIImage imageNamed:@"ugc_pause_music"] forState:UIControlStateNormal];
        //播放音乐
        [self.player play];
    }
    else{
        [btn setBackgroundImage:[UIImage imageNamed:@"ugc_play_music"] forState:UIControlStateNormal];
        //暂停音乐
        [self.player pause];
    }
}



@end
