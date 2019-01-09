//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "NetWork_mt_getFollowsVideoList.h"


//@protocol GetFollowsDelegate <NSObject>
//
//
//-(void)btnDeleteClick:(HomeListModel*)model;
//
//@end


#define FollowsVideoListCellIconHeight 50.0f   //icon+上下space 高度
#define FollowsVideoListCellTitleFont [UIFont defaultFontWithSize:13]
#define FollowsVideoListCellTitleWidth ScreenWidth - 20  //title(视频描述信息)的宽度
#define FollowsVideoListCellVideoWidth ScreenWidth *718/1080 //中间显示视频宽度
//中间显示视频高度，根据宽度和当前屏幕宽度的比例算出来
#define FollowsVideoListCellVideoHeight  ScreenHeight*FollowsVideoListCellVideoWidth/ScreenWidth

#define FollowsVideoListCellBottomHeight 50.0f   // 底部功能按钮+上下space 高度


#define FollowsVideoListCellHeight 580.0f


@interface FollowsVideoListCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(HomeListModel *)listModel;

@property(nonatomic,strong) HomeListModel * listModel;
@property(nonatomic,strong) UIButton * viewBg;
@property(nonatomic,strong) UILabel * labelLine;

@property(nonatomic,strong) UIImageView * imageVeiwIcon;
@property(nonatomic,strong) UILabel * labelUserName;
@property(nonatomic,strong) UILabel * labelTitle;


//@property(nonatomic,strong) UILabel * labelReadStatus;
//@property(nonatomic,strong) UILabel * labelSign;
//@property(nonatomic,strong) UILabel * labelTImes;

//@property(nonatomic,weak) id <GetFollowsDelegate> getFollowsDelegate;


@end
