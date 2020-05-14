//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabBarLjhTableViewController.h"

#import <MAMapKit/MAMapKit.h> //高德地图
#import "NetWork_mt_scenic_getScenicByAreaParam.h"
#import "MyScrollView.h"
#import "TagsFrame.h"


#define kHEIGHT     (isIPhoneXAll?sizeScale(300.0f):sizeScale(275.0f))       //headImage Height

@interface MTScenicspotViewController : ZJCustomTabBarLjhTableViewController

@property (nonatomic, strong) ScenicModel* scenicModel; //当前景区 Model
@property (nonatomic,strong) MyScrollView   *scrolBanner;//Banner轮播图
@property (nonatomic,strong) TagsFrame *tagsFrame;//标签

@end
