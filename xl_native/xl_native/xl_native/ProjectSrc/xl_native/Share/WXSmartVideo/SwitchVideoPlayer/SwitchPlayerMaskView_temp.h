//
//  CLPlayerMaskView.h
//  CLPlayerDemo
//
//  Created by songleilei on 2017/2/24.
//  Copyright © 2017年 songleilei. All rights reserved.
//



#import "CircleTextView.h"
#import "MusicAlbumView.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
#import "FavoriteView.h"
#import "FocusView.h"
#import "WebCacheHelpler.h"
#import "NetWork_mt_home_list.h"

/**
 *  space
 */
#define  Video_Btn_space      20.0f


@protocol SwitchPlayerMaskViewDelegate_Temp <NSObject>

/**返回按钮代理*/
- (void)backButtonAction:(UIButton *)button;
- (void)userInfoAction;///< 查看用户信息
- (void)commentAction;///< 查看用户信息
- (void)shareAction;///< 分享
- (void)musicCdAction;///< 旋转CD

/**播放按钮*/
- (void)playButtonAction:(UIButton *)button;

/*关注*/
- (void)followButtonAction:(FocusView *)button;

/*点赞*/
- (void)zanButtonAction:(FavoriteView *)favoriteView;

@end

@interface SwitchPlayerMaskView_temp : UIView


-(instancetype)initWithFrame:(CGRect)frame;

/*初始化方法传入listLoginModel*/
-(instancetype)initWithFrame:(CGRect)frame listLoginModel:(HomeListModel *)listLoginModel;


/*
 新版UI布局
 */
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;

@property (nonatomic, strong) UIImageView      *musicIcon;
@property (nonatomic, strong) CircleTextView   *musicName;
@property (nonatomic, strong) MusicAlbumView   *musicAlum;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;

@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UILabel          *shareNum;

@property (nonatomic, strong) UIImageView      *comment;
@property (nonatomic, strong) UILabel          *commentNum;

@property (nonatomic, strong) FavoriteView     *favorite;
@property (nonatomic, strong) UILabel          *favoriteNum;

@property (nonatomic, strong) UIImageView      *avatar; //头像
@property (nonatomic, strong) FocusView        *focus;

@property (nonatomic ,strong) UIImageView      *pauseIcon;

@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;


/**播放按钮*/
@property(nonatomic,strong) UIButton * btnPlay;

/*视频model*/
@property (nonatomic, strong) HomeListModel *listLoginModel;

/**代理人*/
@property (nonatomic,weak) id<SwitchPlayerMaskViewDelegate_Temp> delegate;


-(void)showPlayBtn;
-(void)hidePlayBtn;

@end
