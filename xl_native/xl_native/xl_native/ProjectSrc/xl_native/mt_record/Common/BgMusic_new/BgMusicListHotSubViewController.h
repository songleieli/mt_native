//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "MusicHotSubMusicCell.h"
#import "MusicDownloadHelper.h"


@protocol SubHotDelegate <NSObject>

-(void)subMusicClick:(MusicModel *)model;

@end

@interface BgMusicListHotSubViewController : ZJBaseViewController<MusicHotSubDelegate>


@property(nonatomic,strong) NSString *parameter;
@property (nonatomic, weak) id<SubHotDelegate> delegate;

@property (nonatomic,strong) AVPlayer *player;


@property(nonatomic,strong) MusicDownloadHelper* bgmHelper;
//@property(nonatomic,weak) id<MusicDownloadListener> bgmListener;
@property(nonatomic,copy) NSString*bgmPath;



@end
