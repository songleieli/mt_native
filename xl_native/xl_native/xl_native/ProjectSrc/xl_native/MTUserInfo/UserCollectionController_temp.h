//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultSubViewController.h"
#import "NetWork_mt_getHotSearchSix.h"
#import "HYPageView.h"

@interface UserCollectionController_temp : ZJBaseViewController<HYPageViewDelegate,
UIViewControllerTransitioningDelegate>

//head
@property(nonatomic,strong) HYPageView *pageView;

@end
