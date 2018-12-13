//
//  ActiviteyCell.h
//  CMPLjhMobile
//
//  Created by iOS开发 on 16/5/27.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NetWork_mt_home_list.h"
#import "SwitchPlayerView.h"

#define HomeVideoCellHeight ScreenHeight


@protocol HomeDelegate <NSObject>

- (void)userInfoClicked:(HomeListModel *)listModel;

- (void)followClicked:(HomeListModel *)listModel;

- (void)zanClicked:(HomeListModel *)listModel;

- (void)commentClicked:(HomeListModel *)listModel;

- (void)shareClicked:(HomeListModel *)listModel;

- (void)musicCDClicked:(HomeListModel *)listModel;



@end

@interface HomeVideoCell : BaseTableViewCell

+ (NSString*) cellId;

- (void)fillDataWithModel:(HomeListModel *)listModel;


@property(nonatomic, weak)id <HomeDelegate> homeDelegate;

@property(nonatomic,strong) HomeListModel * listModel;

/*播放器*/
@property (nonatomic,strong) SwitchPlayerView *playerView;


@end
