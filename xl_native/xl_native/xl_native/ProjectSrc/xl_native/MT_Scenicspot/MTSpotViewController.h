//
//  FirstFunctionViewController.h
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ZJCustomTabCollectionViewController.h"

#define kHEIGHT     (isIPhoneXAll?sizeScale(300.0f):sizeScale(275.0f))       //headImage Height

@interface MTSpotViewController : ZJBaseViewController

@property (nonatomic,strong) ScenicSpotModel *model;//景点Model
@property (nonatomic,strong) MyScrollView   *scrolBanner;//Banner轮播图


@end
