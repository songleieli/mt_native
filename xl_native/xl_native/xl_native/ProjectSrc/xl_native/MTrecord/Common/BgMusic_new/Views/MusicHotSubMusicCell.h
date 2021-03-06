//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TCBGMProgressView.h"


#import "NetWork_mt_search_getMusicList.h"


@protocol MusicHotSubDelegate <NSObject>

-(void)useMusicClick:(MusicSearchModel*)model;

-(void)playMusic:(MusicSearchModel*)model;

-(void)pauseMusic;

@end


#define MusicHotSubMusicCellHeight 80.0f
#define MusicHotSubMusicCellSpace 6.0f


@interface MusicHotSubMusicCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(MusicSearchModel *)listModel;

@property(nonatomic,strong) MusicSearchModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UIImageView * imageVeiwIcon;
@property(nonatomic ,strong) UIButton *btnPauseIcon; //播放暂停按钮
@property(nonatomic,assign) BOOL isPlayMusic;

@property(nonatomic,strong) UILabel * labelReadStatus;
@property(nonatomic,strong) UILabel * labelTitle;
@property(nonatomic,strong) UILabel * labelSign;
@property (nonatomic, strong) UILabel *lableuseCount;

@property (nonatomic, strong) UIButton *btnDownLoad;
@property (nonatomic, strong) TCBGMProgressView *progressView;


@property(nonatomic,weak) id <MusicHotSubDelegate> subCellDelegate;


@end
