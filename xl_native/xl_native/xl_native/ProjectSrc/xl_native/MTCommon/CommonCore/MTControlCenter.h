//
//  CenterControl.h
//  HeBeiFM
//
//  Created by 经纬中天 on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NetWork_mt_upgrade.h"

@interface MTControlCenter : NSObject


@property (nonatomic, assign) BOOL isDrawActive; //是否显示活动


/*
 *检查版本更新
 */
+ (void)checkVersion;

@end
