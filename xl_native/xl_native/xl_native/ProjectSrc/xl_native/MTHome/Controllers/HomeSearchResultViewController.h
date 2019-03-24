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

@interface HomeSearchResultViewController : ZJBaseViewController<HYPageViewDelegate,SubCellDelegate,UIViewControllerTransitioningDelegate>

//title
@property (nonatomic,strong) UIView *textFieldBgView;
@property (nonatomic,strong) UIButton *cancleButton;
@property (nonatomic,strong) UITextField * textFieldSearchKey;
@property (nonatomic,assign) BOOL hasKeyBordShow;

//head
@property(nonatomic,strong) HYPageView *pageView;
@property (nonatomic,copy) NSString *keyWord;

- (instancetype)initWithKeyWord:(NSString*)keyWord;

@end
