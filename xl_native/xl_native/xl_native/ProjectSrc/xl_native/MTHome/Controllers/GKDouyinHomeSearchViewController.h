//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultViewController.h"
#import "MTSearchHeadFunctionView.h"

#import "NetWork_mt_getHotSearchSix.h"
#import "NetWork_mt_getHotVideoList.h"

#import "HomeSearchCell.h"

@interface GKDouyinHomeSearchViewController : ZJBaseViewController<HomeSearchDelegate,UIViewControllerTransitioningDelegate>

//title
@property (nonatomic,strong) UIView *textFieldBgView;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong) UITextField * textFieldSearchKey;
@property (nonatomic,assign) BOOL hasKeyBordShow;

//返回播放列表Block
@property (nonatomic, copy) void(^backClickBlock)();

//head
@property (nonatomic,strong) UIView * viewHeadBg;
@property (nonatomic, strong) UILabel *lableHeadTitle;
@property (nonatomic, strong) UILabel *lableHeadBottomTitle;
@property(nonatomic,strong) MTSearchHeadFunctionView *functionView;


@end
