//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "MusicHotSubMusicCell.h"
#import "MusicDownloadHelper.h"

@protocol SubCollectionDelegate <NSObject>

-(void)subMusicClick:(MusicModel *)model;

@end

@interface BgMusicListCollectionSubViewController : ZJBaseViewController<MusicHotSubDelegate>


@property(nonatomic,strong) NSString *parameter;
@property (nonatomic, weak) id<SubCollectionDelegate> delegate;

@property (nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) MusicDownloadHelper* bgmHelper;
@property(nonatomic,copy) NSString*bgmPath;

@end
