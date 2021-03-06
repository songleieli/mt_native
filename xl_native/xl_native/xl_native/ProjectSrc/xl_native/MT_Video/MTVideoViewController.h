//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabCollectionViewController.h"

#import <MAMapKit/MAMapKit.h> //高德地图

#define kHEIGHT     (isIPhoneXAll?sizeScale(300.0f):sizeScale(275.0f))       //headImage Height

@interface MTVideoViewController : ZJCustomTabCollectionViewController

@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;


@property (nonatomic,strong) UIButton   *btnCurScenic;//景区按钮
@property (nonatomic,strong) UIButton   *btnRecommend;//推荐按钮

@property (nonatomic,assign) BOOL  isRecommend;//当前选择的是否推荐

@end
