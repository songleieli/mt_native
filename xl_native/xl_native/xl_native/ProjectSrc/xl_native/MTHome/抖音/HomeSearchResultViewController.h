//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "NetWork_mt_getHotSearchSix.h"

@interface HomeSearchResultViewController : ZJBaseViewController

//title
@property (nonatomic,strong) UIView *textFieldBgView;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong) UITextField * textFieldSearchKey;
@property (nonatomic,assign) BOOL hasKeyBordShow;

//head
@property (nonatomic,strong) UIView * viewHeadBg;

@property (nonatomic, copy) void(^backClickBlock)();

@end
