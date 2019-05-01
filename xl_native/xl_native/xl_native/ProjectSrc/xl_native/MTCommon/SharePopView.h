//
//  SharePopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWork_mt_home_list.h"
#import "NetWork_mt_forwardVideoCount.h" //统计分享数量


typedef NS_ENUM(NSInteger, MTShareType){
    
    MTShareTypeFriendCircle = 0,
    MTShareTypeWechat,
    MTShareTypeQQZone,
    MTShareTypeQQ,
    MTShareTypeWechatVideo,
    MTShareTypeRegQQVideo,
    MTShareTypeDownloadToLibiary
};


typedef NS_ENUM(NSInteger, MTShareActionType){
    
    MTShareActionTypeCollention = 0,
    MTShareActionTypeReport,
    MTShareActionTypeDownload,
    MTShareActionTypeCopylink
//    MTShareActionTypeDislike
};


@class SharePopView;

@protocol VideoSahreDelegate <NSObject>


- (void)onShareItemClicked:(SharePopView *)sharePopView index:(MTShareType)index;

- (void)onActionItemClicked:(SharePopView *)sharePopView index:(MTShareActionType)index;

@end


@interface SharePopView:UIView

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;

@property(nonatomic,strong) HomeListModel * homeListModel;
@property(nonatomic, weak)id <VideoSahreDelegate> delegate;




- (void)show;
- (void)dismiss;

@end


@interface ShareItem:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;



-(void)startAnimation:(NSTimeInterval)delayTime;

@end


