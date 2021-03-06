//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "UserCollectionSubMusicCell.h"


@protocol SubMusicCellDelegate <NSObject>

-(void)subMusicClick:(MusicSearchModel *)model;

@end

@interface UserCollectionSubMusicViewController : ZJBaseViewController<SearchResultSubMusicDelegate>


@property(nonatomic,strong) NSString *parameter;
@property (nonatomic, weak) id<SubMusicCellDelegate> delegate;


@end
