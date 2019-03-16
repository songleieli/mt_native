//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultSubViewController.h"


#import "HYPageView.h"

#import "BgMusicListHotSubViewController.h"
#import "BgMusicListCollectionSubViewController.h"

@protocol UseHotMusicDelegate <NSObject>

-(void)useHotMusicClick:(NSString *)musiLocalPath;

@end

@interface BgMusicListViewController : ZJBaseViewController<HYPageViewDelegate>




//head
@property(nonatomic,strong) HYPageView *pageView;
@property (nonatomic, weak) id<UseHotMusicDelegate> delegate;

@end
