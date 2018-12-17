//
//  PlayerView.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchPlayerMaskView_temp.h"
#import "NetWork_mt_home_list.h"

@interface SwitchPlayerView : UIView<SwitchPlayerMaskViewDelegate_Temp>

-(instancetype)initWithFrame:(CGRect)frame;
/*初始化方法传入listLoginModel*/
//-(instancetype)initWithFrame:(CGRect)frame listLoginModel:(HomeListModel *)listLoginModel;

/**视频url*/
@property (nonatomic, strong) NSURL *url;
/**播放*/
- (void)playVideo;
/**暂停*/
- (void)pausePlay;
/**销毁播放器*/
- (void)destroyPlayer;

/**返回按钮Block*/

//@property (nonatomic, strong) void (^backBlock)();

/*视频model*/
@property (nonatomic, strong) HomeListModel *listLoginModel;
/**遮罩*/
@property (nonatomic, strong) SwitchPlayerMaskView_temp *maskView;

@property (copy, nonatomic) dispatch_block_t pushUserInfo; ///< 进入个人信息页面
@property (copy, nonatomic) dispatch_block_t commentClick; ///< 评论
@property (copy, nonatomic) dispatch_block_t followClick; ///<关注
@property (copy, nonatomic) dispatch_block_t zanClick; ///赞
@property (copy, nonatomic) dispatch_block_t hideCommentClick; //隐藏评论页面

@property (copy, nonatomic) dispatch_block_t shareClick; //分享
@property (copy, nonatomic) dispatch_block_t musicCDClick; //旋转CD点击

@end
