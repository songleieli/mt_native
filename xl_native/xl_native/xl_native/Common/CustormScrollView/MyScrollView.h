//
//  MyScrollView.h
//  中酒批
//
//  Created by ios on 13-12-19.
//  Copyright (c) 2013年 Ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"

@protocol MyScrolDelegate;

@interface MyScrollView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer *scrolTimer;
@property (strong, nonatomic) UIScrollView *scrolDefault;
@property (strong, nonatomic) UIPageControl *pageDefault;
@property (assign, nonatomic) BOOL isUrlImg; //当前加载的是Url图片还是本地图片
@property (assign, nonatomic) BOOL isAutoScroll; //图片加载完成后，是否自动滚动
@property (assign, nonatomic) BOOL isDisplayPageDefault; //是否显示UIPageControl

@property (weak, nonatomic) id<MyScrolDelegate> scrolDelegate;

- (void)reloadData:(NSArray*)source;

@end


@protocol MyScrolDelegate <NSObject>

- (void)myScrolView:(MyScrollView *)scrol didSelectedImgWithRow:(NSInteger)row;

@end
