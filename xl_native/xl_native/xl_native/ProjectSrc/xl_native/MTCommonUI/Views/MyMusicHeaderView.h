//
//  MYHeaderView.h
//  CMPLjhMobile
//
//  Created by lei song on 16/7/31.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "NetWork_mt_getHotVideosByMusic.h"
#import <AVFoundation/AVFoundation.h>


@protocol MusicHeadDelegate <NSObject>

-(void)btnCollectionClick:(GetHotVideosByMusicModel*)model;

@end

@interface MyMusicHeaderView : UICollectionReusableView<AVAudioPlayerDelegate>


@property(nonatomic,strong) UIImageView *imageViewCover;
@property(nonatomic ,strong) UIButton *btnPauseIcon; //播放暂停按钮
@property(nonatomic,assign) BOOL isPlayMusic;
@property (nonatomic,strong) AVPlayer *player;



@property(nonatomic,strong) UILabel *lableTopicName;
@property(nonatomic,strong) UILabel *lablePlayCount;

@property (nonatomic, strong) UIButton  *btnCollectionBg; //收藏按钮背景
@property (nonatomic, strong) UIImageView    *imageViewCollectionIcon;  //收藏图标
@property (nonatomic, strong) UILabel    *lableCollectionTitle;  //收藏标题

@property(nonatomic,strong) GetHotVideosByMusicModel * topicModel;


/*点击收藏按钮*/
@property(nonatomic,weak) id <MusicHeadDelegate> delegate;

- (void)initData:(GetHotVideosByMusicModel *)topicModel;

/**销毁播放器*/
- (void)destroyPlayer;

/**暂停播放器*/
- (void)pauseMusic;

@end
