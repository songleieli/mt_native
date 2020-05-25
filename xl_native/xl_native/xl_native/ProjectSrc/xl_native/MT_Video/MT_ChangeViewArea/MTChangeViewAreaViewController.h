//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabCollectionViewController.h"
#import "NetWork_mt_scenic_getHotScenicList.h"
#import "NetWork_mt_scenic_getScenicListByAreaParam.h"
#import "TagsFrame.h"
#define kHEIGHT     (isIPhoneXAll?sizeScale(300.0f):sizeScale(275.0f))       //headImage Height

@interface MTChangeViewAreaViewController : ZJBaseViewController

@property (nonatomic,strong) TagsFrame *tagsFrame;//标签
@property (nonatomic,strong) NSMutableArray   *arrayhotSpotStrs;
@property (nonatomic,strong) NSMutableArray   *arrayhotSpotModel;

@end
