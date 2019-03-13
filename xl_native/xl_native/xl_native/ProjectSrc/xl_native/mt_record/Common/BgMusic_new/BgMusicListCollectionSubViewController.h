//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionSubMusicCell.h"


@protocol SubCollectionDelegate <NSObject>

-(void)subMusicClick:(GetMusicCollectionModel *)model;

@end

@interface BgMusicListCollectionSubViewController : ZJBaseViewController<SearchResultSubMusicDelegate>


@property(nonatomic,strong) NSString *parameter;
@property (nonatomic, weak) id<SubCollectionDelegate> delegate;


@end
