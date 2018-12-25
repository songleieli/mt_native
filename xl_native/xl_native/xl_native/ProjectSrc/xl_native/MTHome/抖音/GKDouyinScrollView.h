//
//  GKDouyinScrollView.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKDouyinScrollView : UIScrollView

//本段代码，暂时先使用网上下载的，等有时间回过头来重构g左右滑动的代码
//暂时使用isPanUse 参数控制

/** 是否禁止，GKDouyinScrollView 向右滑动，默认NO */
@property (nonatomic, assign) BOOL  isPanUse;

@end
